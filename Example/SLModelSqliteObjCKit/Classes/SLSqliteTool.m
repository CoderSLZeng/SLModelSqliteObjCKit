//
//  SLSqliteTool.m
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/10.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLSqliteTool.h"
#import <sqlite3.h>

//#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kCachePath @"/Users/zeng/Desktop"

sqlite3 *ppDb = nil;

@implementation SLSqliteTool

#pragma mark - 接口
+ (BOOL)excuteSQL:(NSString *)SQL UID:(NSString *)UID {
    // 1.打开数据库
    BOOL isOpen = [self openDBWithUID:UID];
    
    if (!isOpen) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    
    // 2.执行语句
    BOOL result = sqlite3_exec(ppDb, SQL.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    // 3.关闭数据
    [self closeDB];
    
    return result;
}

+ (BOOL)excuteSQLs:(NSArray<NSString *> *)SQLs UID:(NSString *)UID {
    
    // 开启事物
    [self excuteSQL:@"begin transaction" UID:UID];
    
    for (NSString *SQL in SQLs) {
        BOOL result = [self excuteSQL:SQL UID:UID];
        if (!result) {
            // 回滚事物
            [self excuteSQL:@"rollback transaction" UID:UID];
            return NO;
        }
    }
    
    // 提交事物
    [self excuteSQL:@"commit transaction" UID:UID];
    return YES;
    
    return NO;
}

+ (NSMutableArray<NSMutableDictionary *> *)querySQL:(NSString *)SQL UID:(NSString *)UID {
    // 1.打开数据库
    [self openDBWithUID:UID];
    
    // 2.创建准备语句
    // 参数1: 一个已经打开的数据库
    // 参数2: sql语句
    // 参数3: 参数2取出多少字节的长度 -1 自动计算
    // 参数4: 准备语句
    // 参数5: 通过参数3, 取出参数2的长度字节之后, 剩下的字符串
    sqlite3_stmt *ppStmt = nil;
    if (sqlite3_prepare_v2(ppDb, SQL.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"准备语句编译失败");
        return nil;
    }
    
    // 2.绑定数据(省略)
    
    // 3.单步执行
    NSMutableArray *rowDictArray = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        // 一行记录 -> 字典
        // 1.获取所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        NSMutableDictionary *rowDict = [NSMutableDictionary dictionary];
        // 2.遍历所有的列
        for (int i = 0; i < columnCount; i++) {
            // 2.1.获取列名
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            
            // 2.2.获取列值
            // 不同列的类型，使用不同的函数，进行获取
            // 2.2.1.获取类的类型
            int type = sqlite3_column_type(ppStmt, i);
            // 2.2.2.根据列的类型，使用不同的函数，进行获取
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE_TEXT:
                    value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(ppStmt, i)];
                    break;
                default:
                    break;
            }
            [rowDict setValue:value forKey:columnName];           
        }
        
        [rowDictArray addObject:rowDict];
    }
    
    // 4. 重置(省略)
    
    // 5. 释放资源
    sqlite3_finalize(ppStmt);
    
    [self closeDB];
    
    return rowDictArray;
}

#pragma mark - 私有方法
/**
 打开数据库

 @param UID 根据UID打开对应的数据库
 @return 返回是否成功打开
 */
+ (BOOL)openDBWithUID:(NSString *)UID {
    
    NSString *dbName = @"common.sqlite";
    
    if (UID.length) {
        dbName = [NSString stringWithFormat:@"%@.sqlite", UID];
    }
    
    NSString *dbPath = [kCachePath stringByAppendingPathComponent:dbName];

    
    return sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
}

+ (void)closeDB {
    sqlite3_close(ppDb);
}


@end
