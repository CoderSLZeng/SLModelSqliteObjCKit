//
//  SLPerson.m
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/12.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLPerson.h"
#import "SLModelProtocol.h"
@interface SLPerson ()<SLModelProtocol>

@end

@implementation SLPerson

+ (NSString *)primaryKey {
    return @"perNum";
}
+ (NSDictionary *)newNameToOldNameDict {
    return @{@"age2" : @"age"};
}
@end
