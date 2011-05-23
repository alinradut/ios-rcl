//
//  RCLTVCExample.m
//  RCL
//
//  Created by Clawoo on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLTVCExample.h"
#import "RCLLoadingView.h"
@implementation RCLTVCExample

- (void)viewDidLoad {
    [super viewDidLoad];
    names_ = [[NSArray alloc] initWithObjects:@"Mary",@"John",@"Lucy",@"Jenn",@"Richard", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addNames];
    [self addNames];
    [self addNames];
}

- (void)viewDidAppear:(BOOL)animated {
    [RCLLoadingView showWithLabel:@"Loading..."];
}

- (void)addNames {
    for (NSString *name in names_) {
        [dataSource_ addObject:[name stringByAppendingFormat:@" %d",[dataSource_ count]]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.textLabel.text = [dataSource_ objectAtIndex:indexPath.row];
    return cell;
}

- (void)startLoadingResults:(NSInteger)resultsCount fromIndex:(NSInteger)fromIndex {
    [super startLoadingResults:resultsCount fromIndex:fromIndex];
    [self addNames];
    [self addNames];
    [self performSelector:@selector(finish:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:resultsCount],[NSNumber numberWithInt:fromIndex], nil] afterDelay:5];
}

- (void)finish:(NSArray *)arr {
    NSInteger resultsCount = [[arr objectAtIndex:0] intValue];
    NSInteger fromIndex = [[arr objectAtIndex:1] intValue];
    [self didEndLoadingResults:resultsCount fromIndex:fromIndex];
}

@end