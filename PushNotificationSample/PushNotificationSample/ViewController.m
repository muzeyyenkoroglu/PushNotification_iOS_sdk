/*******************************************************************************
 *
 *  Copyright (C) 2014 Turkcell
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *******************************************************************************/

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong,nonatomic) TCellNotificationManager* man;
@property (assign,nonatomic) DataTypeInTable dataTypeInTable;

@end

@implementation ViewController

@synthesize man = _man;
@synthesize spinner = _spinner;
@synthesize dataArray = _dataArray;
@synthesize dataTypeInTable = _dataTypeInTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //self.spinner.center = self.view.center;
    self.spinner.hidden = YES;
    [self.spinner startAnimating];
    self.man = [TCellNotificationManager sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Registration method
- (IBAction)registerDeviceButtonPressed:(UIButton *)sender {
    if ([self.man hasDeviceToken]){
        self.spinner.hidden = NO;
        [[TCellNotificationManager sharedInstance] registerDeviceWithCustomID:@"" genericParam:@"genericParamTest" completionHandler:^(id obj) {
            if ([obj isKindOfClass:[TCellRegistrationResult class]]){
                TCellRegistrationResult *result = (TCellRegistrationResult*)obj;
                self.spinner.hidden = YES;
                if (result.isSuccessfull){
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Device is registered to push server." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }else{
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[result.error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
            }
            
        }];
    }
}

#pragma mark - Unregistration method
- (IBAction)unRegisterDeviceButtonPressed:(UIButton *)sender {
    if ([self.man hasDeviceToken]){
        self.spinner.hidden = NO;
        [[TCellNotificationManager sharedInstance] unRegisterDeviceWithCompletionHandler:^(id obj) {
            if ([obj isKindOfClass:[TCellRegistrationResult class]]){
                TCellRegistrationResult *result = (TCellRegistrationResult*)obj;
                self.spinner.hidden = YES;
                if (result.isSuccessfull){
                    [[UIApplication sharedApplication] unregisterForRemoteNotifications];//removes application from notification center
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Device is unregistered from push server." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }else{
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[result.error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
            }
            
        }];
    }
}

#pragma mark - Get category list method
- (IBAction)getCategoryListButtonPressed:(UIButton *)sender {
    if ([self.man hasDeviceToken]){
        self.spinner.hidden = NO;
        [[TCellNotificationManager sharedInstance] getCategoryListWithCompletionHandler:^(id obj) {
            if ([obj isKindOfClass:[TCellCategoryListQueryResult class]]){
                TCellCategoryListQueryResult *result = (TCellCategoryListQueryResult*)obj;
                self.spinner.hidden = YES;
                if ([result.categories count] > 0){
                    self.dataArray = result.categories;
                    self.dataTypeInTable = DataTypeInTableCategoryList;
                    [self performSegueWithIdentifier:@"TableVC" sender:self];
                }else{
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[result.error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
            }
        }];
    }
}

#pragma mark - Get subscribed category list method
- (IBAction)getSubscribedCategoryPressed:(UIButton *)sender {
    if ([self.man hasDeviceToken]){
        self.spinner.hidden = NO;
        [[TCellNotificationManager sharedInstance] getCategorySubscriptionsWithCompletionHandler:^(id obj) {
            if ([obj isKindOfClass:[TCellCategoryListQueryResult class]]){
                TCellCategoryListQueryResult *result = (TCellCategoryListQueryResult*)obj;
                self.spinner.hidden = YES;
                if ([result.categories count] > 0){
                    self.dataArray = result.categories;
                    self.dataTypeInTable = DataTypeInTableSubscribedCategoryList;
                    [self performSegueWithIdentifier:@"TableVC" sender:self];
                }else{
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[result.error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
                
            }
        }];
    }
}

#pragma mark - Get notification history method
- (IBAction)getNotificationHistory:(UIButton *)sender {
    if ([self.man hasDeviceToken]){
        self.spinner.hidden = NO;
        [[TCellNotificationManager sharedInstance] getNotificationHistoryWithOffSet:1 listSize:5 completionHandler:^(id obj) {
            if ([obj isKindOfClass:[TCellNotificationHistoryResult class]]){
                TCellNotificationHistoryResult *result = (TCellNotificationHistoryResult*)obj;
                self.spinner.hidden = YES;
                if ([result.messages count] > 0){
                    self.dataArray = result.messages;
                    self.dataTypeInTable = DataTypeInTableNotificationHistoryList;
                    [self performSegueWithIdentifier:@"TableVC" sender:self];
                }else{
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[result.error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
            }
        }];
    }
}

#pragma mark - Segue methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TableViewController* mVC = segue.destinationViewController;
    mVC.dataArray = self.dataArray;
    mVC.dataTypeInTable = self.dataTypeInTable;
    [mVC.tableView reloadData];
}

@end
