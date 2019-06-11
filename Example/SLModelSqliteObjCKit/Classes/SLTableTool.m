//
//  SLTableTool.m
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLTableTool.h"
#import "SLModelTool.h"
#import "SLSqliteTool.h"

@implementation SLTableTool

+ (NSArray<NSString *> *)tableSortedColumnNamesOfClass:(Class)cls UID:(NSString *)UID {
    // 1.获取表名
    NSString *tableName = [SLModelTool tableNameOfClass:cls];
    
    // 2.根据表名获取创建表的SQL语句
    NSString *queryCreateSQL = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    NSMutableArray *array = [SLSqliteTool querySql:queryCreateSQL UID:UID];
    NSMutableDictionary *dictM = array.firstObject;
    
    NSString *createTableSQL = [dictM[@"sql"] lowercaseString];
    if (!createTableSQL.length) return nil;
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\""];
    createTableSQL = [createTableSQL stringByTrimmingCharactersInSet:set];
    
    createTableSQL = [createTableSQL stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createTableSQL = [createTableSQL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createTableSQL = [createTableSQL stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    // 3.获取所有字段名及类型的字符串
    NSString *nameType = [createTableSQL componentsSeparatedByString:@"("][1];
    
    // 4.分割：获取每个字段名和类型
    NSArray *nameTypes = [nameType componentsSeparatedByString:@","];
    // 5.获取所有字段名
    NSMutableArray *names = [NSMutableArray array];
    for (NSString *nameType in nameTypes) {
        if ([nameType containsString:@"primary"]) continue; // 过滤主键
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" "];
        NSString *nameType2 = [nameType stringByTrimmingCharactersInSet:set];
        
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        [names addObject:name];
    }
    
    // 5.将所有字段名进行排序
    [names sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return names;
}

@end
