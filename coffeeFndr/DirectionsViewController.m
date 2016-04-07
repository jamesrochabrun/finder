//
//  DirectionsViewController.m
//  coffeeFndr
//
//  Created by James Rochabrun on 10-03-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "DirectionsViewController.h"

@interface DirectionsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *directionsTextView;

//creating the property for make the same request available in different methods

@property MKDirectionsRequest *request;

@end

@implementation DirectionsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //here we set the title of the ViewController with the name of the coffeeShop property of DirectionsViewcontroller
    self.title = self.coffeeShop.mapItem.name;
    
    //calling the getDirectionsFrom:withDestination:  custom method
    [self getDirectionsFrom:self.userLocation.coordinate withDestination:self.coffeeShop.mapItem.placemark.location.coordinate];
    
    
}




//creating a custom method to get directions
//getDirectionsFrom:withDestination:

-(void)getDirectionsFrom:(CLLocationCoordinate2D)sourceCoordinate withDestination:(CLLocationCoordinate2D)destinationCoordinate{
    //Creating a new instance of MKPlaceMark for the source and desination
    
    //using the sourceCoordinate parameter...
    MKPlacemark *sourcePlaceMark = [[MKPlacemark alloc]initWithCoordinate:sourceCoordinate addressDictionary:nil];
    //we are going to use that MKPlacemark to make an MKMapItem
    MKMapItem *sourceMapItem = [[MKMapItem alloc] initWithPlacemark: sourcePlaceMark];
    
    
    //using the destinationCoordinate  parameter...
    MKPlacemark *destinationPlaceMark = [[MKPlacemark alloc]initWithCoordinate:destinationCoordinate addressDictionary:nil];
    MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark: destinationPlaceMark];
    
    //Now we are going to use the to new instances of MKPlacemark to make a new instance of MKdirectionsRequest
    self.request = [[MKDirectionsRequest alloc]init];

    
    //sending the message setSource with the arguments of MKapItem type
    [self.request setSource:sourceMapItem];
    [self.request setDestination:destinationMapItem];
    
    
    //setting the transportation type
    
    
    [self.request setTransportType: MKDirectionsTransportTypeWalking];

    
    //setting the requestAlternateRoutes property boolean type
    self.request.requestsAlternateRoutes = NO;
    
    //getting the directions by creating a new instance of MKdirections and initializing it with the request instance
    MKDirections *directions = [[MKDirections alloc] initWithRequest:self.request];
    
    //calculating the directions
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        //creating a new instance of MKRoute and setting it using the parameter response inside the block
        //routes is an array
        MKRoute *route = response.routes.lastObject;
        
        //now we are going to create a string to show all the steps of the route
        NSString *allSteps = [NSString new];
        
        //for Loop to show every string of the route.steps
        
        for (int  i =0; i < route.steps.count ; i++) {
            //creating a new instance of MKRouteStep and set it with the value that we get by using the objectAtIndex: message in to the route.steps array
            MKRouteStep *step = [route.steps  objectAtIndex:i];
            
            //creating a new string to store the step.instrunctions (instructions is a porperty of MKRouteStep)
            NSString *newStepString = step.instructions;
            
            
            //appending the newStepString to the allSteps NSString *allSteps
            allSteps = [allSteps stringByAppendingString:[NSString stringWithFormat:@"%@\n",newStepString]];
        }
        
        //Now setting the text for the TextView
        self.directionsTextView.text = allSteps;
        
        //lastly in the viewDidLoad method we need to call this method (because wen it loads this method gets "activated"!)
        
    }];
}


//upgrade 1)creating button for walking directions using the method getDirectionsFrom

- (IBAction)getDirectionsWalkingButton:(UIBarButtonItem *)sender {
    
 [self getDirectionsFrom:self.userLocation.coordinate withDestination:self.coffeeShop.mapItem.placemark.location.coordinate];
}



//2) create a custom method for get directions by car

-(void)getDirectionsDriving:(CLLocationCoordinate2D)sourceCoordinate withDestination:(CLLocationCoordinate2D)destinationCoordinate{
    //Creating a new instance of MKPlaceMark for the source and desination
    
    //using the sourceCoordinate parameter...
    MKPlacemark *sourcePlaceMark = [[MKPlacemark alloc]initWithCoordinate:sourceCoordinate addressDictionary:nil];
    //we are going to use that MKPlacemark to make an MKMapItem
    MKMapItem *sourceMapItem = [[MKMapItem alloc] initWithPlacemark: sourcePlaceMark];
    
    
    //using the destinationCoordinate  parameter...
    MKPlacemark *destinationPlaceMark = [[MKPlacemark alloc]initWithCoordinate:destinationCoordinate addressDictionary:nil];
    MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark: destinationPlaceMark];
    
    //Now we are going to use the to new instances of MKPlacemark to make a new instance of MKdirectionsRequest, HERE I MUST CHANGE THIS IF I DELETE THE PROEPERTY.
    
    self.request = [[MKDirectionsRequest alloc]init];
    
    
    //sending the message setSource with the arguments of MKapItem type
    [self.request setSource:sourceMapItem];
    [self.request setDestination:destinationMapItem];
    
    
    //setting the transportation type
    
    
    [self.request setTransportType: MKDirectionsTransportTypeAutomobile];
    
    
    //setting the requestAlternateRoutes property boolean type
    self.request.requestsAlternateRoutes = NO;
    
    //getting the directions by creating a new instance of MKdirections and initializing it with the request instance
    MKDirections *directions = [[MKDirections alloc] initWithRequest:self.request];
    
    //calculating the directions
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        //creating a new instance of MKRoute and setting it using the parameter response inside the block
        //routes is an array
        MKRoute *route = response.routes.lastObject;
        
        //now we are going to create a string to show all the steps of the route
        NSString *allSteps = [NSString new];
        
        //for Loop to show every string of the route.steps
        
        for (int  i =0; i < route.steps.count ; i++) {
            //creating a new instance of MKRouteStep and set it with the value that we get by using the objectAtIndex: message in to the route.steps array
            MKRouteStep *step = [route.steps  objectAtIndex:i];
            
            //creating a new string to store the step.instrunctions (instructions is a porperty of MKRouteStep)
            NSString *newStepString = step.instructions;
            
            
            //appending the newStepString to the allSteps NSString *allSteps
            allSteps = [allSteps stringByAppendingString:[NSString stringWithFormat:@"%@\n",newStepString]];
        }
        
        //Now setting the text for the TextView
        self.directionsTextView.text = allSteps;
        
        //lastly in the viewDidLoad method we need to call this method (because wen it loads this method gets "activated"!)
        
    }];
}



//3) creating a button for driving directions using the getDirectionsAuto method


- (IBAction)getDirectionsDrivingButton:(UIBarButtonItem *)sender {
        [self getDirectionsDriving:self.userLocation.coordinate withDestination:self.coffeeShop.mapItem.placemark.location.coordinate];
}










@end











