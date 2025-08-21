//
//  CustomToolBar.m
//  OTap
//
//  Created by webwerks on 10/19/15.
//  Copyright (c) 2015 AR. All rights reserved.
//

#import "CustomToolBar.h"

@implementation CustomToolBar
@synthesize delegate,done;

static CustomToolBar *sharedInstance;

+(CustomToolBar*) sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[CustomToolBar alloc] init];
    }
    return sharedInstance;
    
}

- (UIToolbar*)createToolbarframe:(CGRect)pickerFrame
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:pickerFrame];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    toolBar.tintColor = [UIColor grayColor];
    toolBar.barTintColor = [UIColor colorWithRed:231.0f/255.0f green:231.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    [done setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
    [done setTitle:@"Done".localizedUppercaseString forState:UIControlStateNormal];
    [done addTarget:self action:@selector(onClickOfOkButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bbiDone = [[UIBarButtonItem alloc] initWithCustomView:done];
    [toolBar setItems:[NSArray arrayWithObjects:flexibleSpace, bbiDone, nil]];
    return toolBar;
}

-(void)onClickOfOkButton
{
    if ([self delegate])
    {
        [[self delegate] doneButtonPress];
    }
}

@end
