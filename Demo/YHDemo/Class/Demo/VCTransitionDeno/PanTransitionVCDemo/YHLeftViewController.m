//
//  YHLeftViewController.m
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#define kCellHeigh 60

#import "YHLeftViewController.h"
#import "YHCenterViewController.h"
#import "YHRightViewController.h"
#import "YHExpandCell.h"
#import "YHRunloopDemo1ViewController.h"
#import "YHRunloopDemo2ViewController.h"
#import "YHRunloopDemo4ViewController.h"
#import "YHRunTimeDemo1ViewController.h"
#import "YHRunloopDemo2ViewController.h"

@interface YHLeftViewController ()<YHBaseExpandCellDelegate>{
    NSDictionary *demoDic;
    NSArray *demoDicKeys;
    UITableView *demoTableView;
    NSIndexPath *selectedIndexPath;
}

@end

@implementation YHLeftViewController

- (id)initWithDemoDic:(NSDictionary *)_demoDic{
    if (self == [super initWithNibName:nil bundle:nil]) {
        demoDic = _demoDic;
        demoDicKeys = [demoDic objectForKey:@"Category"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = kYH_Color_RGBA(202, 221, 244, 1.0);
    self.view.frame = CGRectMake(0, 0, 230, kYH_ScreenHeight);
    
    demoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20) style:UITableViewStylePlain];
    demoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    demoTableView.showsVerticalScrollIndicator = NO;
    [demoTableView setDelegate:self];
    [demoTableView setDataSource:self];
    [demoTableView reloadData];
    [demoTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:demoTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return demoDicKeys.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DemoCell";
    
    YHExpandCell *cell = (YHExpandCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YHExpandCell alloc] initWithReuseIdentifier:CellIdentifier fartherCellHeighe:kCellHeigh expandCellHeight:kCellHeigh];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.defaultLabel.text = [demoDicKeys objectAtIndex:[indexPath row]];
    
    if (indexPath == selectedIndexPath) {
        NSMutableArray *a = [demoDic objectForKey:[demoDicKeys objectAtIndex:indexPath.row]];
        [cell refreshWithData:a];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedIndexPath && selectedIndexPath.row == indexPath.row) {
        selectedIndexPath = nil;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        selectedIndexPath = indexPath;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndexPath && indexPath.row == selectedIndexPath.row) {
        NSMutableArray *array = [demoDic objectForKey:[demoDicKeys objectAtIndex:indexPath.row]];
        return kCellHeigh + kCellHeigh*array.count;
    }else{
        return kCellHeigh;
    }
}

#pragma mark - YHBaseExpandCellDelegate

- (void)baseExpandCellSelected:(YHBaseExpandCell *)cell withObject:(id)arg{
    NSMutableDictionary *dic = (NSMutableDictionary *)arg;
    NSString *vcName = [dic objectForKey:@"main_vc"];
    Class class = NSClassFromString(vcName);
    YHBaseViewController *vc = [[class alloc] init];
    vc.readMeFileName = [dic objectForKey:@"read_me"];
    
    kYH_RootNav = [[UINavigationController alloc] initWithRootViewController:vc];
#ifdef kYHPanTransitionViewController
    [kYH_RootVC changeCenterVC:kYH_RootNav];
    [kYH_RootVC hideLeftView];
#endif
}

@end
