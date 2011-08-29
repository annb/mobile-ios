//
//  DocumentsViewController_iPhone.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "DocumentsViewController.h"
#import "FileActionsViewController_iPhone.h"



@interface DocumentsViewController_iPhone : DocumentsViewController {
    
    FileActionsViewController_iPhone *_actionsViewController;
    
    UIView *_maskingViewForActions;
    
}


@end
