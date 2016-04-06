//
//  AuthViewController.m
//  DocKeeper
//
//  Created by Admin on 04.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//

#import "AuthViewController.h"
#import "AppDelegate.h"
#import <SSKeychain/SSKeychain.h>

typedef enum : NSUInteger {
    EnterToApp,
    CreatePassword,
} NextActionType;

@interface AuthViewController ()
{
    NextActionType nextAction;
}
@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.passwordField.text = @"";
    self.confirmPasswordField.text = @"";
    
    NSError *error = nil;
    [SSKeychain passwordForService:keychainService account:keychainAccount error:&error];
    if (!error)
    {
        self.infoLabel.text = NSLocalizedString(@"Enter your password", nil);
        [self.okButton setTitle:NSLocalizedString(@"Enter", nil) forState:UIControlStateNormal];
        //[self.confirmPasswordField removeFromSuperview];
        self.confirmPasswordField.hidden = YES;
        self.okButtonVerticalConstraint.constant = -40;
        nextAction = EnterToApp;
    }
    else if (error && error.code == errSecItemNotFound)
    {
        self.infoLabel.text = NSLocalizedString(@"Create new password", nil);
        [self.okButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
        self.confirmPasswordField.hidden = NO;
        self.okButtonVerticalConstraint.constant = 16;
        nextAction = CreatePassword;
    }
    else
    {
        NSAssert(!error, @"Unable to retrieve keychain value for password error %@", error);
    }
}

- (IBAction)checkPassword:(UIButton *)sender
{
    BOOL success = YES;
    NSError *error = nil;
    
    if ([self.passwordField.text length] == 0)
    {
        success = NO;
        self.errorLabel.text = NSLocalizedString(@"Need to write a password", nil);
    }
    
    if (success && nextAction == EnterToApp)
    {
        // check saved password
        NSString *savedPassword = [SSKeychain passwordForService:keychainService account:keychainAccount error:&error];
        if (![self.passwordField.text isEqualToString:savedPassword])
        {
            success = NO;
            self.errorLabel.text = NSLocalizedString(@"Password is incorrect", nil);
        }
    }
    else if (success)
    {
        // check and create new password
        if ([self.passwordField.text isEqualToString:self.confirmPasswordField.text])
        {
            success = [SSKeychain setPassword:self.passwordField.text forService:keychainService account:keychainAccount error:&error];
        }
        else
        {
            success = NO;
            self.errorLabel.text = NSLocalizedString(@"Confirm password is incorrect", nil);
        }
    }
    
    self.errorLabel.hidden = success;
    
    if (success)
    {
        [self performSegueWithIdentifier:@"EnterToAppSegue" sender:nil];
    }
}
@end
