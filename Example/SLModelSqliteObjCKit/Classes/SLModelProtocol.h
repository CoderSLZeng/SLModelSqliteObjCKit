//
//  SLModelProtocol.h
//  SLModelSqliteObjCKit
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SLModelProtocol <NSObject>

@required
/**
 @return 主键
 */
+ (NSString *)primaryKey;

@optional
/**
 @return 忽略字段名
 */
+ (NSArray *)ignoreColumnNames;

@end
