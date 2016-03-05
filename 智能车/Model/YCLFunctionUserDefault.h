//
//  YCLFunctionClearUserDefault.h
//  YCLCar
//
//  Created by user on 16/3/5.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author Orange-W, 16-03-05 18:03:37
 *
 *  @brief 清楚应用所有个人信息
 */
@interface YCLFunctionUserDefault : NSObject
+ (NSArray *)userDefaultArray;


+ (BOOL)clearAll;
+ (BOOL)clearWithName:(NSString *)name;
+ (BOOL)clearWithNameArray:(NSArray *)array;
@end
