//
//  WPSafetyViewController.m
//  
//
//  Created by QiWL on 2017/11/11.
//

#import "WPSafetyViewController.h"

@interface WPSafetyViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView* webView;


@end

@implementation WPSafetyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"安全要求及注意事项";
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    
}

- (void)setupViews{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavigationHeight + kStatusHeight, kScreen_Width, kScreen_Height - (kNavigationHeight + kStatusHeight))];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.multipleTouchEnabled=YES;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"safety" withExtension:@"html"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[XJFHUDManager defaultInstance] showLoadingHUDwithCallback:^{
        
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[XJFHUDManager defaultInstance]  hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[XJFHUDManager defaultInstance]  hideLoading];
    [[XJFHUDManager defaultInstance]  showTextHUD:@"加载失败"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
