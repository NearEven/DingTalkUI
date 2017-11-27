//
//  MapSearchViewController.m
//  CaptainHook
//
//  Created by  HYY on 2017/11/24.
//

#import "MapSearchViewController.h"
#import "CaptainHook.h"
#import <MAMapKit/MAMapKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "POIAnnotation.h"
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MapSearchCell: UITableViewCell
@property(nonatomic, strong)UILabel *titlLabel;
@property(nonatomic, strong)UILabel *subTitleLabel;
@end

@interface MapSearchViewController () <MAMapViewDelegate, AMapSearchDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)AMapSearchAPI *search;
@property(nonatomic, strong)MAMapView *mapView;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)UITableView *table;
@property(nonatomic, strong)POIAnnotation *searchModel;
@property(copy, nonatomic)NSArray *searchArr;
@property(nonatomic, strong)POIAnnotation *poiAnnotation;
@end

@implementation MapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMapView];
    self.navigationItem.titleView = self.searchBar;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)initMapView{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.mapView setZoomLevel:17 animated:YES];
    self.mapView.touchPOIEnabled = YES;
    [self.view addSubview:self.mapView];
    
    UIView *zoomPannelView = [self makeZoomPannelView];
    [self.mapView addSubview:zoomPannelView];
}

- (void)backItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height - 105, 53, 98)];
    ret.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    incBtn.backgroundColor = [UIColor whiteColor];
    [incBtn setTitle:@"+" forState:UIControlStateNormal];
    incBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    [incBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 51, 53, 49)];
    decBtn.backgroundColor = [UIColor whiteColor];
    [decBtn setTitle:@"-" forState:UIControlStateNormal];
    decBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    [decBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
    self.mapView.showsScale = YES;
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
    self.mapView.showsScale = NO;
}


- (UITableView *)table{
    if (!_table) {
        _table = ({
            UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
            [self.view addSubview:table];
            table.delegate =self;
            table.dataSource =self;
            
            table;
        });
    }
    return _table;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = ({
            UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
            searchBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            searchBar.barStyle     = UIBarStyleDefault;
            searchBar.delegate     = self;
            searchBar.placeholder  = @"输入查询地址";
            searchBar.keyboardType = UIKeyboardTypeDefault;
            [searchBar sizeToFit];
            searchBar;
        });
    }
    return _searchBar;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO];
    self.table.hidden = false;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    self.table.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    if(self.searchBar.text.length == 0) {
        return;
    }
    
    [self searchPoiByKeyword:self.searchBar.text];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MAAnnotation> annotation = view.annotation;
    
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
        if (self.searchCoordinateBlock) {
            self.searchCoordinateBlock(poiAnnotation.coordinate);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        poiAnnotationView.draggable = YES;
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
        
        return poiAnnotationView;
    }
    
    return nil;
}

- (POIAnnotation *)annotationForTouchPoi:(MATouchPoi *)touchPoi{
    if (touchPoi) {
        POIAnnotation *annotation = [[POIAnnotation alloc] init];
        annotation.title = touchPoi.name;
        annotation.coordinate = touchPoi.coordinate;
        return annotation;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois{
    if (pois.count) {
        POIAnnotation *annotation = [self annotationForTouchPoi:pois[0]];
        [self.mapView removeAnnotation:(id)self.poiAnnotation];
        [self.mapView addAnnotation:(id)annotation];
        [self.mapView selectAnnotation:(id)annotation animated:YES];
        self.poiAnnotation = annotation;
    }
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    self.searchArr = [NSArray arrayWithArray:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
//    if (poiAnnotations.count == 1)
//    {
//        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
//    }
//    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
//    else
//    {
//        [self.mapView showAnnotations:poiAnnotations animated:NO];
//    }
    [self.table reloadData];
}

#pragma mark - tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"iden";
    MapSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[MapSearchCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
    }
    POIAnnotation *annotation = self.searchArr[indexPath.row];
    cell.titlLabel.text = annotation.title;
    cell.subTitleLabel.text = annotation.subtitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.table.hidden = YES;
    POIAnnotation *annotation = self.searchArr[indexPath.row];
    [self.mapView removeAnnotation:(id)self.poiAnnotation];
    [self.mapView addAnnotation:(id)annotation];
    [self.mapView selectAnnotation:(id)annotation animated:YES];
    self.poiAnnotation = annotation;

}

#pragma mark - Utility
/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword:(NSString *)keyword
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    request.requireExtension    = YES;
    //
    //    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
}

@end



@implementation MapSearchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 20)];
        [self.contentView addSubview:titleLabel];
        _titlLabel = titleLabel;
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, titleLabel.frame.size.width, 40)];
        subTitleLabel.numberOfLines = 0;
        subTitleLabel.font = [UIFont systemFontOfSize:12];
        subTitleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:subTitleLabel];
        _subTitleLabel = subTitleLabel;
        
    }
    return self;
}

@end

