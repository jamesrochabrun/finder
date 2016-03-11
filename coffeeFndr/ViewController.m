//
//  ViewController.m
//  coffeeFndr
//
//  Created by James Rochabrun on 10-03-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DirectionsViewController.h"
#import <Mapkit/Mapkit.h>

//we import this file beacuse we want to create new instances of CoffeeShop class
#import "CoffeeShop.h"


//dont forget to first set the delegates for CLLocation.. and then when start with the tableview set them too here
@interface ViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

//tableView outlet, let us use it as a property so we can reloadData in the tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//property to get the location of the user
@property CLLocationManager *locationManager;
@property CLLocation *userLocation;

//this is the property for the sorted array
@property NSArray *coffeeShops;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //creating an instance of CLLocationManager
    self.locationManager = [CLLocationManager new];
    //set its delegate to this ViewController
    self.locationManager.delegate = self;
    //using the method requestAlwaysAuthorization
    [self.locationManager requestAlwaysAuthorization];
    //updating the location
    [self.locationManager startUpdatingLocation];
}

////here we put the required methods for the tableView

//tableView:numberOfRowsInSection:
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //we set this to the count of items inside the NSarray coffeShops property
    return self.coffeeShops.count;
}

//And now the instances of the UITableViewCell
  //tableView:cellForRowAtIndexPath:
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    //then we create an instance of CoffeShop so we can access its properties..this new instance is a indexPath of the self.coffeShops array
    CoffeeShop *coffeShop = [self.coffeeShops objectAtIndex:indexPath.row];
    //setting the name of the coffeShop in the cell
    cell.textLabel.text = coffeShop.mapItem.name;
    //settng the distance in the details section of the cell
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f miles away",coffeShop.distance];
    //return the cell
    return cell;
}

////end of  methods for the tableView


//using locationManager delegate method to use the location
//locationManager:didUpdateLocations:

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //setting the userLocation with the array (NSArray<CLLocation *> *)locations and getting the firstObject of that array. wich is the userLocation
    self.userLocation = locations.firstObject;
    
    //////////////////////////////////////////////
    
    //calling the method findCoffeePlaces: near to self.userLocation
    [self findCoffeePlaces:self.userLocation];
    
    //after calling the method findCoffePlaces we need to stopUpdatingLocation
    [self.locationManager stopUpdatingLocation];
}


//creating a custom method to find coffee places around

-(void)findCoffeePlaces:(CLLocation *)location{
    //creating a new instace of the class MAPKITLocalSearchRequest
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    //setting the string that we want to serach for with the property naturalLangageQuery
    request.naturalLanguageQuery = @"coffee";
    //setting the region where we want to look at it with the property region,
    //we use the location parameter requested in this method to get acces to its coordinate property
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.5,0.5));
    
    //then we create a new instance of the class MKLocalSearch, adn make a custom initialization with the request instance object that we had create
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    //sending the startWithCompletionHandler: method that takes a block to send back a response or an error if there are not coffeshops around
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        //here we create an array with the items that we are going to get, from the response parameter in the block
        NSArray *mapItems = response.mapItems;
        
        //THIS IS THE ARRAY FOR THE CoffeShop new instances, creating a NSMutableArray and then inside the loop we add every instance of CoffeeShop here
        NSMutableArray *tempArray = [NSMutableArray new];
        
        
    //now create a for loop to show the first 5 response
        for (int i=0; i<5; i++) {
            //creating a new instance of the class MapItem to alloc the response, a new mapItem for every item in the mapItems Array, using the objectAtIndex method to set the location
            MKMapItem *mapItem = [mapItems objectAtIndex:i];
            //creating a new instance of the class CLLocationDistance and setting it to the... the mapItem new instance with the properties placemark.location that holds the location information using the message distanceFromLocation, so in this case the receiver is each coffeplace and the message sets the distance between the place and the user.(distance is a double)
            CLLocationDistance distance = [mapItem.placemark.location distanceFromLocation:self.userLocation];
            //setting the result in miles
            float milesDistance = distance / 1609.34;
            
            //Now that we have the item and the distance we want to store it in a custom object for each coffee place...lets create a new cocoa tpuch file for that with a NSObject class....
            
            //Now that we create the new class CoffeeShop and we import the .h file in this file lets create new instances of CoffeeShop
            CoffeeShop *coffeeShop = [CoffeeShop new];
            
            //and now we can set the properties of the new instance o CoffeeShop, with the mapItem instance of the class MKMapItem ,that we create before and the same with the milesDistance float
            coffeeShop.mapItem = mapItem;
            coffeeShop.distance = milesDistance;
            //now that we have the instances of the CoffeeShop lets create an array outside the loop to store them...
            
            //now lets use the addObject method to add every new instance of CoffeShop and its properties inside the array
            [tempArray addObject:coffeeShop];
        }
        
        //Now lets call the findCoffeePlaces: custom method inside the locationManager:didUpdateLocations:
        
        
        //////////sorting the coffeShops based on distance and add them to a new array and then add that array to an array as a property so we can display it to the user
        
            //creating a new instance of the class NSSortDescriptor here @"distance" is the coffeShop.distance instance
        
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:true];
        
        //creating the sorted Array, this returns the tempArray sorted by distance
        NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        
        //here we use the property self.coffeeShops property, and set it with the arrayWithArray: method using the sortedArray as a parameter,
        
        self.coffeeShops = [NSArray arrayWithArray:sortedArray];
        
        //now lets make a fast enumeration for every item in the sortedArray, here we are creating a new instance with the class CoffeeShop for every item inside the array self.coffeeShops.
           //NOte the firts coffeShop is an instance of the CoffeShop class and the other coffeShop is the porperty declared in this file for the viewcontroller
        
        for (CoffeeShop *coffeeShop in self.coffeeShops){
            NSLog(@"%.1f", coffeeShop.distance);
        }
        
        //this reload shows the list in the tableView, becuase we are setting the tableviews properties before we got the location back,(it takes a second to update the user location)
        
        [self.tableView reloadData];
    }];
}



//setting the method dor the Segue, this happens before the segues its executed
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //creating an instance of the DirectionViewController class
      //we are using the segue parameter and accesing its property  destinationViewController to set the new instance of DirectionsViewController
    DirectionsViewController *directionsViewController = segue.destinationViewController;
    
    //so now we want to pass the coffeShop selected to the DirectionsViewController, for that we import the Coffeeshop class to the DirectionsViewcontroller.h and create a CoffeShop property.
          //here when the user taps in one cell the row is asigned to the directionsViewController.coffeeShop.
    directionsViewController.coffeeShop = [self.coffeeShops objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    //now we bind the userLocation in this view with the one in the DirectionsViewController, now in the DirectionsViewController.m we can create a method for get directions for the user
    directionsViewController.userLocation = self.userLocation;
    

    
}






@end
