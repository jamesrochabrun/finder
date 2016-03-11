//
//  DirectionsViewController.h
//  coffeeFndr
//
//  Created by James Rochabrun on 10-03-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>


//importing CoffeeShop so we can create a property with that class
#import "CoffeeShop.h"

//importing Corelocation to send the user Location to this view.
#import <CoreLocation/CoreLocation.h>

@interface DirectionsViewController : UIViewController

//new property for this view
@property CoffeeShop *coffeeShop;

//new property for get acces of the user Location
@property CLLocation *userLocation;

@end
