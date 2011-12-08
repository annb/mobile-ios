//
//  ActivityHelper.m
//  eXo Platform
//
//  Created by Stévan on 06/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "LanguageHelper.h"
#import "eXoMobileAppDelegate.h"
#import "defines.h"

#define WIDTH_FOR_CONTENT_IPHONE 237
#define WIDTH_FOR_CONTENT_IPAD 420


#define HEIGHT_FOR_DECORATION_IPHONE 90
#define HEIGHT_FOR_DECORATION_IPAD 90

#define MAX_LENGTH 80

@implementation ActivityHelper


// Specific method to retrieve the height of the cell
// This method override the inherited one.
+ (float)getHeightSizeForText:(NSString*)text andTableViewWidth:(CGFloat)fWidth
{
     
    NSMutableString *textMutable = [[NSMutableString alloc] init];
    if (text) [textMutable setString:text];
    
    int nbBR = [textMutable replaceOccurrencesOfString:@"<br />" withString:@"<br />" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
    
    [textMutable release];
    
    
    //Search the width available to display the text
    if (fWidth > 320) 
    {
        fWidth = WIDTH_FOR_CONTENT_IPAD - 15;
    }
    else
    {
        fWidth = WIDTH_FOR_CONTENT_IPHONE - 10;
    }
    
    NSString* textWithoutHtml = [text stringByConvertingHTMLToPlainText];
        
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    int fHeight = theSize.height + nbBR * 10;

    
    NSLog(@"text :%@   height:%d",text,fHeight);
        
    return fHeight;
}




+ (float)heightForAllDecorationsWithTableViewWidth:(CGFloat)fWidth {

    float heightForDecotation = 0;
    
    //Search the width available to display the text
    if (fWidth > 320) 
    {
        heightForDecotation = HEIGHT_FOR_DECORATION_IPAD;
    }
    else
    {
        heightForDecotation = HEIGHT_FOR_DECORATION_IPHONE;
    }
    
    return heightForDecotation;
    
}

+ (CGFloat)getHeightForActivityDetailCell:(SocialActivityDetails *)activtyStreamDetail forTableViewWidth:(CGFloat)fWidth{
    //return 0.0;
    NSString* text = @"";
    float fHeight = 0.0;
    switch (activtyStreamDetail.activityType) {
        case ACTIVITY_DOC:{
            text = activtyStreamDetail.title;
            fHeight = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] + 80;
        }
            break;  
        case ACTIVITY_LINK:{
            text = [activtyStreamDetail.templateParams valueForKey:@"comment"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [activtyStreamDetail.templateParams valueForKey:@"title"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [activtyStreamDetail.templateParams valueForKey:@"description"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [NSString stringWithFormat:@"Source : %@", [activtyStreamDetail.templateParams valueForKey:@"link"]];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if (![[activtyStreamDetail.templateParams valueForKey:@"image"] isEqualToString:@""]) {
                fHeight += 75;
            }
        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        case ACTIVITY_WIKI_MODIFY_PAGE:
        {
            if([[activtyStreamDetail.templateParams valueForKey:@"act_key"] rangeOfString:@"add_page"].length > 0){//
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"EditWiki")];
                
            } else if([[activtyStreamDetail.templateParams valueForKey:@"act_key"] rangeOfString:@"update_page"].length > 0) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"CreateWiki")];
            }
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            fHeight += [ActivityHelper getHeightSizeForText:[activtyStreamDetail.templateParams valueForKey:@"page_name"] andTableViewWidth:fWidth];
            if([[activtyStreamDetail.templateParams valueForKey:@"page_exceprt"] isEqualToString:@""]){
                fHeight -= 25;
            } else {
                text = [activtyStreamDetail.templateParams valueForKey:@"page_exceprt"];
                fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] - 15;
            }
        }
            break;
        case ACTIVITY_FORUM_CREATE_POST: 
        case ACTIVITY_FORUM_CREATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_POST:
        case ACTIVITY_FORUM_UPDATE_TOPIC:{
            if(activtyStreamDetail.activityType == ACTIVITY_FORUM_CREATE_POST){
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"NewPost")];
                fHeight += [ActivityHelper getHeightSizeForText:[activtyStreamDetail.templateParams valueForKey:@"PostName"] andTableViewWidth:fWidth];
            } else if(activtyStreamDetail.activityType == ACTIVITY_FORUM_CREATE_TOPIC) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName,  Localize(@"NewTopic")];
                fHeight += [ActivityHelper getHeightSizeForText:[activtyStreamDetail.templateParams valueForKey:@"TopicName"] andTableViewWidth:fWidth];
            }else if(activtyStreamDetail.activityType == ACTIVITY_FORUM_UPDATE_POST) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName,  Localize(@"UpdatePost")];
                fHeight += [ActivityHelper getHeightSizeForText:[activtyStreamDetail.templateParams valueForKey:@"PostName"] andTableViewWidth:fWidth];
            }else if(activtyStreamDetail.activityType == ACTIVITY_FORUM_UPDATE_TOPIC) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName,  Localize(@"UpdateTopic")];
                fHeight += [ActivityHelper getHeightSizeForText:[activtyStreamDetail.templateParams valueForKey:@"TopicName"] andTableViewWidth:fWidth];
            }
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            //Set the size of the cell
            text = activtyStreamDetail.body;
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] - 10;
            
        }
            break;
        case ACTIVITY_ANSWER_ADD_QUESTION:
        case ACTIVITY_ANSWER_QUESTION:
        case ACTIVITY_ANSWER_UPDATE_QUESTION:
        {
            if(activtyStreamDetail.activityType == ACTIVITY_ANSWER_ADD_QUESTION){//
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"Asked")];
                
            } else if(activtyStreamDetail.activityType == ACTIVITY_ANSWER_QUESTION) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"Answered")];
            } else if(activtyStreamDetail.activityType == ACTIVITY_ANSWER_UPDATE_QUESTION) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"UpdateQuestion")];
            }
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];

            text = [activtyStreamDetail.templateParams valueForKey:@"Name"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = activtyStreamDetail.body;
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] - 15;
        }
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:
        case ACTIVITY_CALENDAR_ADD_TASK:
        case ACTIVITY_CALENDAR_ADD_EVENT:
        case ACTIVITY_CALENDAR_UPDATE_EVENT:
        {
            if(activtyStreamDetail.activityType == ACTIVITY_CALENDAR_ADD_EVENT){//
                text = [NSString stringWithFormat:@"%@ %@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"EventAdded"),[activtyStreamDetail.templateParams valueForKey:@"EventSummary"]];
                
            } else if(activtyStreamDetail.activityType == ACTIVITY_CALENDAR_UPDATE_EVENT) {
                text = [NSString stringWithFormat:@"%@ %@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"EventUpdated"),[activtyStreamDetail.templateParams valueForKey:@"EventSummary"]];
            } else if(activtyStreamDetail.activityType == ACTIVITY_CALENDAR_ADD_TASK) {
                text = [NSString stringWithFormat:@"%@ %@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"TaskAdded"),[activtyStreamDetail.templateParams valueForKey:@"EventSummary"]];
            }else if(activtyStreamDetail.activityType == ACTIVITY_CALENDAR_UPDATE_EVENT) {
                text = [NSString stringWithFormat:@"%@ %@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"TaskUpdated"),[activtyStreamDetail.templateParams valueForKey:@"EventSummary"]];
            }
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] + 50;
            text = [activtyStreamDetail.templateParams valueForKey:@"EventDescription"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [activtyStreamDetail.templateParams valueForKey:@"EventLocale"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            
        }
            break;
        default:{
            text = activtyStreamDetail.title;
            fHeight = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            NSLog(@"%@", text);
        }
            break;
    }
    
    fHeight += [ActivityHelper heightForAllDecorationsWithTableViewWidth:fWidth];
    return fHeight;
}


+ (CGFloat)getHeightForActivityCell:(SocialActivityStream *)activtyStream forTableViewWidth:(CGFloat)fWidth{

    NSString* text = @"";
    float fHeight = 0.0;
    switch (activtyStream.activityType) {
        case ACTIVITY_DOC:
            text = [activtyStream.templateParams valueForKey:@"MESSAGE"];
            fHeight = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            fHeight += [ActivityHelper getHeightSizeForText:[activtyStream.templateParams valueForKey:@"DOCNAME"]
 andTableViewWidth:fWidth];

            fHeight += 80;
            break;
        case ACTIVITY_LINK:{
            float h = 0.0;
            text = [activtyStream.templateParams valueForKey:@"comment"];
            h =  [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            text = [activtyStream.templateParams valueForKey:@"title"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [activtyStream.templateParams valueForKey:@"description"];
            h = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [NSString stringWithFormat:@"Source : %@", [activtyStream.templateParams valueForKey:@"link"]];
            h += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            if (![[activtyStream.templateParams valueForKey:@"image"] isEqualToString:@""]) {
                fHeight += 65;
            } else {
                fHeight -= 10;
            }

        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            if([[activtyStream.templateParams valueForKey:@"act_key"] rangeOfString:@"add_page"].length > 0){//
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterUserProfile.fullName, Localize(@"EditWiki")];
            } else if([[activtyStream.templateParams valueForKey:@"act_key"] rangeOfString:@"update_page"].length > 0) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterUserProfile.fullName, Localize(@"CreateWiki")];
            }
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            
            float h = [ActivityHelper getHeightSizeForText:[activtyStream.templateParams valueForKey:@"page_name"] andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            
            if([[activtyStream.templateParams valueForKey:@"page_exceprt"] isEqualToString:@""]){
                fHeight -= 20;
            } else {
                text = [activtyStream.templateParams valueForKey:@"page_exceprt"];
                
                float h = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
                if(h > EXO_MAX_HEIGHT){
                    h = EXO_MAX_HEIGHT;
                }
                fHeight += h - 15;
            }
        }
            break;
        case ACTIVITY_FORUM_UPDATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_POST:
        case ACTIVITY_FORUM_CREATE_POST: 
        case ACTIVITY_FORUM_CREATE_TOPIC:{
            float h = 0.0;
            if(activtyStream.activityType == ACTIVITY_FORUM_CREATE_POST){
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterUserProfile.fullName, Localize(@"NewPost")];
                h = [ActivityHelper getHeightSizeForText:[activtyStream.templateParams valueForKey:@"PostName"] andTableViewWidth:fWidth];
            } else if(activtyStream.activityType == ACTIVITY_FORUM_CREATE_TOPIC) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterUserProfile.fullName,  Localize(@"NewTopic")];
                h = [ActivityHelper getHeightSizeForText:[activtyStream.templateParams valueForKey:@"TopicName"] andTableViewWidth:fWidth];
            }else if(activtyStream.activityType == ACTIVITY_FORUM_UPDATE_POST) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterUserProfile.fullName,  Localize(@"UpdatePost")];
                h = [ActivityHelper getHeightSizeForText:[activtyStream.templateParams valueForKey:@"PostName"] andTableViewWidth:fWidth];
            }else if(activtyStream.activityType == ACTIVITY_FORUM_UPDATE_TOPIC) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterUserProfile.fullName,  Localize(@"UpdateTopic")];
                h = [ActivityHelper getHeightSizeForText:[activtyStream.templateParams valueForKey:@"TopicName"] andTableViewWidth:fWidth];
            }
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] + h;
            text = activtyStream.body;
            //fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            h = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h - 10;
        }
            break;
        case ACTIVITY_ANSWER_ADD_QUESTION:
        case ACTIVITY_ANSWER_QUESTION:
        case ACTIVITY_ANSWER_UPDATE_QUESTION:{
            float h = 0.0;
            if(activtyStream.activityType == ACTIVITY_ANSWER_ADD_QUESTION){
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterUserProfile.fullName, Localize(@"Asked")];
            } else if(activtyStream.activityType == ACTIVITY_ANSWER_QUESTION) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterUserProfile.fullName, Localize(@"Answered")];
            }else if(activtyStream.activityType == ACTIVITY_ANSWER_UPDATE_QUESTION) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterUserProfile.fullName, Localize(@"UpdateQuestion")];
            }
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            
            text = [activtyStream.templateParams valueForKey:@"Name"];
            h =  [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            
            text = activtyStream.body;
            h =  [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h - 15;
        }
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:
        case ACTIVITY_CALENDAR_ADD_TASK:
        case ACTIVITY_CALENDAR_ADD_EVENT:
        case ACTIVITY_CALENDAR_UPDATE_EVENT:
        {
            if(activtyStream.activityType == ACTIVITY_CALENDAR_ADD_EVENT){//
                text = [NSString stringWithFormat:@"%@ %@ %@", activtyStream.posterUserProfile.fullName, Localize(@"EventAdded"),[activtyStream.templateParams valueForKey:@"EventSummary"]];
                
            } else if(activtyStream.activityType == ACTIVITY_CALENDAR_UPDATE_EVENT) {
                text = [NSString stringWithFormat:@"%@ %@ %@", activtyStream.posterUserProfile.fullName, Localize(@"EventUpdated"),[activtyStream.templateParams valueForKey:@"EventSummary"]];
            } else if(activtyStream.activityType == ACTIVITY_CALENDAR_ADD_TASK) {
                text = [NSString stringWithFormat:@"%@ %@ %@", activtyStream.posterUserProfile.fullName, Localize(@"TaskAdded"),[activtyStream.templateParams valueForKey:@"EventSummary"]];
            }else if(activtyStream.activityType == ACTIVITY_CALENDAR_UPDATE_EVENT) {
                text = [NSString stringWithFormat:@"%@ %@ %@", activtyStream.posterUserProfile.fullName, Localize(@"TaskUpdated"),[activtyStream.templateParams valueForKey:@"EventSummary"]];
            }
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] + 50;
            text = [activtyStream.templateParams valueForKey:@"EventDescription"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [activtyStream.templateParams valueForKey:@"EventLocale"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
        }
            break;
        default:{
            text = activtyStream.title;
            fHeight = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            
        }
            break;
    }
    
    //Need to calculate the number of <br> + for each br Add 10 pixel
    /*
    NSMutableString *textMutable = [[NSMutableString alloc] init];
    [textMutable setString:text];
    
    int nbBR = [textMutable replaceOccurrencesOfString:@"<br>" withString:@"<br>" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
    
    fHeight += nbBR * 10;
    */
    
    fHeight += [ActivityHelper heightForAllDecorationsWithTableViewWidth:fWidth];
    
    return  fHeight;

    
    
}



@end
