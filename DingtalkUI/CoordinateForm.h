//
//  CoordinateForm.h
//  DingtalkUI
//
//  Created by  HYY on 2017/11/21.
//  Copyright © 2017年 com.laiwang.DingTalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDSettingCenter/MDSettingCenter.h>
@interface CoordinateForm : NSObject <FXForm>

@property(copy, nonatomic)NSString  *latitude;
@property(copy, nonatomic)NSString *longitude;

@end
