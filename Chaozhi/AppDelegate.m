//
//  AppDelegate.m
//  Chaozhi
//
//  Created by Jason on 2018/5/2.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Push.h"
#import "XZTabBarVC.h"
#import <IQKeyboardManager.h>
#import "NetworkUtil.h"
#import "CZGuideVC.h"
#import "UMMobClick/MobClick.h"
#import "DBManager.h"
#import "TNavigationController.h"
#import "ConversationController.h"
#import "SettingController.h"
#import "ContactsController.h"
#import "LoginController.h"
#import "TUITabBarController.h"
#import "TUIKit.h"
#import "THeader.h"
#import "ImSDK.h"
#import "GenerateTestUserSig.h"
#import "JPUSHService.h"
#import "BaseNC.h"

@interface AppDelegate ()<UIAlertViewDelegate>

@property (nonatomic,strong) UIAlertView *networkAlertView;
@property (nonatomic,strong) UIAlertView *notReachableAlertView;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self printFont]; //输出所有系统字体
    
    [[DBManager shareManager] createDBAndTable];
    
    [self iapCheck]; //内购凭证服务器二次校验，防止漏单
    
    if ([AppChannel isEqualToString:@"1"]) { //超职
        [self registerUMeng]; //注册友盟
    }
    
    [self initTXIM]; //注册腾讯IM
    
    [Utils changeUserAgent]; //WKWebView UA初始化
    
    [self registerPush:application options:launchOptions]; //注册激光推送

    //监测网络
    [[NetworkUtil sharedInstance] listening];
    [self talkFunNetworkCheck];
    
    //键盘事件
    [self processKeyBoard];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = PageColor;

    //判断是否首次进入应用
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLG"])
    {
        //将CZGuideVC作为根视图控制器
        CZGuideVC *guideVC = [[CZGuideVC alloc] init];
        self.window.rootViewController = guideVC;
        
        //使用block获取点击图片事件
        [guideVC setDoneBlock:^(){
            NSLog(@"点击“进入”进入应用");
            //进入应用主界面
            self.window.rootViewController = [self setTabBarController];
        }];
    } else {
        self.window.rootViewController = [self setTabBarController];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 欢拓网络监测
- (void)talkFunNetworkCheck {
    WeakSelf
    //网络检测
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.status = status;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 当网络状态改变时调用
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"没有网络");
                    [weakSelf.notReachableAlertView show];
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    
                    NSLog(@"手机自带网络");
                    [weakSelf.networkAlertView show];
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"WIFI");
                    [weakSelf.networkAlertView dismissWithClickedButtonIndex:0 animated:NO];
                    
                    [weakSelf.notReachableAlertView dismissWithClickedButtonIndex:0 animated:NO];
                    break;
            }
        });
    }];
}

- (UIAlertView *)networkAlertView {
    if (!_networkAlertView) {
        _networkAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定不在wifi环境下观看或下载?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _networkAlertView;
}

- (UIAlertView *)notReachableAlertView {
    if (!_notReachableAlertView) {
        _notReachableAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络中断!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
    }
    return _notReachableAlertView;
}

/** 输出得到所有的字体 */
- (void)printFont {
    NSArray *familyNames = [UIFont familyNames];
    for (NSString *familyName in familyNames) {
        printf("Family: %s \n",[familyName UTF8String]);
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for (NSString *fontName in fontNames) {
            printf("\tFont: %s \n",[fontName UTF8String]);
        }
        NSLog(@"\n----------输出字体种类-----------")
    }
}

#pragma mark - 腾讯IM配置
/** 腾讯IM配置 */
- (void)initTXIM {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserStatus:) name:TUIKitNotification_TIMUserStatusListener object:nil];
    
    [[TUIKit sharedInstance] setupWithAppId:imKey()];
    
    NSNumber *appId = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Appid];
    NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_User];
    NSString *userSig = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Sig];
    if([appId integerValue] == imKey() && identifier.length != 0 && userSig.length != 0){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __weak typeof(self) ws = self;
            TIMLoginParam *param = [[TIMLoginParam alloc] init];
            param.identifier = identifier;
            param.userSig = userSig;
            [[TIMManager sharedInstance] login:param succ:^{
                if (ws.deviceToken) {
                    TIMTokenParam *param = [[TIMTokenParam alloc] init];
                    /* 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。*/
                    //企业证书 ID
                    param.busiId = sdkBusiId;
                    [param setToken:ws.deviceToken];
                    [[TIMManager sharedInstance] setToken:param succ:^{
                        NSLog(@"-----> 上传 token 成功 ");
                    } fail:^(int code, NSString *msg) {
                        NSLog(@"-----> 上传 token 失败 ");
                    }];
                }
                
            } fail:^(int code, NSString *msg) {
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:Key_UserInfo_Appid];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_User];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_Pwd];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_Sig];
            }];
        });
    }
    else{
    }
}

- (void)onUserStatus:(NSNotification *)notification {
    TUIUserStatus status = [notification.object integerValue];
    switch (status) {
        case TUser_Status_ForceOffline:
        {
            XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"下线通知" content:@"您的帐号于另一台手机上登录。" leftButtonTitle:@"" rightButtonTitle:@"退出"];
            alert.doneBlock = ^{
                [Utils logout:NO]; //不跳登录页面
                // 极光推送清除别名
                [JPUSHService setAlias:@"" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                } seq:0];
                // 腾讯IM退出
                [[TIMManager sharedInstance] logout:^{
                    [[TUILocalStorage sharedInstance] logout];
                } fail:^(int code, NSString *msg) {
                    NSLog(@"");
                }];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccNotification object:nil];

                BaseNC *nc = CZAppDelegate.tabVC.selectedViewController;
                [[nc topViewController].navigationController popViewControllerAnimated:NO];
                [nc topViewController].tabBarController.selectedIndex = 0;
                
                [Utils changeUserAgent]; //WKWebView UA初始化
            };
        }
            break;
        case TUser_Status_ReConnFailed:
        {
            NSLog(@"连网失败");
        }
            break;
        case TUser_Status_SigExpired:
        {
            NSLog(@"userSig过期");
        }
            break;
        default:
            break;
    }
}

#pragma mark - 内购凭证校验
- (void)iapCheck {
    NSString *receipt = [CacheUtil getCacherWithKey:kIapCheck];
    if (![Utils isBlankString:receipt]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             receipt, @"receipt",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_IapPayCheck parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                [Utils showToast:@"课程购买成功"];
                [CacheUtil saveCacher:kIapCheck withValue:@""];
            }
        }];
    }
}

#pragma mark - 注册友盟

- (void)registerUMeng {
    //初始化友盟统计
    UMConfigInstance.appKey = kUMKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //应用趋势分析(版本分布)
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //日志加密设置
    [MobClick setEncryptEnabled:YES]; //加密，默认为NO(不加密)
}

#pragma mark - 进入首页

- (UITabBarController *)setTabBarController {
    if ([AppChannel isEqualToString:@"1"]) { //超职
        //第一步：要获取单独控制器所在的UIStoryboard
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //第二步：获取该控制器的Identifier并赋给你的单独控制器
        _tabVC = [story instantiateViewControllerWithIdentifier:@"TabBarController"];
    }
    if ([AppChannel isEqualToString:@"2"]) { //学智
        _tabVC = [[XZTabBarVC alloc] init];
    }
    _tabVC.delegate = self;
    
    return _tabVC;
}

- (void)processKeyBoard {
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    //这里我判断的是当前点击的tabBarItem的标题
    NSString *tabBarTitle = viewController.tabBarItem.title;
    if ([tabBarTitle isEqualToString:@"我的"]
        || [tabBarTitle isEqualToString:@"学习"]
        ) {
        if ([Utils isLoginWithJump:YES]) {
            return YES;
        } else {
            return NO;
        }
    }
    else {
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        //不管有没有完成，结束 background_task 任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    
    //获取未读计数
    int unReadCount = 0;
    NSArray *convs = [[TIMManager sharedInstance] getConversationList];
    for (TIMConversation *conv in convs) {
        if([conv getType] == TIM_SYSTEM){
            continue;
        }
        unReadCount += [conv getUnReadMessageNum];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;
    
    //doBackground
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:unReadCount];
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        NSLog(@"doBackgroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[TIMManager sharedInstance] doForeground:^() {
        NSLog(@"doForegroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
