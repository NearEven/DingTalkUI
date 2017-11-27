//
//  AMapSearchApiModel.h
//  CaptainHook
//
//  Created by  HYY on 2017/11/24.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface POIAnnotation : NSObject


- (id)initWithPOI:(AMapPOI *)poi;

@property(nonatomic, strong)AMapPOI *poi;
@property(assign, nonatomic)CLLocationCoordinate2D coordinate;

@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *subtitle;
//
//- (NSString *)title;
//
//- (NSString *)subtitle;

@end
