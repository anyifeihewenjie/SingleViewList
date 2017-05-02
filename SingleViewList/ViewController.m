//
//  ViewController.m
//  SingleViewList
//
//  Created by anyifei’s Mac on 2017/3/6.
//  Copyright © 2017年 esteel. All rights reserved.
//

#import "ViewController.h"
#import "FilterListView.h"
@interface ViewController ()<FilterListViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FilterListView *listView = [[FilterListView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 45) createTitles:@"状态" withDataArray:@[@"全部",@"审核中",@"抢单中",@"运力匹配中"] withSelectData:@[@"0",@"3",@"6",@"5"]];
    listView.backgroundColor = [UIColor cyanColor];
    listView.delegate = self;
    [self.view addSubview:listView];

}
- (void)selectIndex:(NSString *)indexStr {

    NSLog(@"+++%@",indexStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
