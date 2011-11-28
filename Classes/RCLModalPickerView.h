//
//  RCLModalPickerView.h
//  RCL
//
//  Created by Clawoo on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCLModalPickerViewDelegate;

@interface RCLModalPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource> {
    UIPickerView *pickerView_;
    UIView *backgroundView_;
    UIToolbar *toolbar_;
    id<RCLModalPickerViewDelegate> delegate_;
    
    NSMutableArray *values_;
}

@property (nonatomic, retain) id<RCLModalPickerViewDelegate> delegate;

- (void)show;
- (void)dismiss;
- (void)setTitle:(NSString *)title;
- (void)setValues:(NSArray *)values;
- (void)selectValue:(NSString *)value;

@end

@protocol RCLModalPickerViewDelegate <NSObject>

- (void)modalPickerView:(RCLModalPickerView *)pickerView didDismissWithValue:(id)value;

@optional
- (void)modalPickerView:(RCLModalPickerView *)pickerView didSelectValue:(id)value;
- (void)modalPickerViewDidCancel:(RCLModalPickerView *)pickerView;

@end