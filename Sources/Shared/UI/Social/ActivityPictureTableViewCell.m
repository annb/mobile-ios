//
//  ActivityPictureTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityPictureTableViewCell.h"
#import "SocialActivityStream.h"
#import "EGOImageView.h"
#import "defines.h"

@implementation ActivityPictureTableViewCell

@synthesize imgvAttach = _imgvAttach, lbFileName = _lbFileName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [_imgvAttach needToBeResizedForSize:CGSizeMake(45,45)];
        
    }
    return self;
}


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _lbFileName.textColor = [UIColor grayColor];
        _lbFileName.backgroundColor = [UIColor whiteColor];
        
    } else {
        _lbFileName.textColor = [UIColor darkGrayColor];
        _lbFileName.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
    }
    
    [super configureFonts:highlighted];
}



- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream *)socialActivityStream {
    
    //Set the UserName of the activity
    _lbName.text = [socialActivityStream.posterUserProfile.fullName copy];

    
    _imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableFile.png"];
    
       
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", [userDefaults valueForKey:EXO_PREFERENCE_DOMAIN], [socialActivityStream.templateParams valueForKey:@"DOCLINK"]];
    
    //Setting the avatar without starting the download to prevent troubles during scrolling
    [_imgvAttach setImageURLWithoutDownloading:[NSURL URLWithString:strURL]];
        
    _urlForAttachment = [[NSURL alloc] initWithString:strURL]; 
    _htmlMessage.html = [socialActivityStream.templateParams valueForKey:@"MESSAGE"];
    _lbFileName.text = [socialActivityStream.templateParams valueForKey:@"DOCNAME"];
}


- (void)startLoadingImageAttached {
    _imgvAttach.imageURL = _urlForAttachment;
}


- (void)dealloc
{
    [_urlForAttachment release];
    _urlForAttachment = nil;
    
    [super dealloc];
}

@end
