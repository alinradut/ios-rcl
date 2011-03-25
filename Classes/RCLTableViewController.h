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
    
    UIView *loadingView_;
}

@property (nonatomic, retain) NSMutableArray *dataSource;

@end
