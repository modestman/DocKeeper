//
//  CollectionViewCell.m
//  DocKeeper
//
//  Created by Admin on 05.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setSelectable:(BOOL)selectable
{
    _selectable = selectable;
    self.checkedImageView.hidden = !_selectable;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        self.checkedImageView.image = [[UIImage imageNamed:@"check_circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else
    {
        self.checkedImageView.image = [[UIImage imageNamed:@"empty_circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}

@end
