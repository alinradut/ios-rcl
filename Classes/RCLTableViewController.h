//
//  RCLTableViewController.h
//  RCL
//
//  Created by Clawoo on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRCLTableViewResultsPerPage 10

/*!
 RCLTableViewController enhances the default table view controller
 with pagination and other functionality 
 */
@interface RCLTableViewController : UITableViewController {
    NSMutableArray *dataSource_;
    NSInteger totalResults_;
    NSInteger resultsPerPage_;
    BOOL isLoadingNextPage_;
    BOOL morePagesAreAvailable_;
    /*!
     The 'loading more results' loading view
     */
    UIView *loadingView_;
}

@property (nonatomic, retain) NSMutableArray *dataSource;

/*!
 This method is called when a new page of data is needed.
 @param resultsCount The number of results requested (usually kRCLTableViewResultsPerPage)
 @param fromIndex The index from where to load results from.
 */
- (void)startLoadingResults:(NSInteger)resultsCount fromIndex:(NSInteger)fromIndex;

/*!
 This method should be manually called when results have been loaded.
 @param resultsCount The number of results that have actually been added to the dataSource.
 @param fromIndex The index the results start from.
 */
- (void)didEndLoadingResults:(NSInteger)resultsCount fromIndex:(NSInteger)fromIndex;

@end
