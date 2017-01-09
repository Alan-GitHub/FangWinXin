
//
//  DiscoverViewController.m
//  仿微信
//
//  Created by Alan.Turing on 16/12/20.
//  Copyright © 2016年 Alan.Turing. All rights reserved.
//

#import "DiscoverViewController.h"


@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //locationManager
    if(locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
    [locationManager requestAlwaysAuthorization];
    //[locationManager requestWhenInUseAuthorization];
    if([locationManager locationServicesEnabled])
        [locationManager startUpdatingLocation];
    else
        NSLog(@"location service have no open!");
    
    //mapView
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mapView.mapType = MKMapTypeStandard;
    //mapView.mapType = MKMapTypeSatellite;
    mapView.showsUserLocation = YES;
    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    //button
    float btn_width = 100;
    float btn_height = 40;
    UIButton * btn_satellite = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * btn_standard = [UIButton buttonWithType:UIButtonTypeCustom];
    //satellite button
    btn_satellite.frame = CGRectMake(mapView.frame.size.width-btn_width, mapView.frame.size.height/2-50, btn_width, btn_height);
    btn_satellite.backgroundColor = [UIColor greenColor];
    [btn_satellite setTitle:@"卫星地图" forState:UIControlStateNormal];
    [btn_satellite addTarget:self action:@selector(satelliteMap) forControlEvents:UIControlEventAllEvents];
    //standard button
    btn_standard.frame = CGRectMake(mapView.frame.size.width-btn_width, mapView.frame.size.height/2+10, btn_width, btn_height);
    btn_standard.backgroundColor = [UIColor greenColor];
    [btn_standard setTitle:@"标准地图" forState:UIControlStateNormal];
    [btn_standard addTarget:self action:@selector(standardMap) forControlEvents:UIControlEventAllEvents];
    
    [mapView addSubview:btn_satellite];
    [mapView addSubview:btn_standard];
}

- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    NSLog(@"viewForAnnotation");
    
    if (![annotation isKindOfClass:[MKPointAnnotation class]])
        return nil;
    
    static NSString *placemarkIdentifier = @"annotation";
    MKPinAnnotationView *annotationView = [theMapView dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifier];
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placemarkIdentifier];
    }
        
    annotationView.annotation = annotation;//这句看不懂
        
    annotationView.animatesDrop = YES;
    annotationView.image = [UIImage imageNamed:@"MyPhoto.png"];
    annotationView.canShowCallout = YES;

    return annotationView;
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation");
    
    //添加大头针
    if (annotation) {
        
        [mapView removeAnnotation: annotation];
    }
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    annotation = point;
    point.coordinate = userLocation.coordinate;
    point.title = @"我的位置";
    point.subtitle = @"我在这里";
    [mapView addAnnotation:point];
    [point release];
    
}

- (void) satelliteMap
{
    mapView.mapType = MKMapTypeSatellite;
}

- (void) standardMap
{
    mapView.mapType = MKMapTypeStandard;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"regionWillChangeAnimated");
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
}

- (void) mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"mapViewWillStartLocatingUser");
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    NSLog(@"didUpdateLocations");
    
    CLLocation* loc = [locations firstObject];
    NSLog(@"wd=%f, jd=%f", loc.coordinate.latitude, loc.coordinate.longitude);
    
    [locationManager stopUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) dealloc
{
    [mapView release];
    [locationManager release];
    [annotation release];
    
    [super dealloc];
}

@end
