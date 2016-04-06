//
//  AuthViewController.h
//  DocKeeper
//
//  Created by Admin on 04.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthViewController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *okButtonVerticalConstraint;

- (IBAction)checkPassword:(UIButton *)sender;

@end
