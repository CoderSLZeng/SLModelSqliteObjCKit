//
//  SLSqliteModelTool.m
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLSqliteModelTool.h"
#import "SLModelTool.h"
#import "SLModelProtocol.h"
#import "SLSqliteTool.h"
#import "SLTableTool.h"

@implementation SLSqliteModelTool

+ (BOOL)createTableOfClass:(Class)cls UID:(NSString *)UID {
    
    // 1.拼接创建表格的SQL语句
    // 1.1.获取表名
    NSString *tableName = [SLModelTool tableNameOfClass:cls];
    
    // 1.2.获取主键
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSAssert(nil, @"【cls】 必须遵守 【SLModelProtocol】 协议 并实现 【+ (NSString *)primaryKey;】 来告诉我主键信息");
    }
    
    NSString *primaryKey = [cls primaryKey];
    
    // 1.3.获取一个模型里面多有的字段和类型
    NSString *cloumnStr = [SLModelTool componentsClassIvarNamesAndSQLiteTypesStringOfClass:cls];
    
    // 1.4.拼接SQL语句
    NSString *createTableSQL = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key (%@))", tableName, cloumnStr, primaryKey];
    
    // 2.执行SQL语句
    return [SLSqliteTool excuteSql:createTableSQL UID:UID];
}

+ (BOOL)isTableRequiredUpdateOfClass:(Class)cls UID:(NSString *)UID {
    NSArray *modelNames = [SLModelTool sortedIvarNamesOfClass:cls];
    NSArray *tableNames = [SLTableTool tableSortedColumnNamesOfClass:cls UID:UID];
    return ![modelNames isEqualToArray:tableNames];
}


@end
