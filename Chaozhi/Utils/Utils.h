//
//  Utils.h
//  Chaozhi
//  Notes：工具类
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

#pragma mark - 类单例方法
+ (Utils *)share;

#pragma mark - 判断网络状态
+ (BOOL)getNetStatus;

#pragma mark - 获取当前时间
+(NSString *)getCurrentDate;

#pragma mark - 获取当前控制器
+ (UIViewController *)getCurrentVC;

#pragma mark - 1、判断是否登录，2、是否跳转到登录页面
+ (BOOL)isLoginWithJump:(BOOL)isJump;

#pragma mark - 1、退出登录，2、是否跳转到登录页面
+ (void)logout:(BOOL)isJumpLoginVC;

#pragma mark - 判断字符串是否为空
+ (BOOL)isBlankString:(id)string;

#pragma mark - 仿安卓消息提示
+ (void)showToast:(NSString *)message;

#pragma mark - 设置控件阴影
+ (void)setViewShadowStyle:(UIView *)view;

#pragma mark - 设置按钮显示、点击效果
- (void)setButtonClickStyle:(UIButton *)btn
                     Shadow:(BOOL)shadow
          normalBorderColor:(UIColor *)normalBorderColor
        selectedBorderColor: (UIColor *)selectedBorderColor
                BorderWidth:(int)borderWidth
                normalColor:(UIColor *)normalColor
              selectedColor:(UIColor *)selectedColor
               cornerRadius:(CGFloat)radius;

#pragma mark - 屏幕快照
+ (UIImage *)snapshotSingleView:(UIView *)view;

@end
