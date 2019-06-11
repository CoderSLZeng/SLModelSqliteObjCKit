//
//  SLStu.h
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLStu : NSObject <SLModelProtocol>
{
    int b;
}

@property (assign, nonatomic) int stuNum;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) int age;
@property (assign, nonatomic) float score;

@end

NS_ASSUME_NONNULL_END
