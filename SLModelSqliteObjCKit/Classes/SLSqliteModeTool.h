//
//  SLSqliteModelTool.h
//  SLModelSqliteObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLSqliteModelTool : NSObject

+ (BOOL)createTableOfClass:(Class)cls UID:(nullable NSString *)UID;

@end

NS_ASSUME_NONNULL_END
