//
//  RCLModalPickerExample.m
//  RCL
//
//  Created by Clawoo on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLModalPickerExample.h"
#import "RCLModalPickerView.h"
@implementation RCLModalPickerExample

- (IBAction)showPicker:(id)sender
{
    RCLModalPickerView *picker = [[RCLModalPickerView alloc] init];
    [picker setTitle:@"Color"];
    
    NSMutableArray *kv = [NSMutableArray array];
    [kv addObject:@"val 1"];
    [kv addObject:@"val 2"];
    [kv addObject:@"val 3"];
    
    [picker setValues:kv];
    [picker selectValue:@"key1"];
    [picker show];
    [picker release];
}

@end
