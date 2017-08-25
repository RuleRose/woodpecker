//
//  UITableViewCell+roundCorner.h
//  unicorn
//
//  Created by 肖君 on 16/12/17.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (roundCorner)
- (void)addRoundCornerOfIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
@end
