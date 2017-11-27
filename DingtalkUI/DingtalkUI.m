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
#import "DingtalkUI.h"
#import "CoordinateForm.h"
#import "MapSearchViewController.h"
#import <MapKit/MapKit.h>
#import "POIAnnotation.h"
#import "DingtalkPluginConfig.h"
#import "DingtalkPod.h"

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
    MapSearchViewController *mapController = [[MapSearchViewController alloc] init];
    [mapController setSearchCoordinateBlock:^(CLLocationCoordinate2D coordinate) {
        [[DingtalkPod alloc] setLocation:coordinate];
        FXFormController *controller = [self valueForKeyPath:@"formController"];
        CoordinateForm *form = controller.form;
        form.latitude = [@(coordinate.latitude) stringValue];
        form.longitude = [@(coordinate.longitude) stringValue];
    }];

    [self.navigationController pushViewController:mapController animated:YES];
}

CHDeclareMethod0(void, MDSettingsViewController, aMapsearchCoordinate){
    NSURL *scheme = [NSURL URLWithString:@"iosamap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    
    NSURL *myLocationScheme = [NSURL URLWithString:@"iosamap://myLocation?sourceApplication=DingTalk"];
    if (canOpen) {
        if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) { //iOS10以后,使用新API
            [[UIApplication sharedApplication] openURL:myLocationScheme options:@{} completionHandler:^(BOOL success) {
                NSLog(@"scheme调用结束"); }];
            
        } else { //iOS10以前,使用旧API
            [[UIApplication sharedApplication] openURL:myLocationScheme];
            
        }
    }
    
 
    
    
}

CHOptimizedMethod0(self, void, MDSettingsViewController, exit){
    
    FXFormController *controller = [self valueForKeyPath:@"formController"];
    CoordinateForm *form = controller.form;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([form.latitude doubleValue], [form.longitude doubleValue]);
    [[DingtalkPod alloc] setLocation:coordinate];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改成功" message:@"sdafasdf" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
 
    CHSuper0(MDSettingsViewController, exit);
}


CHConstructor{
    CHLoadLateClass(MDSettingsViewController);
    CHHook0(MDSettingsViewController, setupSubViews);
    CHHook0(MDSettingsViewController, exit);
}




#pragma mark -- uri调用高德地图进行搜索






#pragma mark - DingtalkPod
// http://www.cnblogs.com/DafaRan/p/7522284.html author: Dafa blog: http://www.cnblogs.com/DafaRan/

CHDeclareClass(CLLocation);

CHOptimizedMethod0(self, CLLocationCoordinate2D, CLLocation, coordinate){
    CLLocationCoordinate2D coordinate = CHSuper(0, CLLocation, coordinate);
    if(pluginConfig.location.longitude || pluginConfig.location.latitude ){
        coordinate = pluginConfig.location;
    }
    return coordinate;
}

CHConstructor{
    CHLoadLateClass(CLLocation);
    CHClassHook(0, CLLocation, coordinate);
}


CHDeclareClass(AMapGeoFenceManager);
CHMethod(0, BOOL,AMapGeoFenceManager,detectRiskOfFakeLocation){
    
    return NO;
}
CHMethod(0, BOOL,AMapGeoFenceManager,pausesLocationUpdatesAutomatically){
    
    return NO;
}
CHConstructor{
    CHLoadLateClass(AMapGeoFenceManager);
    CHClassHook(0, AMapGeoFenceManager,detectRiskOfFakeLocation);
    CHClassHook(0, AMapGeoFenceManager,pausesLocationUpdatesAutomatically);
}




CHDeclareClass(AMapLocationManager);
CHMethod(0, BOOL,AMapLocationManager,detectRiskOfFakeLocation){
    
    return NO;
}
CHMethod(0, BOOL,AMapLocationManager,pausesLocationUpdatesAutomatically){
    
    return NO;
}
CHConstructor{
    CHLoadLateClass(AMapLocationManager);
    CHClassHook(0, AMapLocationManager,detectRiskOfFakeLocation);
    CHClassHook(0, AMapLocationManager,pausesLocationUpdatesAutomatically);
}





CHDeclareClass(DTALocationManager);
CHMethod(0, BOOL,DTALocationManager,detectRiskOfFakeLocation){
    
    return NO;
}
CHMethod(0, BOOL,DTALocationManager,dt_pausesLocationUpdatesAutomatically){
    
    return NO;
}
CHConstructor{
    CHLoadLateClass(DTALocationManager);
    CHClassHook(0, DTALocationManager,detectRiskOfFakeLocation);
    CHClassHook(0, DTALocationManager,dt_pausesLocationUpdatesAutomatically);
}
















