//
//  Config.h
//  Chaozhi
//  Notes：接口地址【文档：http://101.201.222.8/showdoc/web/#/1 密码：abc123】
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

#pragma mark - ---------------接口地址---------------

NSString *domainUrl(void);

#pragma mark - ---------------接口名称---------------

#define URL_PhoneCaptcha @"api/phone-captcha" //获取验证码
#define URL_Login @"api/user/login" //登录
#define URL_Reg @"api/user/reg" //注册
#define URL_Reset @"api/user/reset" //重置密码
#define URL_UserInfo @"api/user/info" //用户信息
#define URL_AppHome @"api/app/home" //首页
#define URL_CategoryList @"api/category/list" //课程分类

#pragma mark - ---------------H5地址---------------

NSString *h5Url(void);

#pragma mark - ---------------H5名称---------------

#define H5_Orders @"#/hybrid/orders" //我的-课程订单页面
#define H5_Message @"#/hybrid/message" //我的-我的消息
#define H5_Coupon @"#/hybrid/coupon" //我的-我的优惠券
#define H5_Question @"#/hybrid/study/question/${id}" //学习-题库

@end