//
//  ViewController.m
//  WKWebviewLocal
//
//  Created by Gary Newby on 12/10/14.
//  Copyright (c) 2014 Gary Newby. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>


@interface ViewController () <WKScriptMessageHandler, WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *callJavascriptButton;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIButton *scriptButton;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // WKWebView
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    
    // Add addScriptMessageHandler in javascript: window.webkit.messageHandlers.MyObserver.postMessage()
    [controller addScriptMessageHandler:self name:@"MyObserver"];
    configuration.userContentController = controller;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 20, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, CGRectGetHeight([UIScreen mainScreen].bounds) - 84) configuration:configuration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    // baseURL needs to be set for local files to load correctly
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test_local" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:[NSBundle mainBundle].resourceURL];
 
}

- (IBAction)callJavascriptTapped:(id)sender
{
    NSString *script = @"testJS()";
    [self.webView evaluateJavaScript:script completionHandler:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"evaluateJavaScript error:%@", [error localizedDescription]);
        } else {
            NSLog(@"evaluateJavaScript result:%@", result);
        }
    }];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // Callback from javascript: window.webkit.messageHandlers.MyObserver.postMessage(message)
    NSString *text = (NSString *)message.body;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Javascript said:" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK");
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
{
    NSLog(@"didFinishNavigation");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
