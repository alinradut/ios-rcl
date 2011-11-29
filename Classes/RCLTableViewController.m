//
//  RCLTableViewController.m
//  RCL
//
//  Created by Clawoo on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLTableViewController.h"

@interface RCLTableViewController (Private)
- (void)addRefreshHeaderView;
@end

@implementation RCLTableViewController
@synthesize dataSource = dataSource_;
@synthesize lastRefreshDate = lastRefreshDate_;
@synthesize tableView = tableView_;
@synthesize isPullToRefreshEnabled = isPullToRefreshEnabled_;
@synthesize isPaginationEnabled = isPaginationEnabled_;

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
    
    [self setIsPaginationEnabled:isPaginationEnabled_];
    [self setIsPullToRefreshEnabled:isPullToRefreshEnabled_];
}

- (void)addRefreshHeaderView {
    refreshHeaderView_ = [[RCLTableRefreshHeader alloc] init];
    [self.tableView addSubview:refreshHeaderView_];
    [refreshHeaderView_ release];
}

- (void)setIsPaginationEnabled:(BOOL)flag
{
    isPaginationEnabled_ = flag;
    if (isPaginationEnabled_) {
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
}

- (void)setIsPullToRefreshEnabled:(BOOL)flag
{
    isPullToRefreshEnabled_ = flag;
    if (isPullToRefreshEnabled_) {
        if (![refreshHeaderView_ superview]) {
            [self addRefreshHeaderView];
        }
    }
    else {
        [refreshHeaderView_ removeFromSuperview];
        refreshHeaderView_ = nil;
    }
}


#pragma mark -
#pragma mark Pagination methods
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

#pragma mark -
#pragma mark Pull to refresh methods
- (void)startReloadingResults {
    isReloading_ = YES;
    
    // Show the header
    [refreshHeaderView_ setState:RCLTableRefreshStateLoading];
}

- (void)didEndReloadingResults {
    isReloading_ = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
    self.lastRefreshDate = [NSDate date];
    [refreshHeaderView_ setLastRefreshDate:lastRefreshDate_];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    [refreshHeaderView_ setState:RCLTableRefreshStateNormal];
}

#pragma mark -
#pragma mark UIScrollView methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (isPullToRefreshEnabled_) {
        if (isReloading_) return;
        isDragging_ = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // pull to refresh
    if (isPullToRefreshEnabled_) {
        if (isReloading_) {
            // Update the content inset, good for section headers
            if (scrollView.contentOffset.y > 0) {
                self.tableView.contentInset = UIEdgeInsetsZero;
            }
            else if (scrollView.contentOffset.y >= -kRCLRefreshHeaderHeight) {
                self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            }
            return;
        } else if (isDragging_ && scrollView.contentOffset.y < 0) {
            // User is scrolling above the header
            if (scrollView.contentOffset.y < -kRCLRefreshHeaderHeight) {
                [refreshHeaderView_ setState:RCLTableRefreshStateDragging];
            } 
            // User is scrolling somewhere within the header
            else { 
                [refreshHeaderView_ setState:RCLTableRefreshStateNormal];
            }
            return;
        }
    }
    
    if (isPaginationEnabled_) {
        // pagination
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
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (isPullToRefreshEnabled_) {
        if (isReloading_) return;
        isDragging_ = NO;
        
        if (scrollView.contentOffset.y <= -kRCLRefreshHeaderHeight) {
            // Released above the header
            [self startReloadingResults];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *visibleCells = [self.tableView visibleCells];
    for (UITableViewCell *cell in visibleCells) {
        if ([cell respondsToSelector:@selector(loadPicture)]) {
            [cell performSelector:@selector(loadPicture)];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma -
#pragma Memory management
- (void)viewDidUnload {
    [super viewDidUnload];
    // clean up work that has been done in the viewDidLoad method
    if (refreshHeaderView_) {
        [refreshHeaderView_ removeFromSuperview];
        refreshHeaderView_ = nil;
    }
}

- (void)dealloc {
    [loadingView_ removeFromSuperview];
    [loadingView_ release];
    loadingView_ = nil;
    self.dataSource = nil;
    self.tableView = nil;
    self.lastRefreshDate = nil;
    [super dealloc];
}

@end