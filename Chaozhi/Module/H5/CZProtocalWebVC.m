//
//  CZProtocalWebVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2019/6/10.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZProtocalWebVC.h"

@interface CZProtocalWebVC ()<WKNavigationDelegate>

@property (retain, nonatomic) WKWebView *webView;

@end

@implementation CZProtocalWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.webTitle;
    
    [self initWebView];
}

// WebView
- (void )initWebView {
    if (!_webView) {
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        configuration.allowsInlineMediaPlayback = true;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH) configuration:configuration];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;

        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    [self.view addSubview:_webView];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]];
    [self.webView loadHTMLString:self.homeUrl baseURL:baseURL];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [JHHJView hideLoading]; //结束加载
    
    //协议盖章
    NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"css"];
    NSString *jsSeal = [NSString stringWithFormat:@"<html> \ <head> \ <link rel=\"stylesheet\" type=\"text/css\" href=\"%@\"/> \
                                     <style type=\"text/css\"> \
                                     body {font-size:15px;}\
                                     </style> \
                                     </head> \
                                     <body> \
                                     <div class=\"dialog-agreement\"> \
                                     <div class=\"dialog-agreement-content\">%s</div> \
                                     </div> \
                                     </body> \
                                     </html>%@",cssPath];
    
    [_webView evaluateJavaScript:jsSeal completionHandler:^(id item, NSError * _Nullable error) {
        // 执行结果回调
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
