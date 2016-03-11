//
//  CoffeShop.h
//  coffeeFndr
//
//  Created by James Rochabrun on 10-03-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mapkit/Mapkit.h>

@interface CoffeeShop : NSObject

//setting a property of class MKMapItem and a float to bind this properties with the mapItem and distance instances in the viewController.m

@property MKMapItem *mapItem;
@property float distance;

@end
