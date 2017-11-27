//
//  CoordinateForm.m
//  DingtalkUI
//
//  Created by  HYY on 2017/11/21.
//  Copyright © 2017年 com.laiwang.DingTalk. All rights reserved.
//

#import "CoordinateForm.h"

@implementation CoordinateForm


- (NSDictionary *)latitudeField{
    return @{FXFormFieldTitle:@"纬度",
             FXFormFieldHeader:@"修改位置",
             };
}

- (NSDictionary *)longitudeField{
    return @{FXFormFieldTitle:@"经度",
             };
}

- (NSArray *)extraFields{
    return @[
//             @{FXFormFieldTitle:@"提交",
//               FXFormFieldHeader:@"",
//               FXFormFieldAction:@"modifyCoordinate"
//               },
             @{FXFormFieldTitle:@"本地搜索",
               FXFormFieldHeader:@"",
               FXFormFieldAction:@"searchCoordinate"
               },
             
//             @{FXFormFieldTitle:@"高德地图搜索",
//               FXFormFieldHeader:@"",
//               FXFormFieldAction:@"aMapsearchCoordinate"
//               }
//
             ];
}


@end

