//
//  SLSqliteModelTool.h
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ColumnNameToValueRelationType) {
    ColumnNameToValueRelationTypeMore,
    ColumnNameToValueRelationTypeLess,
    ColumnNameToValueRelationTypeEqual,
    ColumnNameToValueRelationTypeMoreEqual,
    ColumnNameToValueRelationTypeLessEqual
};

NS_ASSUME_NONNULL_BEGIN

@interface SLSqliteModelTool : NSObject

/**
 将类名作为数据模型创建数据表

 @param cls 类名
 @param UID 根据UID打开相应的数据库
 @return 是否创建成功
 */
+ (BOOL)createTableOfClass:(Class)cls UID:(nullable NSString *)UID;

/**
 判定表的数据是否需要更新

 @param cls 类名
 @param UID 根据UID打开相应的数据库
 @return 是否更新
 */
+ (BOOL)isTableRequiredUpdateOfClass:(Class)cls UID:(nullable NSString *)UID;

/**
 更新表的数据

 @param cls 类名
 @param UID 根据UID打开相应的数据库
 @return 是否更新成功
 */
+ (BOOL)updateTableOfClass:(Class)cls UID:(nullable NSString *)UID;

/**
 保存或更新模型

 @param model 数据模型
 @param UID 根据UID打开相应的数据库
 @return 是否保存或更新成功
 */
+ (BOOL)saveOrUpateModel:(id)model UID:(nullable NSString *)UID;

/**
 根据数据模型删除记录

 @param model 数据模型
 @param UID 根据UID打开相应的数据库
 @return 是否删除
 */
+ (BOOL)deleteModel:(id)model UID:(nullable NSString *)UID;

/**
 根据数据模型和条件语句删除记录

 @param model 数据模型
 @param UID 根据UID打开相应的数据库
 @param whereText 条件语句
 @return 是否删除
 */
+ (BOOL)deleteModel:(id)model UID:(nullable NSString *)UID whereText:(NSString *)whereText;

/**
 根据数据模型和关系条件删除记录

 @param model 数据模型
 @param UID 根据UID打开相应的数据库
 @param columnName 字段名
 @param relation 条件关系
 @param columnValue 字段值
 @return 是否删除
 */
+ (BOOL)deleteModel:(id)model
                UID:(nullable NSString *)UID
         columnName:(NSString *)columnName
           relation:(ColumnNameToValueRelationType)relation
              columnValue:(id)columnValue;

/**
 根据数据模型类和SQL语句查询数据模型

 @param cls 数据模型类
 @param UID 根据UID打开相应的数据库
 @param SQL SQL语句
 @return 数据模型
 */
+ (NSArray *)queryModelsOfClass:(Class)cls
                            UID:(nullable NSString *)UID
                            SQL:(NSString *)SQL;

/**
 根据数据模型类查询所有的数据模型

 @param cls 数据模型类
 @param UID 根据UID打开相应的数据库
 @return 所有的数据模型
 */
+ (NSArray *)queryAllModelsOfClass:(Class)cls UID:(nullable NSString *)UID;

/**
 根据数据模型类和关系条件查询数据模型

 @param cls 数据模型类
 @param UID 根据UID打开相应的数据库
 @param columnName 字段名
 @param relation 关系
 @param columnValue 字段值
 @return 数据模型
 */
+ (NSArray *)queryModelsOfClass:(Class)cls
                            UID:(nullable NSString *)UID
                     columnName:(NSString *)columnName
                       relation:(ColumnNameToValueRelationType)relation
                          columnValue:(id)columnValue;


@end

NS_ASSUME_NONNULL_END
