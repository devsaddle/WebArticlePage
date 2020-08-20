//
//  WebViewController.m
//  WebArticlePage
//
//  Created by 马远 on 2020/8/18.
//  Copyright © 2020 马远. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self loadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

- (void)loadData {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.caixinglobal.com/2020-02-27/app/caixin-global-webinar-coronavirus-series-irebooting-the-economy-amid-coronavirus-101570752.html"]]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
        CGSize size = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
        if ([self.delegate respondsToSelector:@selector(webViewContentHeightDidChange:)]) {
            [self.delegate webViewContentHeightDidChange:size.height];
        }

    }
}

- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];

    }
    return _webView;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
}
@end
