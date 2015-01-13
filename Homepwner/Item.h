//
//  Item.h
//  RandomItems
//
//  Created by Andrew Bell on 8/15/14.
//  Copyright (c) 2014 Andrew Bell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;

+(instancetype)randomItem;

// Designated initializer for Item
-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;
-(instancetype)initWithItemName:(NSString *)name;

@end
