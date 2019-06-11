//
//  SLSqliteModelToolTests.m
//  SLModelSqliteObjCKit_Tests
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLSqliteModelTool.h"

@interface SLSqliteModelToolTests : XCTestCase

@end

@implementation SLSqliteModelToolTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCreateTable {
    BOOL isSuccess = [SLSqliteModelTool createTableOfClass:NSClassFromString(@"SLStu") UID:nil];
    XCTAssertTrue(isSuccess);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
