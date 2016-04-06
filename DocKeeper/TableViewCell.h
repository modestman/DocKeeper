//
//  TableViewCell.h
//  DocKeeper
//
//  Created by Admin on 05.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;


@end
