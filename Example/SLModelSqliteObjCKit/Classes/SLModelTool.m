//
//  SLModelTool.m
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLModelTool.h"
#import <objc/runtime.h>

@implementation SLModelTool

#pragma mark - 接口
+ (NSString *)tableNameOfClass:(Class)cls {
    return NSStringFromClass(cls);
}

+ (NSMutableDictionary<NSString *, NSString *> *)classIvarNameTypeDictOfClass:(Class)cls {
    // 1.获类里所有的成员变量
    unsigned int outCount = 0;
    Ivar *ivarList = class_copyIvarList(cls, &outCount);
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    // 2.变量所有的成员变量
    for (int i = 0; i < outCount; i++) {
        
        // 2.1.获取成员变量
        Ivar ivar = ivarList[i];
        
        // 2.3.获取成员变量的名称
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        if ([ivarName hasPrefix:@"_"] ) {
            ivarName = [ivarName substringFromIndex:1];
        }
        
        // 2.4.获取成员变量的类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)]; // @\"NSString\"

//        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@\"" withString:@""];
//        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@\""];
        ivarType = [ivarType stringByTrimmingCharactersInSet:set];
        
        [dictM setValue:ivarType forKey:ivarName];
    }
    
    return dictM;
}

+ (NSMutableDictionary<NSString *, NSString *> *)classIvarNameSQLiteTypeDictOfClass:(Class)cls {
    NSMutableDictionary *dictM = [self classIvarNameTypeDictOfClass:cls];
    
    NSDictionary *typeDict = [self ocTypeToSQLiteTypeDict];
    [dictM enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        dictM[key] = typeDict[obj];
    }];
    
    return dictM;
}

+ (NSString *)componentsClassIvarNamesAndSQLiteTypesStringOfClass:(Class)cls {
    NSMutableDictionary *dictM = [self classIvarNameSQLiteTypeDictOfClass:cls];
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:dictM.count];
    [dictM enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [arrayM addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
    }];
    
    NSString *result = [arrayM componentsJoinedByString:@", "];
    return  [result substringToIndex:result.length];
    
}

#pragma mark - 私有方法
+ (NSDictionary<NSString *, NSString *> *)ocTypeToSQLiteTypeDict {
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };

}
@end
