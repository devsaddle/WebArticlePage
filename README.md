# WebArticlePage
WKWebView + UITableView 实现主流混合内容页，最大程度保留控件系统本身的优化。

## 实现原理
禁用 `WKWebView` & `UITableView` 自身滚动，将其添加到一个父 `UIScrollView`，由其父 `UIScrollView` 滚动效果作用至 `WKWebView` & `UITableView`。

关键代码位于 Demo 中 `ViewController` 内。

## 效果
![效果图](demo.gif)

