//
//  RCLTableViewController.m
//  RCL
//
//  Created by Clawoo on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLTableViewController.h"

@implementation RCLTableViewController
@synthesize dataSource = dataSource_;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (dataSource_ == nil) {
        self.dataSource = [NSMutableArray array];
    }
    if (loadingView_ == nil) {
        loadingView_ = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height - 18, self.tableView.frame.size.width, 18)];
        loadingView_.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.7];
        
        loadingView_.alpha = 0;
        UILabel *label = [[UILabel alloc] initWithFrame:loadingView_.frame];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"Loading more results...";
        
        UIActivityIndicatorView *paginationSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        paginationSpinner.hidesWhenStopped = YES;
        
        CGRect frame = paginationSpinner.frame;
        frame.origin.x = (loadingView_.frame.size.width - [label.text sizeWithFont:label.font].width)/2 - frame.size.width - 2;
        frame.origin.y = (loadingView_.frame.size.height - frame.size.height)/2;
        paginationSpinner.frame = frame;
        
        [loadingView_ addSubview:label];
        [loadingView_ addSubview:paginationSpinner];
        [self.tableView addSubview:loadingView_];
        [label release];
        [paginationSpinner release];
    }
}

- (void)startLoadingResults:(NSInteger)resultsCount fromIndex:(NSInteger)fromIndex {
    isLoadingNextPage_ = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    loadingView_.alpha = 1;
    [UIView commitAnimations];
}

- (void)didEndLoadingResults:(NSInteger)resultsCount fromIndex:(NSInteger)fromIndex {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    loadingView_.alpha = 0;
    [UIView commitAnimations];
    isLoadingNextPage_ = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    
    if ([indexPaths count]) {
        NSIndexPath *indexPath = [indexPaths objectAtIndex:[indexPaths count]-1];
        
        if (indexPath.row % kRCLTableViewResultsPerPage >= kRCLTableViewResultsPerPage - 5) {
            if (!isLoadingNextPage_ && morePagesAreAvailable_) {
                [self startLoadingResults:kRCLTableViewResultsPerPage fromIndex:[dataSource_ count]];
            }
        }
    }
}

- (void)viewDidUnload {
    [loadingView_ removeFromSuperview];
    loadingView_ = nil;
}

- (void)dealloc {
    self.dataSource = nil;
    [super dealloc];
}

@end