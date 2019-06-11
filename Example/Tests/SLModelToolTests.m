//
//  SLModelToolTests.m
//  SLModelSqliteObjCKit_Tests
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLModelTool.h"

@interface SLModelToolTests : XCTestCase

@end

@implementation SLModelToolTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testClassIvarNameTypeDict {
    
    NSDictionary *dict = [SLModelTool classIvarNameTypeDictOfClass:NSClassFromString(@"SLStu")];
    NSLog(@"%@", dict);
}

- (void)testClassIvarNameSQLiteTypeDict {
    NSDictionary *dict = [SLModelTool classIvarNameSQLiteTypeDictOfClass:NSClassFromString(@"SLStu")];
    NSLog(@"%@", dict);
}

- (void)testColumn {
    NSString *sql = [SLModelTool componentsClassIvarNamesAndSQLiteTypesStringOfClass:NSClassFromString(@"SLStu")];
    NSLog(@"%@", sql);
}

- (void)testTableName {
    NSLog(@"%@", [SLModelTool tableNameOfClass:NSClassFromString(@"SLStu")]);
}

- (void)testAllTableSortedIvarNames {
    NSArray *array = [SLModelTool sortedIvarNamesOfClass:NSClassFromString(@"SLStu")];
    NSLog(@"%@", array);
}

- (void)testTrimming {
    NSString *ivarType = @"@\"NSString\"123";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@\""];
    ivarType = [ivarType stringByTrimmingCharactersInSet:set];
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
