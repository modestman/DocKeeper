//
//  ZoomedPhotoViewController.h
//  DocKeeper
//
//  Created by Admin on 05.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomedPhotoViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIImageView *imageView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet NSLayoutConstraint *imageViewBottomConstraint;
    IBOutlet NSLayoutConstraint *imageViewLeadingConstraint;
    IBOutlet NSLayoutConstraint *imageViewTopConstraint;
    IBOutlet NSLayoutConstraint *imageViewTrailingConstraint;
}

@property (nonatomic, strong) UIImage *image;

@end
