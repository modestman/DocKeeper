//
//  DocumentDetailViewController.m
//  DocKeeper
//
//  Created by Admin on 05.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//

#import "DocumentDetailViewController.h"
#import "CollectionViewCell.h"
#import "ZoomedPhotoViewController.h"
#import "UIImage+Resize.h"

@interface PictureItem : NSObject
    @property (nonatomic, strong) NSManagedObjectID *objectId;
    @property (nonatomic, strong) UIImage *image;
@end

@implementation PictureItem
@end;


@interface DocumentDetailViewController ()
{
    NSManagedObjectContext *moc;
    NSMutableArray<PictureItem*> *pictures;
    BOOL isNew;
    BOOL editMode;
    BOOL docChanged;
}
@end

@implementation DocumentDetailViewController

@synthesize document;

- (void)viewDidLoad {
    [super viewDidLoad];
    isNew = self.document == nil;
    editMode = NO;
    docChanged = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    moc = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    pictures = [NSMutableArray new];
    if (isNew)
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:moc];
        self.document = (Document*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:moc];
        self.title = NSLocalizedString(@"New Document", nil);
    }
    else
    {
        self.title = NSLocalizedString(@"Document", nil);
        self.docNameField.text = self.document.title;
        dispatch_queue_t queue = dispatch_queue_create("loadData", nil);
        dispatch_async(queue, ^{
            [self fillPicturesArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [collectionView reloadData];
            });
        });
    }
}

-(void)fillPicturesArray
{
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *ar = [[self.document.pictures allObjects] sortedArrayUsingDescriptors:@[dateSort]];
    for (Picture *pic in ar) {
        PictureItem *picItem = [PictureItem new];
        picItem.objectId = pic.objectID;
        picItem.image = [UIImage imageWithData:pic.preview];        
        [pictures addObject:picItem];
    }
}

-(IBAction)addPhoto:(UIButton *)sender
{
    if (!imagePickerController) {
        imagePickerController = [[UIImagePickerController alloc] init];
        
        // If our device has a camera, we want to take a picture, otherwise, we just pick from photo library
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else
        {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [imagePickerController setDelegate:self];
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // Capture image from camera or gallery and make thumbnail
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGSize celltSize = ((UICollectionViewFlowLayout*)collectionView.collectionViewLayout).itemSize;
    UIImage *cellPreview = [image resizedImageToFitInSize:celltSize scaleIfSmaller:NO];
    
    // Add image to Picture entity
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Picture" inManagedObjectContext:moc];
    Picture *pic = (Picture*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:moc];
    pic.data = UIImageJPEGRepresentation(image, 0.9);
    pic.preview = UIImageJPEGRepresentation(cellPreview, 0.9);
    pic.date = [NSDate date];
    [self.document addPicturesObject:pic];
    // Document will be saved at ManagedObjectContext when Done button click
    
    // add thumbnail to collection view
    PictureItem *item = [PictureItem new];
    item.objectId = pic.objectID;
    item.image = cellPreview;
    [pictures addObject:item];
    [collectionView reloadData];
    docChanged = YES;
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    self.document.title = self.docNameField.text;
    BOOL isEmpty = NO;
    if (docChanged)
    {
        if ([pictures count] > 0)
        {
            UIImage *docPreview = [[pictures firstObject].image resizedImageToFitInSize:CGSizeMake(50, 50) scaleIfSmaller:NO];
            self.document.preview = UIImageJPEGRepresentation(docPreview, 1.0);
        }
        else
        {
            self.document.preview = nil;
        }
    }
    if (isNew)
    {
        self.document.date = [NSDate date];
        isEmpty = ([pictures count] == 0) && (self.docNameField.text.length == 0);
    }
    
    if (!isEmpty)
    {
        NSError *error = nil;
        if ([self.document.title length] > 0)
        {
            [moc save:&error];
        }
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    else
    {
        [moc deleteObject:self.document];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)edit:(id)sender
{
    editMode = !editMode;
    collectionView.allowsMultipleSelection = editMode;
    self.deletePhotosButton.hidden = !editMode;
    if (editMode)
    {
        [self.editPhotosButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    }
    else
    {
        [self.editPhotosButton setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    }
    [collectionView reloadData];
}

- (IBAction)delete:(id)sender
{
    [collectionView performBatchUpdates:^{
        
        NSArray *selectedItemsIndexPaths = [collectionView indexPathsForSelectedItems];
        // Delete the items from the data source.
        [self deleteItemsFromDataSourceAtIndexPaths:selectedItemsIndexPaths];
        // Now delete the items from the collection view.
        [collectionView deleteItemsAtIndexPaths:selectedItemsIndexPaths];
    } completion:nil];
}

-(void)deleteItemsFromDataSourceAtIndexPaths:(NSArray  *)itemPaths
{
    if ([itemPaths count] == 0) return;
    docChanged = YES;
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *itemPath  in itemPaths) {
        [indexSet addIndex:itemPath.row];
        NSManagedObject *obj = [moc objectWithID:pictures[itemPath.row].objectId];
        [moc deleteObject:obj];
    }
    [pictures removeObjectsAtIndexes:indexSet];
    NSError *error = nil;
    [moc save:&error];
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    if (isNew)
    {
        [moc deleteObject:self.document];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CollectionView datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [pictures count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_ cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)_cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell*)_cell;
    PictureItem *picItem = pictures[indexPath.row];
    cell.imageView.image = picItem.image;
    cell.selectable = editMode;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!editMode)
    {        
        [self performSegueWithIdentifier:@"ZoomedSegue" sender:indexPath];
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ZoomedSegue"] && [sender isKindOfClass:[NSIndexPath class]])
    {
        ZoomedPhotoViewController *zoomVC = (ZoomedPhotoViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        Picture *obj = (Picture*)[moc objectWithID:pictures[indexPath.row].objectId];
        zoomVC.image = [UIImage imageWithData:obj.data];
    }
}

@end
