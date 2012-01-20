//
//  DashboardProxy.m
//  eXo Platform
//
//  Created by Stévan on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashboardProxy.h"
#import "defines.h"
#import "DashboardItem.h"

@interface DashboardProxy (PrivateMethods)
-(void)loadGadgetsFromSet;
@end


@implementation DashboardProxy

@synthesize delegate = _delegate;
@synthesize arrayOfDashboards = _arrayOfDashboards;


-(id)initWithDelegate:(id<DashboardProxyDelegate>)delegate {
    if ((self = [super init])) {
        _delegate = delegate;
    }
    return self;
}

- (void) dealloc {
        
    _delegate = nil;
    [_gadgetsProxy release];
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {    
    
    NSLog(@"ddd == %@",[NSString stringWithFormat:@"%@/%@/",[SocialRestConfiguration sharedInstance].domainNameWithCredentials,kRestContextName]);
    
    return [NSString stringWithFormat:@"%@/%@/",[SocialRestConfiguration sharedInstance].domainNameWithCredentials,kRestContextName]; 
}



#pragma mark - Call methods

- (void)retrieveDashboards {
    // Load the object model via RestKit
    
    if ([RKObjectManager sharedManager] == nil) {
        RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];  
        [RKObjectManager setSharedManager:manager];
    } else {
        [RKObjectManager sharedManager].client = [[RKClient clientWithBaseURL:[self createBaseURL]] retain];
//        [RKObjectManager sharedManager].client = [[RKClient clientWithBaseURL:[self createBaseURL] username:@"demo" password:@"gtn"] retain];
    }
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
//    if([RKObjectManager sharedManager].client.username == nil) {
//       [RKObjectManager sharedManager].client.username = @"demo";
//       [RKObjectManager sharedManager].client.password = @"gtn";
//    }
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[DashboardItem class]];
    [mapping mapKeyPathsToAttributes:
     @"id",@"idDashboard",
     @"link",@"link",
     @"html",@"html",
     @"label",@"label",
     nil];
    
    [manager loadObjectsAtResourcePath:@"private/dashboards" objectMapping:mapping delegate:self];          
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded statuses: %@", objects);    
    //We receive the response from the server
    
    //Store dahsboards collected
    self.arrayOfDashboards = objects;
    
    //Prepare the set of dashboard where we will need to make request to retrieve gadgets
    _setOfDashboardsToRetrieveGadgets = [[NSMutableSet alloc] initWithArray:objects];
    
    [self loadGadgetsFromSet];
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	// The url doesn't exist, the server is not compatible
    
    //We need to prevent the caller
    if (_delegate && [_delegate respondsToSelector:@selector(dashboardProxy:didFailWithError:)]) {
        [_delegate dashboardProxy:self didFailWithError:error];
    }
}


- (void)finishLoadingGadgets {
    
    //We complete the loading of Gadgets, so now we need to prevent the controller
    if (_delegate && [_delegate respondsToSelector:@selector(dashboardProxyDidFinish:)]) {
        [_delegate dashboardProxyDidFinish:self];
    }
}


#pragma mark - GadgetsProxy Management

- (void)loadGadgetsFromSet {
    if ([_setOfDashboardsToRetrieveGadgets count] != 0) {
        
        DashboardItem *tmpDashboard = [_setOfDashboardsToRetrieveGadgets anyObject];
        
        if (_gadgetsProxy == nil) {
            _gadgetsProxy = [[GadgetsProxy alloc] initWithDashboardItem:tmpDashboard andDelegate:self];
        } else {
            [_gadgetsProxy retrieveGadgetsForDashboardItem:tmpDashboard];
        }
        
        [_setOfDashboardsToRetrieveGadgets removeObject:tmpDashboard];

    }
    else
    {
        [self finishLoadingGadgets];
    }
}



#pragma mark - GadgetsProxy Delegates methods

- (void)proxyDidFinishLoading:(GadgetsProxy *)proxy {
    if ([_setOfDashboardsToRetrieveGadgets count] == 0) {
        [self finishLoadingGadgets];
    } else {
        [self loadGadgetsFromSet];
    }
}



- (void)proxy:(GadgetsProxy *)proxy didFailWithError:(NSError *)error {
    
    //We encounter an error for retrieving gadgets from one dashboard
    //We need to raise an alert and prevent the controller for that
    if (_delegate && [_delegate respondsToSelector:@selector(dashboardProxyDidFailForDashboard:)]) {
        [_delegate dashboardProxyDidFailForDashboard:proxy.dashboard];
    }
    
    //Continue to retrieve other dashboards
    if ([_setOfDashboardsToRetrieveGadgets count] == 0) {
        [self finishLoadingGadgets];
    } else {
        [self loadGadgetsFromSet];
    }
}



@end
