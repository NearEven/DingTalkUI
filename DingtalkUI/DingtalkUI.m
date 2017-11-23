//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  DingtalkUI.m
//  DingtalkUI
//
//  Created by  HYY on 2017/11/21.
//  Copyright (c) 2017年 com.laiwang.DingTalk. All rights reserved.
//

#import "DingtalkUI.h"
#import <UIKit/UIKit.h>
#import "CaptainHook.h"
#import <MDSettingCenter/MDSettingCenter.h>
#import <MDSettingCenter/MDSettingsViewController.h>
#import <DingtalkPod/DingtalkPod.h>
#import "DingtalkUI.h"
#import "CoordinateForm.h"

@implementation DingtalkUI

+ (instancetype)sharedInstance{
    static DingtalkUI *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DingtalkUI alloc] init];
    });
    return instance;
}

// 添加悬浮球
- (void)addToWindow:(UIWindow *)window{
    MDSuspendBall *ballInstance = [MDSuspendBall sharedInstance];
    [ballInstance addToWindow:window];
}
@end

CHDeclareClass(MDSettingsViewController)

// 设置fxform
CHOptimizedMethod0(self, void,MDSettingsViewController, setupSubViews){
    CHSuper0(MDSettingsViewController, setupSubViews);
    FXFormController *controller = [self valueForKeyPath:@"formController"];
    CoordinateForm *cForm = [[CoordinateForm alloc] init];
    controller.form  = cForm;
}

// 设置coordinate
CHDeclareMethod0(void, MDSettingsViewController, modifyCoordinate){
    FXFormController *controller = [self valueForKeyPath:@"formController"];
    CoordinateForm *form = controller.form;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([form.latitude doubleValue], [form.longitude doubleValue]);
    [[DingtalkPod alloc] setLocation:coordinate];
}
// 搜索coordinate
CHDeclareMethod0(void, MDSettingsViewController, searchCoordinate){
    
}

CHConstructor{
    CHLoadLateClass(MDSettingsViewController);
    CHHook0(MDSettingsViewController, setupSubViews);
}



