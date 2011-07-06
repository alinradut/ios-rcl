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
@synthesize lastRefreshDate = lastRefreshDate_;
@synthesize tableView = tableView_;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (dataSource_ == nil) {
        self.dataSource = [NSMutableArray array];
    }

    if (tableView_ == nil) {
        tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        tableView_.delegate = self;
        tableView_.dataSource = self;
        [self.view addSubview:tableView_];
    }

    if (loadingView_ == nil) {
        loadingView_ = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height - 18, self.tableView.frame.size.width, 18)];
        loadingView_.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.8];
        loadingView_.alpha = 1;
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingView_.frame.size.width, loadingView_.frame.size.height)] autorelease];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"Loading results...";
        
        UIActivityIndicatorView *paginationSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
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
    if (isLoadingNextPage_) {
        return;
    }
    isLoadingNextPage_ = YES;
    if (self.tableView.superview) {
        CGPoint positionInWindow = [self.tableView.superview convertPoint:self.tableView.frame.origin toView:self.tableView.superview];
        CGRect frame = CGRectMake(0, positionInWindow.y + self.tableView.frame.size.height - 18, self.tableView.frame.size.width, 18);
        loadingView_.frame = frame;
        [self.tableView.superview addSubview:loadingView_];
    }
    [(UIActivityIndicatorView *)[loadingView_ viewWithTag:1] startAnimating];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    loadingView_.alpha = 1;
    [UIView commitAnimations];
}

- (void)didEndLoadingResults:(NSInteger)resultsCount fromIndex:(NSInteger)fromIndex {
    [(UIActivityIndicatorView *)[loadingView_ viewWithTag:1] stopAnimating];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    loadingView_.alpha = 0;
    [UIView commitAnimations];
    isLoadingNextPage_ = NO;
    self.lastRefreshDate = [NSDate date];
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![dataSource_ count]) {
        return;
    }
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    
    if ([indexPaths count]) {
        NSIndexPath *indexPath = [indexPaths objectAtIndex:[indexPaths count]-1];
        
        if (indexPath.row >= [dataSource_ count] - 5) {
            if (!isLoadingNextPage_ && morePagesAreAvailable_) {
                [self startLoadingResults:kRCLTableViewResultsPerPage fromIndex:[dataSource_ count]];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *visibleCells = [self.tableView visibleCells];
    for (UITableViewCell *cell in visibleCells) {
        if ([cell respondsToSelector:@selector(loadPicture)]) {
            [cell performSelector:@selector(loadPicture)];
        }
    }
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [loadingView_ removeFromSuperview];
    [loadingView_ release];
    loadingView_ = nil;
    self.dataSource = nil;
    self.tableView = nil;
    [super dealloc];
}

@end