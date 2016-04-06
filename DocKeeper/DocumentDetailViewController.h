//
//  DocumentDetailViewController.h
//  DocKeeper
//
//  Created by Admin on 05.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Document.h"
#import "Picture.h"

@interface DocumentDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,
                                                            UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *imagePickerController;
    IBOutlet UICollectionView *collectionView;
}

@property (strong, nonatomic) Document *document;

@property (strong, nonatomic) IBOutlet UITextField *docNameField;
@property (strong, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *editPhotosButton;
@property (strong, nonatomic) IBOutlet UIButton *deletePhotosButton;

- (IBAction)addPhoto:(UIButton *)sender;
- (IBAction)edit:(id)sender;
- (IBAction)delete:(id)sender;

- (IBAction)done:(UIBarButtonItem *)sender;
- (IBAction)cancel:(UIBarButtonItem *)sender;

@end
