//
//  SLSqliteModelToolTests.m
//  SLModelSqliteObjCKit_Tests
//
//  Created by CoderSLZeng on 2019/6/11.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLSqliteModelTool.h"
#import "SLStu.h"
#import "SLPerson.h"

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

- (void)testIsTableRequiredUpdate {
    BOOL isSuccess = [SLSqliteModelTool isTableRequiredUpdateOfClass:NSClassFromString(@"SLStu") UID:nil];
    if (isSuccess) {
        BOOL isUpdate = [SLSqliteModelTool updateTableOfClass:NSClassFromString(@"SLStu") UID:nil];
        XCTAssertTrue(isUpdate);
    }
    XCTAssertTrue(isSuccess);
}

- (void)testSaveModel {
//    SLStu *stu = [[SLStu alloc] init];
//    stu.stuNum = 1988;
//    stu.age2 = 19;
//    stu.name = @"jack";
//    stu.isRich = YES;
//    stu.score = 99;
//    stu.height = 170;
    
    SLPerson *stu = [[SLPerson alloc] init];
    stu.perNum = 1987;
    stu.name = @"jim";
    stu.age2 = 31;
    
    BOOL isSuccess = [SLSqliteModelTool saveOrUpateModel:stu UID:nil];
    XCTAssertTrue(isSuccess);
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
