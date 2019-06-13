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

//+ (NSDictionary *)newNameToOldNameDict {
//    return @{@"age" : @"age2"};
//}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"name = %@, "
            "stuNum = %d, "
            "age2 = %d, "
            "height = %f, "
            "isRich = %d, "
            "score = %f, "
            "score2 = %f, "
            "b = %d, "
            "array = %@, "
            "arryM = %@, "
            "dict = %@, "
            "dictM = %@",
            self.name,
            self.stuNum,
            self.age2,
            self.height,
            self.isRich,
            self.score,
            self.score2,
            b,
            self.array,
            self.arrayM,
            self.dict,
            self.dictM
            ];
}

@end
