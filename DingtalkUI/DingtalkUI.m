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
//#import "CaptainHook.h"
#import <MDSettingCenter/MDSettingCenter.h>
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


- (void)addToWindow:(UIWindow *)window{
    MDSuspendBall *ballInstance = [MDSuspendBall sharedInstance];
    [ballInstance addToWindow:window];
//    ballInstance
    
    SettingForm *form = [[SettingForm alloc] init];
    [form registerForm:[CoordinateForm new]];
    
    
//    [[DingtalkPod alloc] setLocation:nil];
}
@end

//CHDeclareClass(CoordinateForm)
//
//CHOptimizedMethod(0, self, void, CoordinateForm, submitCoordinate){
//    NSLog(@"asdlfkjasdl;fksadl;困死了");
//    
////    [NSNotificationCenter defaultCenter] postNotificationName:<#(nonnull NSNotificationName)#> object:<#(nullable id)#> userInfo:<#(nullable NSDictionary *)#>
//}
//
//CHConstructor{
//    CHLoadLateClass(CoordinateForm);
//    CHClassHook(0, CoordinateForm, submitCoordinate);
//}
//



//CHDeclareClass(CustomViewController)
//
//CHOptimizedMethod(0, self, NSString*, CustomViewController,getMyName){
//    return @"MonkeyDevPod";
//}
//
//CHConstructor{
//    CHLoadLateClass(CustomViewController);
//    CHClassHook(0, CustomViewController, getMyName);
//}

