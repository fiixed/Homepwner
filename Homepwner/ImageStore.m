//
//  ImageStore.m
//  Homepwner
//
//  Created by Andrew Bell on 1/7/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation ImageStore

+ (instancetype)sharedStore
{
    static ImageStore *sharedStore;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// No one should call init

- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use + [ImageStore sharedStore]"];
    
    return nil;
}

// Secret designated initializer

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    // Create a full path for image
    NSString *imagePath = [self imagePathForKey:key];
    
    // Turn image into JPEG data
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
//    NSData *data = UIImagePNGRepresentation(image);
    
    // Write it to full path
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    // If possible, get it from the dictionary
    UIImage *result = self.dictionary[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        // Create a UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        // if we found an image on the file system, place it into the cache
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find %@", imagePath);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %lu images out of the cache", (unsigned long)[self.dictionary count]);
    [self.dictionary removeAllObjects];
    
}

@end
