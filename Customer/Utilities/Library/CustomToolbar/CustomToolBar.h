//
//  CustomToolBar.h
//  OTap
//
//  Created by webwerks on 10/19/15.
//  Copyright (c) 2015 AR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomToolBar;

@protocol customToolBarDelegate

- (void)doneButtonPress;

@end

@interface CustomToolBar : UIBarButtonItem

+(CustomToolBar*) sharedInstance;
- (UIToolbar*)createToolbarframe:(CGRect)pickerFrame;
@property (nonatomic) UIButton *done;

@property (nonatomic, weak) id<customToolBarDelegate> delegate;

@end
