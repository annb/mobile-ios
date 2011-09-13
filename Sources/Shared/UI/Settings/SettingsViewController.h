//
//  SettingsViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerManagerViewController;


@interface SettingsViewController : UITableViewController {
	    
    BOOL                            bRememberMe;
	BOOL                            bAutoLogin;
	NSString*                       languageStr;
	
	UISwitch*                       rememberMe;
	UISwitch*                       autoLogin;
	
    NSMutableArray*                 _arrServerList;
    int                             _intSelectedServer;
    
    UIBarButtonItem*                _doneBarButtonItem;
    ServerManagerViewController*    _serverManagerViewController;

    
}



-(void)loadSettingsInformations;
-(void)saveSettingsInformations;
-(void)reloadSettingsWithUpdate;


@end
