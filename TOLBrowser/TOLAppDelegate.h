//
//  TOLAppDelegate.h
//  TOLBrowser
//
//  Created by Mark Dixon on 5/4/14.
//  Copyright (c) 2014 Mark Dixon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
