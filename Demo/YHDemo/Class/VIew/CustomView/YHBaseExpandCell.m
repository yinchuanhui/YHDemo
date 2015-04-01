//
//  YHExpandCell.m
//  YHDemo
//
//  Created by ych on 15/1/14.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHBaseExpandCell.h"

@interface YHBaseExpandCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign)CGFloat        _fatherCellHeigh;    //点击区域高度
@property (nonatomic, assign)CGFloat        _expandCellHeight;   //展开的cell高度
@property (nonatomic, retain)UIScrollView   *_scrollView;        //防止expandTableView在cell中滚动
@property (nonatomic, retain)UITableView    *_expandTableView;   //显示展开后的数据

@end

@implementation YHBaseExpandCell

#pragma mark - Public Method

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier fartherCellHeighe:(CGFloat)fatherCellHeight expandCellHeight:(CGFloat)expandCellHeight
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        __fatherCellHeigh = fatherCellHeight;
        __expandCellHeight = expandCellHeight;
        
        __expandTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, 0)];
        __expandTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        __expandTableView.dataSource = self;
        __expandTableView.delegate = self;
        __expandTableView.scrollEnabled = NO;
        __expandTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:__expandTableView];
        
        _defaultLabel = [[UILabel alloc] init];
        _defaultLabel.backgroundColor = [UIColor clearColor];
        _defaultLabel.textAlignment = NSTextAlignmentLeft;
        [_defaultLabel setTextColor:kYH_Color_RGBA(0, 0, 0, 1.0)];
        [_defaultLabel setFont:kYH_Font_Normal(20)];
        [self addSubview:_defaultLabel];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)refreshWithData:(NSMutableArray *)dataSource{
    self.dataSource = [NSMutableArray arrayWithArray:dataSource];
    [__expandTableView reloadData];
}

#pragma mark - Private Method

- (void)layoutSubviews{
    _defaultLabel.frame = CGRectMake(5, 0, self.frame.size.width-5, __fatherCellHeigh);
    __expandTableView.frame = CGRectMake(0, __fatherCellHeigh, self.frame.size.width, _dataSource.count*__expandCellHeight);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ([[_dataSource objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(baseExpandCellSelected:withObject:)]) {
        [_delegate baseExpandCellSelected:self  withObject:[_dataSource objectAtIndex:indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return __expandCellHeight;
}

@end
