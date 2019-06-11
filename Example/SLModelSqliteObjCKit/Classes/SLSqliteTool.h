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
 执行sql语句

 @param sql sql语句
 @param UID 根据UID打开相应的数据库
 @return 是否成功执行
 */
+ (BOOL)excuteSql:(NSString *)sql UID:(nullable NSString *)UID;

/**
 执行查询sql语句

 @param sql sql语句
 @param UID 根据UID打开相应的数据库
 @return 字典(一行记录)组成的数组
 */
+ (NSMutableArray <NSMutableDictionary *> *)querySql:(nullable NSString *)sql UID:(NSString * _Nullable)UID;

@end

NS_ASSUME_NONNULL_END
