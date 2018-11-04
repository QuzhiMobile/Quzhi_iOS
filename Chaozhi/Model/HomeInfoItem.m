//
//  HomeInfoItem.m
//  Chaozhi
//
//  Created by zhanbing han on 2018/10/11.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "HomeInfoItem.h"

@implementation HomeInfoItem

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"activity_list":[HomeActivityItem class],@"banner_list":[HomeBannerItem class]};
}

@end

@implementation HomeActivityItem

- (void)setImg:(NSString *)img {
    if (_img != img) {
        if ([img containsString:@"http"]) {
            _img = img;
        } else {
            _img = [NSString stringWithFormat:@"http:%@",img];
        }
    }
}

@end

@implementation HomeBannerItem

- (void)setImg:(NSString *)img {
    if (_img != img) {
        if ([img containsString:@"http"]) {
            _img = img;
        } else {
            _img = [NSString stringWithFormat:@"http:%@",img];
        }
    }
}

@end

@implementation HomeCategoryItem

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"try_video_list":[HomeTryVideoItem class],@"teacher_list":[HomeTeacherItem class],@"feature_product_list":[HomeFeatureProductItem class]};
}

@end


@implementation HomeFeatureProductItem

- (void)setImg:(NSString *)img {
    if (_img != img) {
        if ([img containsString:@"http"]) {
            _img = img;
        } else {
            _img = [NSString stringWithFormat:@"http:%@",img];
        }
    }
}

@end

@implementation HomeTryVideoItem

@end

@implementation HomeTeacherItem

- (void)setPhoto:(NSString *)photo {
    if (_photo != photo) {
        if ([photo containsString:@"http"]) {
            _photo = photo;
        } else {
            _photo = [NSString stringWithFormat:@"http:%@",photo];
        }
    }
}

@end

@implementation  HomeNewsListItem

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"rows":[HomeNewsItem class]};
}

@end

@implementation  HomeNewsItem

- (void)setImg:(NSString *)img {
    if (_img != img) {
        if ([img containsString:@"http"]) {
            _img = img;
        } else {
            _img = [NSString stringWithFormat:@"http:%@",img];
        }
    }
}

@end

