//
//  AuthenticateViewController.m
//  Authenticate Screen
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright EXO-Platform 2009. All rights reserved.
//

#import "AuthenticateViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "defines.h"
#import "LanguageHelper.h"
#import "AuthTabItem.h"

#define scrollHeight 80

@implementation AuthenticateViewController_iPhone


#pragma mark - Object Management
-(void)dealloc {
    
    [_settingsViewController release];
    _settingsViewController = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Position the tabs just above the subviews
    [self.tabView setFrame:CGRectMake(50, 180, 100, 30)];
    // Position the views and allow them to be resized properly when the orientation changes
    [_credViewController.view setFrame:
     CGRectMake(self.view.center.x-_credViewController.view.bounds.size.width/2, 215, _credViewController.view.bounds.size.width, _credViewController.view.bounds.size.height)];
    [_credViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    [_servListViewController.view setFrame:
     CGRectMake(self.view.center.x-_servListViewController.view.bounds.size.width/2, 215, _servListViewController.view.bounds.size.width, _servListViewController.view.bounds.size.height)];
    [_servListViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    // Position the settings btn at the bottom
    //[_btnSettings setFrame:
     //CGRectMake(0, 400, _btnSettings.bounds.size.width, _btnSettings.bounds.size.height)];
    [_btnSettings setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];

}

-(void) initTabsAndViews {
    // Creating the sub view controllers
    _credViewController = [[CredentialsViewController alloc] initWithNibName:@"CredentialsViewController_iPhone" bundle:nil];
    _credViewController.authViewController = self;
    
    _servListViewController = [[ServerListViewController alloc] initWithNibName:@"ServerListViewController_iPhone" bundle:nil];
    
    // Initializing the Tab items and adding them to the Tab view
    AuthTabItem * tabItemCredentials = [[AuthTabItem alloc] initWithTitle:nil icon:[UIImage imageNamed:@"AuthenticateCredentialsIconIphoneOff"]];
    tabItemCredentials.alternateIcon = [UIImage imageNamed:@"AuthenticateCredentialsIconIphoneOn"];
    [self.tabView addTabItem:tabItemCredentials];
    
    AuthTabItem * tabItemServerList = [[AuthTabItem alloc] initWithTitle:nil icon:[UIImage imageNamed:@"AuthenticateServersIconIphoneOff"]];
    tabItemServerList.alternateIcon = [UIImage imageNamed:@"AuthenticateServersIconIphoneOn"];
    [self.tabView addTabItem:tabItemServerList];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_credViewController.bAutoLogin)
    {
       // _vContainer.alpha = 1;
        [_credViewController onSignInBtn:nil];
    }
    else
    {
        //Start the animation to display the loginView
        [UIView animateWithDuration:0.5 
                         animations:^{
         //                    _vContainer.alpha = 1;
                         }
         ];
    }
}

#pragma mark Keyboard management
- (void)keyboardWillHide:(NSNotification *)notif {
        [self setViewMovedUp:NO];
}


- (void)keyboardDidShow:(NSNotification *)notif{
        [self setViewMovedUp:YES];
}
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect viewRect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        viewRect.origin.y -= scrollHeight;
    }
    else
    {
        viewRect.origin.y = 0;
    }
    self.view.frame = viewRect;
    [UIView commitAnimations];
}



- (IBAction)onSettingBtn
{
    if (_settingsViewController == nil) {
        
        _settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _settingsViewController.settingsDelegate = self;
    }
    [_settingsViewController startRetrieve];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_settingsViewController];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentModalViewController:navController animated:YES];
    
    
}

- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion {
    [super platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if(platformServerVersion != nil){
        //Setup Version Platfrom and Application
        
        [userDefaults setObject:platformServerVersion.platformVersion forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:platformServerVersion.platformEdition forKey:EXO_PREFERENCE_EDITION_SERVER];
        if([platformServerVersion.isMobileCompliant boolValue]){
            [self.hud completeAndDismissWithTitle:Localize(@"Success")];
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
            appDelegate.isCompatibleWithSocial = compatibleWithSocial;
            [appDelegate performSelector:@selector(showHomeSidebarViewController) withObject:nil afterDelay:1.0];
        } else {
            [self.hud failAndDismissWithTitle:Localize(@"Error")];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Error") 
                                                            message:Localize(@"NotCompliant") 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    } else {
        [self.hud failAndDismissWithTitle:Localize(@"Error")];
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_EDITION_SERVER];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Error") 
                                                        message:Localize(@"NotCompliant") 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    [userDefaults synchronize];
}

#pragma mark - TextField delegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _credViewController.txtfUsername) 
    {
        [_credViewController.txtfPassword becomeFirstResponder];
    }
    else
    {    
        [_credViewController.txtfPassword resignFirstResponder];
                
        [_credViewController onSignInBtn:nil];
    }    
	return YES;
}

#pragma mark - Settings Delegate methods

- (void)doneWithSettings {
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];
    [_credViewController.btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    [_servListViewController.tbvlServerList reloadData];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end


