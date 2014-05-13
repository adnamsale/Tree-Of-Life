//
//  TOLSearchTableViewController.m
//  TOLBuilder
//
//  Created by Mark Dixon on 5/4/14.
//  Copyright (c) 2014 Mark Dixon. All rights reserved.
//

#import "TOLSearchTableViewController.h"
#import "TOLMasterViewController.h"
#import "Node.h"

@interface TOLSearchTableViewController ()

@end

@implementation TOLSearchTableViewController
NSArray *results;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    results = [NSArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    Node *node = [results objectAtIndex:[indexPath indexAtPosition:1]];
    cell.textLabel.text = node.name;
    cell.detailTextLabel.text = node.desc;
    
    return cell;
}


#pragma mark - Navigation

- (void)navigateToParentId:(int)parentId
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    while (1 < parentId) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Node" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *error;
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id = %d", parentId]];
        
        NSArray *res = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        Node *parentNode = [res objectAtIndex:0];

        TOLMasterViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"Master"];
        dest.parentId = parentId;
        dest.managedObjectContext = self.managedObjectContext;
        dest.title = parentNode.name;
        [arr insertObject:dest atIndex:0];

        parentId = parentNode.parentId;
    }
    UIViewController *root = [self.navigationController.viewControllers objectAtIndex:0];
    [arr insertObject:root atIndex:0];
    
    [self.navigationController setViewControllers:arr animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node *node = [results objectAtIndex:[indexPath indexAtPosition:1]];
    [self navigateToParentId:node.parentId];
}

 /*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Search
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if ([searchString length] < 3) {
        results = [NSArray array];
        return YES;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Node" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name contains %@ or desc contains %@", searchString, searchString]];
    
    results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return YES;
}
@end
