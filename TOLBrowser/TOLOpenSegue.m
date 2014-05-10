//
//  TOLOpenSegue.m
//  Tree Of Life
//
//  Created by Mark Dixon on 5/10/14.
//  Copyright (c) 2014 Mark Dixon. All rights reserved.
//

#import "TOLOpenSegue.h"
#import "TOLAppDelegate.h"

@implementation TOLOpenSegue

- (void) perform {
    TOLAppDelegate *appDelegate = (TOLAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = [self destinationViewController];
}

@end
