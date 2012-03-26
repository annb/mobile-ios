//
//  CustomBackgroundForCell_iPhone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 11/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomBackgroundForCell_iPhone.h"


@implementation CustomBackgroundForCell_iPhone

@synthesize cellPosition = _cellPosition;





-(void)setBackgroundForRow:(int)rowIndex inSectionSize:(int)numberOfRowInSection{
    
    CustomCellBackgroundViewPosition pos;
	
	pos = CustomCellBackgroundViewPositionBottom;
	
	if (rowIndex == 0) {
		pos = CustomCellBackgroundViewPositionTop;
	} else {
		if (rowIndex < numberOfRowInSection-1) {
			pos = CustomCellBackgroundViewPositionMiddle;
		}
	}
	
	if (numberOfRowInSection == 1) {
		pos = CustomCellBackgroundViewPositionSingle;
	}
    
    [self setBackgroundForPosition:pos];
    
}



-(void)setBackgroundForPosition:(CustomCellBackgroundViewPosition)position {

    self.cellPosition = position;
    
    
    //Some customize of the cell background :-)
    [self setBackgroundColor:[UIColor clearColor]];
    
    //Create an image streachable images for background
    UIImage *imgBgNormal;
    
    UIImage *imgBgSelected;
    
    if (self.cellPosition == CustomCellBackgroundViewPositionTop) {
        //If the position is top
        imgBgNormal = [[UIImage imageNamed:@"CustomBackgroundForCellTop.png"]
                       stretchableImageWithLeftCapWidth:5 topCapHeight:10];
        imgBgSelected = [[UIImage imageNamed:@"CustomBackgroundForCellTopSelected.png"]
                       stretchableImageWithLeftCapWidth:5 topCapHeight:10];
        
    } else if (self.cellPosition == CustomCellBackgroundViewPositionBottom) {
        //If the position is bottom
        imgBgNormal = [[UIImage imageNamed:@"CustomBackgroundForCellBottom.png"]
                       stretchableImageWithLeftCapWidth:5 topCapHeight:10];
        imgBgSelected = [[UIImage imageNamed:@"CustomBackgroundForCellBottomSelected.png"]
                         stretchableImageWithLeftCapWidth:5 topCapHeight:10];
	
    } else if (self.cellPosition == CustomCellBackgroundViewPositionMiddle) {
        //If the position is Middle
        imgBgNormal = [[UIImage imageNamed:@"CustomBackgroundForCellMiddle.png"]
                       stretchableImageWithLeftCapWidth:5 topCapHeight:10];
        imgBgSelected = [[UIImage imageNamed:@"CustomBackgroundForCellMiddleSelected.png"]
                         stretchableImageWithLeftCapWidth:5 topCapHeight:10];
	
    } else if (self.cellPosition == CustomCellBackgroundViewPositionSingle) {
        //If the position is Single
        imgBgNormal = [[UIImage imageNamed:@"CustomBackgroundForCellSingle.png"]
                       stretchableImageWithLeftCapWidth:6 topCapHeight:10];
        imgBgSelected = [[UIImage imageNamed:@"CustomBackgroundForCellSingleSelected.png"]
                         stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    
    }
    
    //Add images to imageView for the backgroundview of the cell
    UIImageView *imgVCellBGNormal = [[UIImageView alloc] initWithImage:imgBgNormal];
    
    UIImageView *imgVCellBGSelected = [[UIImageView alloc] initWithImage:imgBgSelected];
    
    
    [self setBackgroundView:imgVCellBGNormal];
    [self setSelectedBackgroundView:imgVCellBGSelected];

    
    [imgVCellBGNormal release];
    [imgVCellBGSelected release];
    
}


@end
