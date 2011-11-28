//
//  RCLModalPickerView.m
//  RCL
//
//  Created by Clawoo on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLModalPickerView.h"
#import "RCL.h"

#define kRCLToolbarHeight   44

@implementation RCLModalPickerView
@synthesize delegate = delegate_;

- (id)init {
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    self = [super initWithFrame:window.frame];
    if (self) {
        backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        backgroundView_.backgroundColor = [UIColor darkGrayColor];
        backgroundView_.alpha = 0;
        [self addSubview:backgroundView_];
        
        pickerView_ = [[UIPickerView alloc] init];
        pickerView_.frame = CGRectSetY(pickerView_.frame, window.frame.size.height + kRCLToolbarHeight);
        pickerView_.dataSource = self;
        pickerView_.delegate = self;
        pickerView_.showsSelectionIndicator = YES;
        [self addSubview:pickerView_];
        
        UIBarButtonItem *barItem = nil; 
        NSMutableArray *tabBarItems = [NSMutableArray array];
        barItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
        [tabBarItems addObject:barItem];
        
        barItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        [tabBarItems addObject:barItem];
        
        barItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)] autorelease];
        [tabBarItems addObject:barItem];
        
        toolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0, window.frame.size.height, 320, 44)];
        toolbar_.barStyle = UIBarStyleBlackOpaque;
        toolbar_.items = tabBarItems;
        [self addSubview:toolbar_];
        
        values_ = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [window addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.33];
    backgroundView_.alpha = 0.4;
    pickerView_.frame = CGRectSetY(pickerView_.frame, window.frame.size.height - pickerView_.frame.size.height);
    toolbar_.frame = CGRectSetY(toolbar_.frame, window.frame.size.height - pickerView_.frame.size.height - kRCLToolbarHeight);
    [UIView commitAnimations];
}

- (void)dismiss {
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [window addSubview:self];
    
    [UIView beginAnimations:@"dismiss" context:nil];
    [UIView setAnimationDuration:.33];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDelegate:self];
    backgroundView_.alpha = 0.0;
    toolbar_.frame = CGRectSetY(toolbar_.frame, window.frame.size.height);
    pickerView_.frame = CGRectSetY(pickerView_.frame, window.frame.size.height + kRCLToolbarHeight);
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID isEqualToString:@"dismiss"]) {
        [self removeFromSuperview];
    }
}

- (void)cancel {
    if ([delegate_ respondsToSelector:@selector(modalPickerViewDidCancel:)]) {
        [delegate_ modalPickerViewDidCancel:self];
    }
    [self dismiss];
}

- (void)done {
    [self dismiss];
    [delegate_ modalPickerView:self didDismissWithValue:[values_ objectAtIndex:[pickerView_ selectedRowInComponent:0]]];
}

- (void)setTitle:(NSString *)title {
    NSMutableArray *items = [NSMutableArray arrayWithArray:toolbar_.items];
    while ([items count] > 2) {
        [items removeObjectAtIndex:1];
    }
    
    UIBarButtonItem *barItem = nil;

    if ([title length]) {
        CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:12]];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 7, size.width, size.height)] autorelease];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = title;
        label.font = [UIFont boldSystemFontOfSize:12];
        
        barItem = [[[UIBarButtonItem alloc] initWithCustomView:label] autorelease];
        [items insertObject:barItem atIndex:[items count]-1];
    }
    
    barItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    [items insertObject:barItem atIndex:[items count]-1];
    
    toolbar_.items = items;
}

- (void)setValues:(NSArray *)values {
    [values_ removeAllObjects];
    [values_ addObjectsFromArray:values];
    
    [pickerView_ reloadAllComponents];
}

- (void)selectValue:(NSString *)value
{
    for (int i=0; i < [values_ count]; i++) {
        if ([[values_ objectAtIndex:i] isEqualToString:value]) {
            [pickerView_ selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([delegate_ respondsToSelector:@selector(modalPickerView:didSelectRow:)]) {
        [delegate_ modalPickerView:self didSelectValue:[values_ objectAtIndex:[pickerView_ selectedRowInComponent:0]]];
    }
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [values_ count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@", [values_ objectAtIndex:row]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc {
    [backgroundView_ release];
    [pickerView_ release];
    [toolbar_ release];
    [values_ release];
    [super dealloc];
}

@end
