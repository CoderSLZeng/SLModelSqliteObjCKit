//
//  SLSqliteToolTests.m
//  SLModelSqliteObjCKit_Tests
//
//  Created by CoderSLZeng on 2019/6/10.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLSqliteTool.h"

@interface SLSqliteToolTests : XCTestCase

@end

@implementation SLSqliteToolTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {

    NSString *sql = @"create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real)";
    BOOL result = [SLSqliteTool excuteSQL:sql UID:nil];
    XCTAssertEqual(result, YES);
}

- (void)testQuery {
    
    NSString *sql = @"select * from t_stu";
    NSMutableArray *result = [SLSqliteTool querySQL:sql UID:nil];
    NSLog(@"%@", result);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
