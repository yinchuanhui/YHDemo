//
//  YHChartDemoViewController.m
//  YHDemo
//
//  Created by ych on 15/3/13.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHChartDemoViewController.h"
#import "YHChartTableViewCell.h"

@interface YHChartDemoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *_tableView;

@end

@implementation YHChartDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    __tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __tableView.showsVerticalScrollIndicator = NO;
    [__tableView setDelegate:self];
    [__tableView setDataSource:self];
    [__tableView reloadData];
    [self.view addSubview:__tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TableViewCell";
    
    YHChartTableViewCell *cell = (YHChartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YHChartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    YHChartTableViewCell *chartCell = (YHChartTableViewCell *)cell;
    [chartCell configUI:indexPath];
}

@end
