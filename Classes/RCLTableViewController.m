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
        loadingView_ = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height - 18, self.tableView.frame.size.width, 18)];
        loadingView_.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.7];
        loadingView_.alpha = 1;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingView_.frame.size.width, loadingView_.frame.size.height)];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"Loading more results...";
        
        UIActivityIndicatorView *paginationSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        paginationSpinner.tag = 1;

        CGRect frame = paginationSpinner.frame;
        frame.size = CGSizeMake(17, 17);
        frame.origin.x = (loadingView_.frame.size.width - [label.text sizeWithFont:label.font].width)/2 - frame.size.width - 2;
        frame.origin.y = (loadingView_.frame.size.height - frame.size.height)/2;
        paginationSpinner.frame = frame;
        
        [loadingView_ addSubview:label];
        [loadingView_ addSubview:paginationSpinner];
    }
}

- (void)startLoadingResults:(NSInteger)resultsCount fromIndex:(NSInteger)fromIndex {
    if (![loadingView_ superview]) {
        CGRect frame = CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height - 18, self.tableView.frame.size.width, 18);
        loadingView_.frame = frame;
        // attach the loading view to the table's superview
        // to allow the table to scroll while the loading view stays fixed
        [self.tableView.superview addSubview:loadingView_];
    }
    [(UIActivityIndicatorView *)[loadingView_ viewWithTag:1] startAnimating];
    
    isLoadingNextPage_ = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    loadingView_.alpha = 1;
    [UIView commitAnimations];
}

- (void)didEndLoadingResults:(NSInteger)resultsCount fromIndex:(NSInteger)fromIndex {
    [self.tableView beginUpdates];
    
    NSMutableArray *indexes = [NSMutableArray array];
    for (int i=fromIndex; i<fromIndex + resultsCount; i++) {
        [indexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.tableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];

    [(UIActivityIndicatorView *)[loadingView_ viewWithTag:1] stopAnimating];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    loadingView_.alpha = 0;
    [UIView commitAnimations];
    isLoadingNextPage_ = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    
    if ([indexPaths count]) {
        NSIndexPath *indexPath = [indexPaths objectAtIndex:[indexPaths count]-1];
        
        if (indexPath.row >= [dataSource_ count] - 5) {
            if (!isLoadingNextPage_) {
                [self startLoadingResults:kRCLTableViewResultsPerPage fromIndex:[dataSource_ count]];
            }
        }
    }
}

- (void)viewDidUnload {
    [loadingView_ release];
    loadingView_ = nil;
}

- (void)dealloc {
    self.dataSource = nil;
    [super dealloc];
}

@end