//
//  SLSqliteTool.h
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/10.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLSqliteTool : NSObject

/**
 执行SQL语句

 @param SQL SQL语句
 @param UID 根据UID打开相应的数据库
 @return 是否成功执行
 */
+ (BOOL)excuteSQL:(NSString *)SQL UID:(nullable NSString *)UID;

/**
 执行多条SQL语句

 @param SQLs SQL语句
 @param UID 根据UID打开相应的数据库
 @return 是否成功执行
 */
+ (BOOL)excuteSQLs:(NSArray<NSString *> *)SQLs UID:(nullable NSString *)UID;

/**
 执行查询SQL语句

 @param SQL SQL语句
 @param UID 根据UID打开相应的数据库
 @return 字典(一行记录)组成的数组
 */
+ (NSMutableArray<NSMutableDictionary *> *)querySQL:(nullable NSString *)SQL UID:(NSString * _Nullable)UID;

@end

NS_ASSUME_NONNULL_END
