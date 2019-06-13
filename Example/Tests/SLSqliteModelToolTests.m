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
    
    SLPerson *per = [[SLPerson alloc] init];
    per.perNum = 1987;
    per.name = @"jim";
    per.age2 = 31;
    
    BOOL isSuccess = [SLSqliteModelTool saveOrUpateModel:per UID:nil];
    XCTAssertTrue(isSuccess);
}

- (void)testSaveModel2 {
    SLStu *stu = [[SLStu alloc] init];
    stu.stuNum = 1985;
    stu.age2 = 19;
    stu.name = @"jack";
    stu.isRich = YES;
    stu.score = 99;
    stu.height = 170;
    
    stu.dict = @{
                 @"国籍" : @"中国",
                 @"省份" : @"广东省",
                 @"管辖市" : @"东莞市"
                 };
    
    stu.array = stu.dict.allKeys;
    stu.arrayM = [NSMutableArray arrayWithArray:stu.dict.allValues];
    
    stu.dictM = [NSMutableDictionary dictionary];
    [stu.dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [stu.dictM setValue:key forKey:obj];
    }];
    
    
    BOOL isSuccess = [SLSqliteModelTool saveOrUpateModel:stu UID:nil];
    XCTAssertTrue(isSuccess);
}

- (void)testDeleteModel {
    SLPerson *per = [[SLPerson alloc] init];
    per.perNum = 1987;
    per.name = @"jim";
    per.age2 = 31;
    BOOL isDelete = [SLSqliteModelTool deleteModel:per UID:nil];
    XCTAssertTrue(isDelete);
}

- (void)testDeleteModel1 {
    
    BOOL isDelete = [SLSqliteModelTool deleteModel:[SLPerson class] UID:nil whereText:@"name = 'jack'"];
    XCTAssertTrue(isDelete);
}

- (void)testDeleteModel2 {
    BOOL isDelete = [SLSqliteModelTool deleteModel:[SLPerson class]
                                               UID:nil
                                        columnName:@"age2"
                                          relation:SLColumnNameToValueRelationTypeLess
                                       columnValue:@30];
    XCTAssertTrue(isDelete);
}

- (void)testQueryAllModel {
    NSArray *models = [SLSqliteModelTool queryAllModelsOfClass:[SLStu class] UID:nil];
    NSLog(@"%@", models);
}

- (void)testQueryModel1 {
    NSArray *models = [SLSqliteModelTool queryModelsOfClass:[SLStu class] UID:nil SQL:@"select * from t_slstu where age2 = '18';"];
    NSLog(@"%@", models);
}

- (void)testQueryModel2 {
    NSArray *models = [SLSqliteModelTool queryModelsOfClass:[SLStu class]
                                                        UID:nil
                                                 columnName:@"stuNum"
                                                   relation:SLColumnNameToValueRelationTypeLess
                                                columnValue:@1986];
    NSLog(@"%@", models);
}




- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
