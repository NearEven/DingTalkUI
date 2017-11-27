//
//  MapSearchViewController.h
//  CaptainHook
//
//  Created by  HYY on 2017/11/24.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapSearchViewController : UIViewController

@property(copy, nonatomic)void (^searchCoordinateBlock)(CLLocationCoordinate2D coordinate);

@end
