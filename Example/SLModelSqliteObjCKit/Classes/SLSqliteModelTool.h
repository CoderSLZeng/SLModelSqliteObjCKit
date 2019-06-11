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

/**
 将类名作为数据模型创建数据表

 @param cls 类名
 @param UID 根据UID打开相应的数据库
 @return 是否创建成功
 */
+ (BOOL)createTableOfClass:(Class)cls UID:(nullable NSString *)UID;

@end

NS_ASSUME_NONNULL_END
