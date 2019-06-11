//
//  SLModelTool.h
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//  模型工具

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLModelTool : NSObject

/**
 获取数据库表名

 @param cls 类名
 @return 表名
 */
+ (NSString *)tableNameOfClass:(Class)cls;

/**
 将类中所有成员变量的 变量名做为键 和 变量类型作为值 组成字典

 @param cls 类名
 @return 成员变量名和类型组成字典
 */
+ (NSMutableDictionary<NSString *, NSString *> *)classIvarNameTypeDictOfClass:(Class)cls;

/**
 将类中所有成员变量的 变量名做为键 和 变量类型转换成SQLite类型作为值 组成字典

 @param cls 类名
 @return 成员变量名和SQLite类型组成字典
 */
+ (NSMutableDictionary<NSString *, NSString *> *)classIvarNameSQLiteTypeDictOfClass:(Class)cls;

/**
 将类中所有成员变量的 变量名 和 变量类型转换成SQLite类型 拼接成为一条SQL语句中的字段及类型字符串

 @param cls 类名
 @return 字段及类型字符串
 */
+ (NSString *)componentsClassIvarNamesAndSQLiteTypesStringOfClass:(Class)cls;

/**
 将类中所有成员变量的变量名进行排序

 @param cls 类名
 @return 排好序的成员变量名数据
 */
+ (NSArray<NSString *> *)sortedIvarNamesOfClass:(Class)cls;
@end

NS_ASSUME_NONNULL_END
