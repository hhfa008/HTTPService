//
//  HTTPServiceTests.m
//  HTTPServiceTests
//
//  Created by youkia on 2017/10/23.
//  Copyright © 2017年 hhfa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestModel.h"

@interface HTTPServiceTests : XCTestCase

@end

@implementation HTTPServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetModel {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetModel"];
    [TestModel reqFrom:self block:^(TestModel* response, NSError *error) {
        
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response isKindOfClass:[TestModel class]]);
        XCTAssertTrue([response.url isEqualToString:TestModel.path]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:^(NSError * _Nullable error) {
        
    }];
}

@end
