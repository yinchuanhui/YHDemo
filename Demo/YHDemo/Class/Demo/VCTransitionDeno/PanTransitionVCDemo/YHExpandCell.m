//
//  YHExpandCell.m
//  YHDemo
//
//  Created by ych on 15/1/14.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHExpandCell.h"

@implementation YHExpandCell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kYH_Color_RGBA(202, 201, 244, 1.0);
    }
    
    NSMutableDictionary *demoDic = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [demoDic objectForKey:@"description"];
    
    return cell;
}

@end
