//
//  ViewController.m
//  HTTPService
//
//  Created by youkia on 2017/10/11.
//  Copyright © 2017年 hhfa. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TestModel req:^(TestModel* response, NSError *error) {
        
    }];
    
    [TestModel reqFrom:self block:^(TestModel* response, NSError *error) {
        
    }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
