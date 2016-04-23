//
//  ZGProfileTool.m
//  Yeps
//
//  Created by weimi on 16/4/21.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGProfileTool.h"
#import "ZGProfileSettingItemModel.h"

static NSArray *_items = nil;

static NSArray *_settingItems = nil;

@implementation ZGProfileTool

+ (NSArray *)items {
    if (_items == nil) {
        ZGProfileSettingItemModel *model0 = [[ZGProfileSettingItemModel alloc] init];
        model0.title = @"编辑资料";
        model0.type = ZGProfileSettingItemTypeInfo;
        
        ZGProfileSettingItemModel *model1 = [[ZGProfileSettingItemModel alloc] init];
        model1.title = @"编辑标签";
        model1.type = ZGProfileSettingItemTypeTag;
        
        
        ZGProfileSettingItemModel *model3 = [[ZGProfileSettingItemModel alloc] init];
        model3.title = @"消息";
        model3.type = ZGProfileSettingItemTypeMessage;
        
        
        ZGProfileSettingItemModel *model5 = [[ZGProfileSettingItemModel alloc] init];
        model5.title = @"分享应用";
        model5.type = ZGProfileSettingItemTypeShare;
        
        ZGProfileSettingItemModel *model6 = [[ZGProfileSettingItemModel alloc] init];
        model6.title = @"关于Yeps";
        model6.type = ZGProfileSettingItemTypeAbout;
        
        
        ZGProfileSettingItemModel *model7 = [[ZGProfileSettingItemModel alloc] init];
        model7.title = @"退出登录";
        model7.type = ZGProfileSettingItemTypeLogout;
        _items = @[@[model0, model1], @[model3], @[model5, model6], @[model7]];
    }
    return _items;
}

+ (NSArray *)settingItems {
    if (_settingItems == nil) {
        ZGProfileSettingItemModel *model2 = [[ZGProfileSettingItemModel alloc] init];
        model2.title = @"修改密码";
        model2.type = ZGProfileSettingItemTypeModifyPassword;
        
        ZGProfileSettingItemModel *model4 = [[ZGProfileSettingItemModel alloc] init];
        model4.title = @"清除缓存";
        model4.type = ZGProfileSettingItemTypeClearCache;
        
        _settingItems = @[model2, model4];
    }
    return _settingItems;
}

+ (NSArray *)profileItems {
    return [self items];
}

+ (NSArray *)profileSettingItems {
    return [self settingItems];
}

+ (UIImage *)profileBackImage {
    NSArray *images = @[@"profileBack",
                               @"profileBack1",
                               @"profileBack2",
                               @"profileBack3",
                               @"profileBack4",
                               @"profileBack5",
                               @"profileBack6",
                               @"profileBack7",
                               @"profileBack8",
                               @"profileBack9",
                               @"profileBack10",
                               @"profileBack11",
                               @"profileBack12",
                               @"profileBack13",
                               @"profileBack14",
                               ];
    NSInteger index = random() % images.count;
    return [UIImage imageNamed:images[index]];
}

@end
