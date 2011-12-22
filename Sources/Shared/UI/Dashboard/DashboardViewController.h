//
//  DashboardViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardProxy.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "eXoViewController.h"
#import "EGORefreshTableHeaderView.h"

//Constants Definitions
#define kTagForCellSubviewTitleLabel 22
#define kTagForCellSubviewDescriptionLabel 33
#define kTagForCellSubviewImageView 44

@interface DashboardViewController : eXoViewController <DashboardProxyDelegate, UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>{
    
    NSArray*         _arrDashboard;	//Dashboard array 
    IBOutlet UITableView*   _tblGadgets;
    
    //Loader
    ATMHud*                 _hudDashboard;//Heads up display
    
    //Refresh Management
    EGORefreshTableHeaderView*              _refreshHeaderView;
    BOOL                                    _reloading;
    NSDate*                                 _dateOfLastUpdate;
    
    //Proxy
    DashboardProxy*         _dashboardProxy;
    
    BOOL                    _isEmpty;
    
    //Error message for dashboard problems
    NSMutableString*        _errorForRetrievingDashboard;
    
}

@property(nonatomic, retain) NSArray* _arrDashboard;

- (CGRect)rectOfHeader:(int)width;
- (void)setHudPosition;
- (void)emptyState;

@end
