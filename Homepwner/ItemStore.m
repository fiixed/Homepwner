//
//  ItemStore.m
//  Homepwner
//
//  Created by Andrew Bell on 1/2/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "ItemStore.h"
#import "Item.h"
#import "ImageStore.h"

@interface ItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation ItemStore

+ (instancetype)sharedStore
{
    static ItemStore *sharedStore;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[ItemsStore sharedStore]"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
        [_privateItems addObject:@"No more items!"];
    }
    return self;
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (Item *)createItem
{
    Item *item = [[Item alloc] init];
    
    [self.privateItems insertObject:item atIndex:0];
    NSLog(@"%@", self.privateItems);
    
    return item;
}

- (void)removeItem:(Item *)item
{
    NSString *key = item.itemKey;
    
    [[ImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    // Get pointer to object being moved so you can reinsert it
    Item *item = self.privateItems[fromIndex];
    
    // Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // Insert item into array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
}

@end
