//
//  SLTableTool.h
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTableTool : NSObject
/**
 将数据表中所有的字段进行排序

 @param cls 类名
 @param UID 根据UID打开相应的数据库
 @return 排好序的字段名
 */
+ (nullable NSArray<NSString *> *)tableSortedColumnNamesOfClass:(Class)cls UID:(nullable NSString *)UID;
@end

NS_ASSUME_NONNULL_END
