//
//  LoginViewController.m
//  ToDoList
//
//  Created by 5931 on 25/9/18.
//  Copyright © 2018 Khiet Ly. All rights reserved.
//

#import "LoginViewController.h"
@import Firebase;
@interface LoginViewController (){

    __weak IBOutlet UITextField *emailField;
    
    __weak IBOutlet UITextField *passwordField;
}

@property (weak,nonatomic) IBOutlet UILabel *notificationLabel;
@end

@implementation LoginViewController
//validation
-(BOOL)validation{
    NSString *strEmailID = [emailField.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *strPassword = [passwordField.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
    if (strEmailID.length <= 0){
        [self.notificationLabel setText: @"Please enter email address"];
        return NO;
    }
    else if (strPassword.length <= 0){
        [self.notificationLabel setText: @"Please enter password"];
        return NO;
    }
    else if ([self validateEmailAddress:strEmailID] == NO){
        [self.notificationLabel setText: @"Please enter valid email address"];
        return NO;
    }
    return YES;
}

//validating the email address
-(BOOL)validateEmailAddress:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

//checking if user exist in firebase

- (IBAction)SignIn:(id)sender {
    if ([self validation]) {
        [[FIRAuth auth] signInWithEmail:emailField.text
                               password:passwordField.text
                             completion:^(FIRUser * _Nullable authResult,
                                          NSError * _Nullable error) {
                                 //failed
                                 if (error){
                                     [self.notificationLabel setText:error.localizedDescription];
                                     NSLog(@"Error %@", error.localizedDescription);
                                     
                                     
                                 } else {
                                     NSLog(@"User %@", authResult.uid);
                                     
                                     //login successfully change page
                                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                     UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeViewController"];
                                     [self presentViewController:vc animated:YES completion:nil];
                                 }
                             }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
