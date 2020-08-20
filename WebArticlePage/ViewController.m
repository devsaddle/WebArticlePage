//
//  ViewController.m
//  WebArticlePage
//
//  Created by 马远 on 2020/8/17.
//  Copyright © 2020 马远. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "WebViewController.h"

@interface ViewController ()<UIScrollViewDelegate,TableViewControllerDelegate, WebViewControllerDelegate>
{
    CGFloat _webViewContentH;
    CGFloat _tableViewContentH;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TableViewController *tableVC;
@property (nonatomic, strong) WebViewController *webVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TableViewController *tableVC = [[TableViewController alloc] init];
    tableVC.delegate = self;
    [self addChildViewController:tableVC];
    self.tableVC = tableVC;
    
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.delegate = self;
    [self addChildViewController:webVC];
    self.webVC = webVC;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:webVC.view];
    [self.scrollView addSubview:tableVC.view];
    

    [self layoutViews];
    
}

- (void)layoutViews {
    self.scrollView.frame = self.view.bounds;
    self.webVC.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, 0);
    self.tableVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.webVC.view.frame), self.scrollView.frame.size.width, 0);
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);

}

#pragma mark - WebViewControllerDelegate
- (void)webViewContentHeightDidChange:(CGFloat)height {
    _webViewContentH = height;
    [self updateViewContentSize];
}

#pragma mark - TableViewControllerDelegate
- (void)tableViewContentHeightDidChange:(CGFloat)height {
    _tableViewContentH = height;
    [self updateViewContentSize];
}

- (void)updateViewContentSize{

    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _webViewContentH + _tableViewContentH);

    //webView、tableView 内容高度不足一屏则为内容高，大于一屏为一屏高
    CGFloat webViewHeight = (_webViewContentH < self.view.bounds.size.height) ? _webViewContentH : self.view.bounds.size.height ;
    CGFloat tableViewHeight = _tableViewContentH < self.view.bounds.size.height ? _tableViewContentH : self.view.bounds.size.height;

    CGRect webFrame = self.webVC.view.frame;
    webFrame.size.height = webViewHeight <= 0.1 ?0.1 :webViewHeight;;
    self.webVC.view.frame = webFrame;
    
    CGRect tabFrame = self.tableVC.view.frame;
    tabFrame.size.height = tableViewHeight <= 0.1 ?0.1 :tableViewHeight;;
    tabFrame.origin.y = CGRectGetMaxY(webFrame);
    self.tableVC.view.frame = tabFrame;

    [self scrollViewDidScroll:self.scrollView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_scrollView != scrollView) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat webViewHeight = self.webVC.view.frame.size.height;
    CGFloat tableViewHeight = self.tableVC.view.frame.size.height;
    
     if (offsetY <= 0) {
        //顶部
         
         CGRect webFrame = self.webVC.view.frame;
         webFrame.origin.y = 0;
         self.webVC.view.frame = webFrame;
         
         CGRect tabFrame = self.tableVC.view.frame;
         tabFrame.origin.y = CGRectGetMaxY(webFrame);
         self.tableVC.view.frame = tabFrame;
         
         self.webVC.webView.scrollView.contentOffset = CGPointZero;
         self.tableVC.tableView.contentOffset = CGPointZero;
         
    } else if(offsetY < _webViewContentH - webViewHeight){
        // webView 滚动区域

        
        CGRect webFrame = self.webVC.view.frame;
        webFrame.origin.y = offsetY;
        self.webVC.view.frame = webFrame;

        CGRect tabFrame = self.tableVC.view.frame;
        tabFrame.origin.y = CGRectGetMaxY(webFrame);
        self.tableVC.view.frame = tabFrame;

        self.webVC.webView.scrollView.contentOffset = CGPointMake(0, offsetY);
        self.tableVC.tableView.contentOffset = CGPointZero;
        
    } else if(offsetY < _webViewContentH){
        //webView 滚动到底部
        
        CGRect webFrame = self.webVC.view.frame;
        webFrame.origin.y = _webViewContentH - webViewHeight;
        self.webVC.view.frame = webFrame;

        CGRect tabFrame = self.tableVC.view.frame;
        tabFrame.origin.y = CGRectGetMaxY(webFrame);
        self.tableVC.view.frame = tabFrame;

        self.webVC.webView.scrollView.contentOffset = CGPointMake(0, _webViewContentH - webViewHeight);
        self.tableVC.tableView.contentOffset = CGPointZero;
        
    } else if(offsetY < _webViewContentH + _tableViewContentH - tableViewHeight){
        // tableView 区域

        CGRect webFrame = self.webVC.view.frame;
        webFrame.origin.y = offsetY - webViewHeight;
        self.webVC.view.frame = webFrame;

        CGRect tabFrame = self.tableVC.view.frame;
        tabFrame.origin.y = CGRectGetMaxY(webFrame);
        self.tableVC.view.frame = tabFrame;

        self.tableVC.tableView.contentOffset = CGPointMake(0, offsetY - _webViewContentH);
        self.webVC.webView.scrollView.contentOffset = CGPointMake(0, _webViewContentH - webViewHeight);
  
    } else if(offsetY <= _webViewContentH + _tableViewContentH ){
        //tableView 滚动到底部

        CGRect webFrame = self.webVC.view.frame;
        webFrame.origin.y = self.scrollView.contentSize.height - webFrame.size.height - self.tableVC.view.frame.size.height;
        self.webVC.view.frame = webFrame;

        CGRect tabFrame = self.tableVC.view.frame;
        tabFrame.origin.y = CGRectGetMaxY(webFrame);
        self.tableVC.view.frame = tabFrame;

        self.webVC.webView.scrollView.contentOffset = CGPointMake(0, _webViewContentH - webViewHeight);
        self.tableVC.tableView.contentOffset = CGPointMake(0, _tableViewContentH - tableViewHeight);
    }
}




- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor greenColor];
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _scrollView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    }
    return _scrollView;
}
@end
