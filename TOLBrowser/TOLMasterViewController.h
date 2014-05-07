//
//  TOLMasterViewController.h
//  TOLBrowser
//
//  Created by Mark Dixon on 5/4/14.
//  Copyright (c) 2014 Mark Dixon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TOLDetailViewController;

#import <CoreData/CoreData.h>

@interface TOLMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) TOLDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property int32_t parentId;

@end
