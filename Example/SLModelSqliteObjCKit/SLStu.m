//
//  SLStu.m
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLStu.h"

@implementation SLStu

+ (NSString *)primaryKey {
    return @"stuNum";
}

+ (NSArray *)ignoreColumnNames {
    return @[@"b", @"score2"];
}

@end
