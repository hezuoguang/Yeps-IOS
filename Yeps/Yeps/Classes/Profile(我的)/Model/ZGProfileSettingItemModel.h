//
//  ZGProfileSettingItemModel.h
//  Yeps
//
//  Created by weimi on 16/4/21.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ZGProfileSettingItemTypeInfo,//编辑资料
    ZGProfileSettingItemTypeTag,//编辑标签
    ZGProfileSettingItemTypeModifyPassword,//修改密码
    
    ZGProfileSettingItemTypeMessage,//消息
    ZGProfileSettingItemTypeClearCache,//清除缓存
    
    ZGProfileSettingItemTypeShare,//分享应用
    ZGProfileSettingItemTypeAbout,//关于Yeps
    
    ZGProfileSettingItemTypeLogout,//退出登录
    
    
}ZGProfileSettingItemType;

@interface ZGProfileSettingItemModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *rightImage;
@property (nonatomic, assign) ZGProfileSettingItemType type;

@end
