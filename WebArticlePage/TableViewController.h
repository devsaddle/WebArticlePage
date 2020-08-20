//
//  TableViewController.h
//  WebArticlePage
//
//  Created by 马远 on 2020/8/18.
//  Copyright © 2020 马远. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TableViewControllerDelegate <NSObject>

- (void)tableViewContentHeightDidChange:(CGFloat)height;

@end

@interface TableViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<TableViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
