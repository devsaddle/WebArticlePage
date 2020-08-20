//
//  WebViewController.h
//  WebArticlePage
//
//  Created by 马远 on 2020/8/18.
//  Copyright © 2020 马远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WebViewControllerDelegate <NSObject>

- (void)webViewContentHeightDidChange:(CGFloat)height;

@end

@interface WebViewController : UIViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, weak) id<WebViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
