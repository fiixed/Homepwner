//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Andrew Bell on 1/2/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "ItemsViewController.h"

#import "DetailViewController.h"
#import "ItemStore.h"
#import "Item.h"

@interface ItemsViewController ()

@end

@implementation ItemsViewController

- (instancetype)init
{
    // Call the superclasses designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Homepwner";
    
    // Create a new bar button item that will send addNewItem: to ItemsViewController
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self action:@selector(addNewItem:)];
    
    // Save this bar button item as the right item in the navigationItem
    navItem.rightBarButtonItem = bbi;
    
    navItem.leftBarButtonItem = self.editButtonItem;
   
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}


#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create an instance of UITableViewCell, with default appearance
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    // Set the text on the cell with the description of the item that it is at the nth index of items, where n = row this cell will appear on the tableview
    NSArray *items = [[ItemStore sharedStore] allItems];
    Item *item = items[indexPath.row];
    
    
    cell.textLabel.text = [item description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the tableView is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[ItemStore sharedStore] allItems];
        Item *item = items[indexPath.row];
        [[ItemStore sharedStore] removeItem:item];
        
        // Also remove that row from the tableview with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    [[ItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                     toIndex:destinationIndexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    // get number of objects
    NSUInteger numberOfObjects = [[[ItemStore sharedStore] allItems] count];
    
    if ( (proposedDestinationIndexPath.row+1==numberOfObjects) || (sourceIndexPath.row+1==numberOfObjects) ) {
        return sourceIndexPath;
    }
    else{
       
        return proposedDestinationIndexPath;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == totalRow - 1) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[ItemStore sharedStore] allItems];
    Item *selectedItem = items[indexPath.row];
    
    // Give your detailViewController a pointer to the item object in row
    detailViewController.item = selectedItem;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

#pragma mark - IBAction 

- (IBAction)addNewItem:(id)sender
{
   // Create a new Item and add it to the store
    Item *item = [[ItemStore sharedStore] createItem];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    
    detailViewController.item = item;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navcontroller = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
 
//    navcontroller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    [self presentViewController:navcontroller animated:YES completion:NULL];
    
}





@end
