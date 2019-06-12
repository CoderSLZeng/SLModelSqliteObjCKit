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
    // 1.1.校验是否指定主键
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSAssert(nil, @"【cls】 必须遵守 【SLModelProtocol】 协议 并实现 【+ (NSString *)primaryKey;】 来告诉我主键信息");
    }
    
    NSString *primaryKey = [cls primaryKey];
    
    // 1.2.获取表名
    NSString *tableName = [SLModelTool tableNameOfClass:cls];
    
    // 1.3.获取一个模型里面多有的字段和类型
    NSString *cloumnStr = [SLModelTool componentsClassIvarNamesAndSQLiteTypesStringOfClass:cls];
    
    // 1.4.拼接SQL语句
    NSString *createTableSQL = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key (%@))", tableName, cloumnStr, primaryKey];
    
    // 2.执行SQL语句
    return [SLSqliteTool excuteSQL:createTableSQL UID:UID];
}

+ (BOOL)isTableRequiredUpdateOfClass:(Class)cls UID:(NSString *)UID {
    NSArray *modelNames = [SLModelTool sortedIvarNamesOfClass:cls];
    NSArray *tableNames = [SLTableTool tableSortedColumnNamesOfClass:cls UID:UID];
    return ![modelNames isEqualToArray:tableNames];
}

+ (BOOL)updateTableOfClass:(Class)cls UID:(NSString *)UID {
    // 1.创建一个拥有正确结构的临时表
    // 1.1.校验是否指定主键
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSAssert(nil, @"【cls】 必须遵守 【SLModelProtocol】 协议 并实现 【+ (NSString *)primaryKey;】 来告诉我主键信息");
    }
    NSString *primaryKey = [cls primaryKey];
    
    // 1.2.临时表名
    NSString *tmpTableName = [SLModelTool tempTableNameOfClass:cls];
    
    // 1.3.创建执行多条SQL语句的容器
    NSMutableArray *executeSQLs = [NSMutableArray array];
    
    // 1.4.获取一个模型里面多有的字段和类型
    NSString *cloumnStr = [SLModelTool componentsClassIvarNamesAndSQLiteTypesStringOfClass:cls];
    // 1.5.创建临时表的SQL语句
    NSString *createTableSQL = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTableName, cloumnStr, primaryKey];
    [executeSQLs addObject:createTableSQL];
    
    // 2.根据主键插入数据
    NSString *sourceTableName = [SLModelTool tableNameOfClass:cls];
    NSString *insertData4PrimaryKeySQL = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, sourceTableName];
    [executeSQLs addObject:insertData4PrimaryKeySQL];
    
    // 3.根据主键，把所有的数据更新到新表里面
    NSArray *sourceCloumnNames = [SLTableTool tableSortedColumnNamesOfClass:cls UID:UID];
    NSArray *targetCloumnNames = [SLModelTool sortedIvarNamesOfClass:cls];
    
    for (NSString *targetClomunName in targetCloumnNames) {
        if (![sourceCloumnNames containsObject:targetClomunName]) continue;
        
        NSString *updateSQL = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)",
                               tmpTableName,
                               targetClomunName,
                               targetClomunName,
                               sourceTableName,
                               tmpTableName,
                               primaryKey,
                               sourceTableName,
                               primaryKey];
        
        [executeSQLs addObject:updateSQL];
    }
    
    // 4.删除原表
    NSString *deleteSourceTableSQL = [NSString stringWithFormat:@"drop table if exists %@", sourceTableName];
    [executeSQLs addObject:deleteSourceTableSQL];
    
    // 5.临时表名更改原表名
    NSString *renameTmpTalbeNameSQL = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTableName, sourceTableName];
    [executeSQLs addObject:renameTmpTalbeNameSQL];
    return [SLSqliteTool excuteSQLs:executeSQLs UID:UID];
    
}


@end
