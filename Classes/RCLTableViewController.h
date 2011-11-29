//
//  RCLTableViewController.h
//  RCL
//
//  Created by Clawoo on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLTableRefreshHeader.h"

#define kRCLTableViewResultsPerPage 10

/*!
 RCLTableViewController enhances the default table view controller
 with pagination and other functionality 
 */
@interface RCLTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    BOOL isPaginationEnabled_;
    BOOL isPullToRefreshEnabled_;
    
    UITableView     *tableView_;
    NSMutableArray  *dataSource_;
    UIView          *loadingView_;
    
    NSInteger       totalResults_;
    NSInteger       resultsPerPage_;
    BOOL            isLoadingNextPage_;
    BOOL            morePagesAreAvailable_;
    BOOL            reloadDataWhenStoppedDecelerating_;
    
    // pull to refresh
    RCLTableRefreshHeader   *refreshHeaderView_;
    NSDate                  *lastRefreshDate_;
    BOOL                    isDragging_;
    BOOL                    isReloading_;
    
}

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSDate *lastRefreshDate;
@property (nonatomic, assign) BOOL isPaginationEnabled;
@property (nonatomic, assign) BOOL isPullToRefreshEnabled;
/*!
 This method is called when a new page of data is needed. Your implementation 
 should override it and call super.
 @param resultsCount The number of results requested (usually kRCLTableViewResultsPerPage)
 @param fromIndex The index from where to load results from.
 */
- (void)startLoadingResults:(NSInteger)resultsCount fromIndex:(NSInteger)fromIndex;

/*!
 This method should be manually called when results have been loaded. Your implementation
 should call it after the results have been loaded.
 @param resultsCount The number of results that have actually been added to the dataSource.
 @param fromIndex The index the results start from.
 */
- (void)didEndLoadingResults:(NSInteger)resultsCount fromIndex:(NSInteger)fromIndex;


/*!
 This method is called when the user has completed a PTR gesture.
 The table view controller should override this method and start loading data 
 in background
 */
- (void)startReloadingResults;

/*!
 This method must be called manually after the reload of the data has been
 completed.
 */
- (void)didEndReloadingResults;

@end
