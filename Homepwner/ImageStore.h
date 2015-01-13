//
//  ImageStore.h
//  Homepwner
//
//  Created by Andrew Bell on 1/7/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;


@end
