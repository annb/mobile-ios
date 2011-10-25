//
//  ActivityDetailViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialProxy.h"
#import "EGORefreshTableHeaderView.h"
#import "MessageComposerViewController.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"

@class ActivityDetailMessageTableViewCell;
@class ActivityDetailLikeTableViewCell;
@class SocialActivityStream;
@class SocialActivityDetails;
@class SocialUserProfile;

#define kFontForMessage [UIFont fontWithName:@"Helvetica" size:13]

@interface ActivityDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SocialProxyDelegate, EGORefreshTableHeaderDelegate, SocialMessageComposerDelegate, UIAlertViewDelegate, UIWebViewDelegate>{
    
    IBOutlet UITableView*                   _tblvActivityDetail;
    IBOutlet UINavigationBar*               _navigationBar;
            
    SocialActivityStream*                   _socialActivityStream;
    
    //Cell for the content of the message
    ActivityDetailMessageTableViewCell*     _cellForMessage;
    
    //Cell for the like part of the screen
    ActivityDetailLikeTableViewCell*        _cellForLikes;
        
    SocialActivityDetails*                  _socialActivityDetails;
    SocialUserProfile*                      _socialUserProfile;
    
    BOOL                                    _currentUserLikeThisActivity;
    
    UITextView*                             _txtvMsgComposer;
    IBOutlet UIButton*                      _btnMsgComposer;    
    
    //Refresh Management
    EGORefreshTableHeaderView*              _refreshHeaderView;
    BOOL                                    _reloading;
    NSDate*                                 _dateOfLastUpdate;
    
    //Loader
    ATMHud*                                 _hudActivityDetails;//Heads up display
    
    int                                     _activityAction;//0: getting, 1: updating, 2: like, 3: dislike
    
    CGRect originRect;
    BOOL zoomOutOrZoomIn;
    UITapGestureRecognizer *tapGesture;
    
    UIView *maskView;
}
- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream andCurrentUserProfile:(SocialUserProfile*)currentUserProfile;
- (void)likeDislikeActivity:(NSString *)activity;

- (void)setHudPosition;
@end
