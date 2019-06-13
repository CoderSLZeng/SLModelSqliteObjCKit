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
    [self checkPrimaryKeyOfClass:cls];
    
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
    [self checkPrimaryKeyOfClass:cls];
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
    
    // 3.1.获取更名字典
    NSDictionary *newNameToOldNameDict = nil;
    if ([cls respondsToSelector:@selector(newNameToOldNameDict)]) {
        newNameToOldNameDict = [cls newNameToOldNameDict];
    }
    
    for (NSString *targetClomunName in targetCloumnNames) {
        
        NSString *oldName = targetClomunName;
        
        // 找映射的旧的字段名称
        if ([newNameToOldNameDict[targetClomunName] length] != 0) {
            oldName = newNameToOldNameDict[targetClomunName];
        }
        
        if ((![sourceCloumnNames containsObject:targetClomunName] && ![sourceCloumnNames containsObject:oldName]) || [targetClomunName isEqualToString:primaryKey]) continue;
        
        // update 临时表 set 新字段名称 = (select 旧字段名 from 旧表 where 临时表.主键 = 旧表.主键)
        NSString *updateSQL = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)",
                               tmpTableName,
                               targetClomunName,
                               oldName,
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

+ (BOOL)saveOrUpateModel:(id)model UID:(NSString *)UID {
    
    // 1.获取模型的类名
    Class cls = [self modelClass:model];
    
    // 2.判断记录是否存在主键
    // 从表里面按照主键进行查询该记录
    NSString *tableName = [SLModelTool tableNameOfClass:cls];
    
    // 3.判断表名是否存在，不存在，则创建
    if (![SLTableTool isTableExistsOfClass:cls UID:UID]) {
        [self createTableOfClass:cls UID:UID];
    }
    
    // 4.检测表是否需要更新
    if ([self isTableRequiredUpdateOfClass:cls UID:UID]) {
        [self updateTableOfClass:cls UID:UID];
    }
    
    // 4.1.获取主键字段名
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    
    // 4.2.获取字段名数组
    NSArray *columnNames = [SLModelTool classIvarNameTypeDictOfClass:cls].allKeys;
    
    // 4.3获取字段值数组
    NSMutableArray *columnValues = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        id value = [model valueForKeyPath:columnName];
        
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            // 在这里把字典或数组，处理成为字符串，保存到数据库里面去
            // 字典/数组 -> data
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            
            // data -> NSString
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        
        [columnValues addObject:value];
    }
    
    NSMutableArray *setColumnNamesAndValues = [NSMutableArray array];
    for (NSUInteger i = 0; i < columnNames.count; i++) {
        NSString *columnName = columnNames[i];
        id columnValue = columnValues[i];
        NSString *setStr = [NSString stringWithFormat:@"%@='%@'", columnName, columnValue];
        [setColumnNamesAndValues addObject:setStr];
    }
    
    // 4.4更新字段
    NSString *checkSQL = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    NSArray *result = [SLSqliteTool querySQL:checkSQL UID:UID];
    NSString *excuteSQL = nil;
    if (result.count > 0) {
        excuteSQL = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'", tableName, [setColumnNamesAndValues componentsJoinedByString:@", "], primaryKey, primaryValue];
    } else {
        excuteSQL = [NSString stringWithFormat:@"insert into %@( %@ ) values( '%@' )", tableName, [columnNames componentsJoinedByString:@","], [columnValues componentsJoinedByString:@"', '"]];
    }
    
    return [SLSqliteTool excuteSQL:excuteSQL UID:UID];
}



+ (BOOL)deleteModel:(id)model UID:(nullable NSString *)UID {
    
    // 1.获取模型的类名
    Class cls = [self modelClass:model];

    // 2.获取表名
    NSString *tableName = [SLModelTool tableNameOfClass:cls];
    
    // 3.获取主键名和值
    NSString *primaryKeyName = [cls primaryKey];
    id primaryKeyValue = [model valueForKeyPath:primaryKeyName];
    
    // 4.主键名和值处理删除SQL语句
    NSString *deleteModelSQL = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, primaryKeyName, primaryKeyValue];
    return [SLSqliteTool excuteSQL:deleteModelSQL UID:UID];
}

+ (BOOL)deleteModel:(id)model UID:(nullable NSString *)UID whereText:(NSString *)whereText {
    // 1.获取模型的类名
    Class cls = [self modelClass:model];
    
    // 2.获取表名
    NSString *tableName = [SLModelTool tableNameOfClass:cls];

    // 3.删除SQL语句
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from %@", tableName];
    if (whereText.length > 0) {
        deleteSQL = [deleteSQL stringByAppendingFormat:@" where %@", whereText];
    }
    
    return [SLSqliteTool excuteSQL:deleteSQL UID:UID];
}

+ (BOOL)deleteModel:(id)model
                UID:(NSString *)UID
         columnName:(NSString *)columnName
           relation:(SLColumnNameToValueRelationType)relation
              columnValue:(id)columnValue {
    
    // 1.获取模型的类名
    Class cls = [self modelClass:model];
    
    // 2.获取表名
    NSString *tableName = [SLModelTool tableNameOfClass:cls];
    
    // 3.删除SQL语句
    NSString *relationType = [self columnNameToValueRelationTypeDict][@(relation)];
    NSString *deleteModelSQL = [NSString stringWithFormat:@"delete from %@ where %@ %@ '%@'", tableName, columnName, relationType, columnValue];
    return [SLSqliteTool excuteSQL:deleteModelSQL UID:UID];
}

+ (NSArray *)queryModelsOfClass:(Class)cls
                            UID:(nullable NSString *)UID
                            SQL:(NSString *)SQL {
    NSMutableArray<NSMutableDictionary *> *results = [SLSqliteTool querySQL:SQL UID:UID];
    return [self parseResults:results withClass:cls];
}

+ (NSArray *)queryAllModelsOfClass:(Class)cls UID:(nullable NSString *)UID {
    NSString *tableName = [SLModelTool tableNameOfClass:cls];
    
    NSString *SQL = [NSString stringWithFormat:@"select * from %@", tableName];
    return [self queryModelsOfClass:cls UID:UID SQL:SQL];
    
}

+ (NSArray *)queryModelsOfClass:(Class)cls
                            UID:(nullable NSString *)UID
                     columnName:(NSString *)columnName
                       relation:(SLColumnNameToValueRelationType)relation
                    columnValue:(id)columnValue {
    NSString *tableName = [SLModelTool tableNameOfClass:cls];
    NSString *relationType = [self columnNameToValueRelationTypeDict][@(relation)];
    NSString *SQL = [NSString stringWithFormat:@"select * from %@ where %@ %@ '%@'", tableName, columnName, relationType, columnValue];
    return [self queryModelsOfClass:cls UID:UID SQL:SQL];
    
}


#pragma mark - 私有方法
/**
 检查是否有主键

 @param cls 数据模型类
 */
+ (void)checkPrimaryKeyOfClass:(Class _Nonnull)cls {
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSAssert(nil, @"【cls】 必须遵守 【SLModelProtocol】 协议 并实现 【+ (NSString *)primaryKey;】 来告诉我主键信息");
    }
}

/**
 获取模型的类名

 @param model 模型
 @return 模型的类名
 */
+ (Class)modelClass:(id _Nonnull)model {
    Class cls = [model class];
    [self checkPrimaryKeyOfClass:cls];
    return cls;
}

+ (NSArray *)parseResults:(NSArray<NSMutableDictionary *> *)results withClass:(Class)cls {
    NSMutableArray *models = [NSMutableArray array];
    
    NSDictionary *nameTypeDict = [SLModelTool classIvarNameTypeDictOfClass:cls];
    
    for (NSMutableDictionary *modelDict in results) {
        id model = [[cls alloc] init];
        
        [modelDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *type = nameTypeDict[key];
            
            id resultValue = obj;
            
            if ([type isEqualToString:NSStringFromClass([NSArray class])] || [type isEqualToString:NSStringFromClass([NSDictionary class])]) {

                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            } else if ([type isEqualToString:NSStringFromClass([NSMutableArray class])] || [type isEqualToString:NSStringFromClass([NSMutableDictionary class])]) {

                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
        
            [model setValue:resultValue forKey:key];
        }];
        
        [models addObject:model];
    }
    return models;
}

+ (NSDictionary<NSNumber *, NSString *> *)columnNameToValueRelationTypeDict {
    return @{
             @(SLColumnNameToValueRelationTypeMore)      : @">",
             @(SLColumnNameToValueRelationTypeLess)      : @"<",
             @(SLColumnNameToValueRelationTypeEqual)     : @" =",
             @(    SLColumnNameToValueRelationTypeMoreEqual) : @">=",
             @(SLColumnNameToValueRelationTypeLessEqual) : @"<="
             };
}

@end
