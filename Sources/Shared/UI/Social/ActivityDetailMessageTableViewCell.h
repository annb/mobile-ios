//
//  ActivityDetailMessageTableViewCell.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "defines.h"

#define kBottomMargin 5.0
#define kPadding 5.0

@class Activity;
@class EGOImageView;
@class SocialActivity;
@class ActivityDetail;
@class AvatarView;
@protocol ActivityDetailMessageTableViewCellDelegate;


@interface ActivityDetailMessageTableViewCell : UITableViewCell {
    
    UILabel*               _lbMessage;
    UILabel*               _lbDate;
    UILabel*               _lbName;
    
    UIImageView*           _imgType;
    EGOImageView*          _imgvAttach;
    
    UIWebView*             _webViewForContent;
    UIWebView   *          _webViewComment;
    
    TTStyledTextLabel*     htmlLabel;
}

@property (nonatomic, retain) SocialActivity *socialActivity;
@property (nonatomic, assign) id<ActivityDetailMessageTableViewCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel* lbMessage;
@property (retain, nonatomic) IBOutlet UILabel* lbDate;
@property (retain, nonatomic) IBOutlet UILabel* lbName;
@property (retain, nonatomic) IBOutlet AvatarView* imgvAvatar;
@property (retain) IBOutlet EGOImageView* imgvAttach;
@property (retain, nonatomic) IBOutlet UIImageView* imgType;

@property (retain, nonatomic) IBOutlet UIWebView* webViewForContent;
@property (retain, nonatomic) IBOutlet UIWebView *webViewComment;
//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCell;
- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth;
- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail;
- (void)updateSizeToFitSubViews;
- (void)updateLabelsWithNewLanguage;
-(void) createTabRecognizer;

@end

@protocol ActivityDetailMessageTableViewCellDelegate <NSObject>

-(void) showDetailUserProfile: (NSString *) userId;

@end
