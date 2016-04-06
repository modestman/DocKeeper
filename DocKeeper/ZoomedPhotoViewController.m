//
//  ZoomedPhotoViewController.m
//  DocKeeper
//
//  Created by Admin on 05.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//

#import "ZoomedPhotoViewController.h"

@interface ZoomedPhotoViewController ()

@end

@implementation ZoomedPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageView.image = self.image;
    imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateMinZoomScaleForSize:self.view.bounds.size];
}

-(void)updateMinZoomScaleForSize:(CGSize)size
{
    CGFloat widthScale = size.width / imageView.bounds.size.width;
    CGFloat heightScale = size.height / imageView.bounds.size.height;
    CGFloat minScale = MIN(widthScale, heightScale);
    scrollView.minimumZoomScale = minScale;
    scrollView.zoomScale = minScale;
}

-(void)updateConstraintsForSize:(CGSize)size
{
    CGFloat yOffset = MAX(0, (size.height - imageView.frame.size.height) / 2);
    imageViewTopConstraint.constant = yOffset;
    imageViewBottomConstraint.constant = yOffset;
   
    CGFloat xOffset = MAX(0, (size.width - imageView.frame.size.width) / 2);
    imageViewLeadingConstraint.constant = xOffset;
    imageViewTrailingConstraint.constant = xOffset;
    
    [self.view layoutIfNeeded];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self updateConstraintsForSize:self.view.bounds.size];
}

@end
