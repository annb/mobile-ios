//
//  ActivityLinkDisplayViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityLinkDisplayViewController.h"
#import "EmptyView.h"
#import "LanguageHelper.h"



@interface ActivityLinkDisplayViewController (PrivateMethods)
- (void)showLoader;
- (void)hideLoader;
@end


@implementation ActivityLinkDisplayViewController

@synthesize  titleForActivityLink;


// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL
{
	self = [super initWithNibName:nibName bundle:nibBundle];
    if(self){
        _url = [defaultURL copy];
        [_webView setDelegate:self];
        
        self.titleForActivityLink = [_url lastPathComponent];
    }
	return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.title = [_url lastPathComponent];
}

-(NSString *) shortString : (NSString *) myString withMaxCharacter: (int) range {
    // define the range you're interested in
    if (range > [myString length]) {
        return myString;
    }
    NSRange stringRange = {0, MIN([myString length], range)};
    
    // adjust the range to include dependent chars
    stringRange = [myString rangeOfComposedCharacterSequencesForRange:stringRange];
    
    // Now you can create the short string
    NSString *shortString = [myString substringWithRange:stringRange];
    NSString *result = [NSString stringWithFormat:@"%@%@",shortString,@"..."];
    return result;
}

@end
