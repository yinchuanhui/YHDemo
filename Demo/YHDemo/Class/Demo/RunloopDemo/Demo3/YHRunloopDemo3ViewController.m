//
//  YHRunloopDemo3ViewController.m
//  YHDemo
//
//  Created by ych on 14-10-21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHRunloopDemo3ViewController.h"

@interface YHRunloopDemo3ViewController (){
    UILabel *label;
    int count;
}

@end

@implementation YHRunloopDemo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 250) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView reloadData];
    [self.view addSubview:tableView];
    
    label =[[UILabel alloc] initWithFrame:CGRectMake(10, 300, 100, 50)];
    [self.view addSubview:label];
    
    count = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 1
                                     target: self
                                   selector: @selector(incrementCounter:)
                                   userInfo: nil
                                    repeats: YES];
    /*
     NSTimer与NSURLConnection默认运行在default mode下，这样当用户在拖动UITableView处于UITrackingRunLoopMode模式时，NSTimer不能fire,NSURLConnection的数据也无法处理。
     在正常情况下，可看到每隔1s，label上显示的数字+1,但当你拖动或按住tableView时，label上的数字不再更新，当你手指离开时，label上的数字继续更新。当你拖动UItableView时，当前线程run loop处于UIEventTrackingRunLoopMode模式，在这种模式下，不处理定时器事件，即定时器无法fire,label上的数字也就无法更新。
     解决方法，一种方法是在另外的线程中处理定时器事件，可把Timer加入到NSOperation中在另一个线程中调度;还有一种方法时修改Timer运行的run loop模式，将其加入到UITrackingRunLoopMode模式或NSRunLoopCommonModes模式中。
     
     可屏蔽下面的代码来看却别
     */
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    
    
    
    /*
     NSURLConnection也是如此，见SDWebImage中的描述,以及SDWebImageDownloader.m代码中的实现。修改NSURLConnection的运行模式可使用scheduleInRunLoop:forMode:方法。
     
     NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
     NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO]autorelease];
     [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
     [connection start];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)incrementCounter:(NSTimer *)theTimer
{
    count++;
    label.text = [NSString stringWithFormat:@"%d",count];
}

#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TableViewCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
