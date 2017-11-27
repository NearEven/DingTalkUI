//
//  AMapSearchApiModel.m
//  CaptainHook
//
//  Created by  HYY on 2017/11/24.
//

#import "POIAnnotation.h"
@interface POIAnnotation ()
//@property(nonatomic, strong,readwrite)AMapPOI *poi;
@end

@implementation POIAnnotation

- (NSString *)title{
    return self.poi.name;
}

- (NSString *)subtitle{
    return self.poi.address;
}

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
}

#pragma mark - life cycle
- (id)initWithPOI:(AMapPOI *)poi{
    if (self = [super init]) {
        self.poi = poi;
    }
    return self;
}

@end
