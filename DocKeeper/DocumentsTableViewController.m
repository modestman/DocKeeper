//
//  DocumentsTableViewController.m
//  DocKeeper
//
//  Created by Admin on 04.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>
#import "DocumentsTableViewController.h"
#import "DocumentDetailViewController.h"
#import "Document.h"
#import "TableViewCell.h"

@interface DocumentsTableViewController () 
{
    NSFetchedResultsController *fetchedResultsController;
    NSDateFormatter *dateFormatter;
}
@end

@implementation DocumentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
    
    [self initializeFetchedResultsController];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Document"];
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[dateSort]];
    
    NSManagedObjectContext *moc = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:moc
                                                                     sectionNameKeyPath:nil cacheName:nil];
    [fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id< NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (void)configureCell:(TableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Document *object = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = object.title;
    cell.dateLabel.text = [dateFormatter stringFromDate:object.date];
    cell.leftImageView.image = object.preview != nil ? [UIImage imageWithData:object.preview] :
                                                       [UIImage imageNamed:@"no-thumb"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Document *object = [fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowDetailSegue" sender:object];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Document *object = [fetchedResultsController objectAtIndexPath:indexPath];
        NSError *error;
        [fetchedResultsController.managedObjectContext deleteObject:object];
        [fetchedResultsController.managedObjectContext save:&error];
        if (error)
        {
            NSLog(@"Error while deleting object: %@", error.localizedDescription);
        }
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetailSegue"])
    {
        if ([sender isKindOfClass:[Document class]])
        {
            UINavigationController *navController = segue.destinationViewController;
            [(DocumentDetailViewController*)[[navController childViewControllers] firstObject] setDocument:sender];
        }
    }
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[[self tableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] endUpdates];
}

#pragma mark -

- (IBAction)addNew:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"ShowDetailSegue" sender:nil];
}

- (IBAction)exit:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetPassword:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Are you sure?", nil)
                                                                             message:NSLocalizedString(@"All data will be removed", nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self resetPassworAndData];
                                                     }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)resetPassworAndData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Document"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    AppDelegate *app = ((AppDelegate*)[UIApplication sharedApplication].delegate);
    NSError *deleteError = nil;
    [app.persistentStoreCoordinator executeRequest:delete withContext:app.managedObjectContext error:&deleteError];
    
    [SSKeychain deletePasswordForService:keychainService account:keychainAccount];
    [self exit:nil];
}

@end
