//
//  YHExpandCell.h
//  YHDemo
//
//  Created by ych on 15/1/14.
//  Copyright (c) 2015年 YH. All rights reserved.
//

/*!
 实现二级菜单，如需增加控件则继承此类
 
 实现原理：cell中增加UITableView用于展示二级列表，UITableView根据数据源确定高度，防止双重滚动效果
 使用：本类提供默认label用于简单展示数据，如果需要做复杂界面可再子类中增加，tableView的代理方法也可在子类重写来适应不同数据结构，点击cell会将数据源中的相应数据发送给代理
 */

#import <UIKit/UIKit.h>

@protocol YHBaseExpandCellDelegate;

@interface YHBaseExpandCell : UITableViewCell

@property (nonatomic, assign)id<YHBaseExpandCellDelegate> delegate;
@property (nonatomic, retain)NSMutableArray *dataSource;
@property (nonatomic, retain)UILabel *defaultLabel;

/*!
 初始化方法，
 
 @param reuseIdentifier
 @param fatherCellHeight 一级cell高度
 @param expandCellHeight 二级cell高度
 
 @return YHBaseExpandCell
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier fartherCellHeighe:(CGFloat)fatherCellHeight expandCellHeight:(CGFloat)expandCellHeight;

//刷新数据
- (void)refreshWithData:(NSMutableArray *)dataSource;

@end


@protocol YHBaseExpandCellDelegate <NSObject>

/*!
 二级cell点击代理方法，将相应数据发送给代理类处理
 
 @param cell
 @param arg  
 */
- (void)baseExpandCellSelected:(YHBaseExpandCell *)cell withObject:(id)arg;

@end
