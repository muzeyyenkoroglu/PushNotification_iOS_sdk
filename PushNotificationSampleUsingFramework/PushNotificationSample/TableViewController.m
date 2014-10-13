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

#import "TableViewController.h"

#define SUBSCRIBED_ALERT_TAG 1
#define UNSUBSCRIBED_ALERT_TAG 2

@interface TableViewController () <UIAlertViewDelegate>

@property(strong,nonatomic) TCellNotificationManager* man;
@property(strong,nonatomic) NSString* selectedItemTitle;
@property(assign,nonatomic) int selectedItemIndex;

@end

@implementation TableViewController

@synthesize dataArray = _dataArray;
@synthesize man = _man;
@synthesize dataTypeInTable = _dataTypeInTable;
@synthesize selectedItemTitle = _selectedItemTitle;
@synthesize selectedItemIndex = _selectedItemIndex;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *dataString = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = dataString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedItemTitle = cell.textLabel.text;
    self.selectedItemIndex = indexPath.row;
    
    if (self.dataTypeInTable == DataTypeInTableCategoryList){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Subscription" message:[NSString stringWithFormat:@"Do you want to subscribe to %@ category?", self.selectedItemTitle] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else if (self.dataTypeInTable == DataTypeInTableSubscribedCategoryList){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unsubscription" message:[NSString stringWithFormat:@"Do you want to unsubscribe from %@ category?", self.selectedItemTitle] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex){
        if (alertView.tag == UNSUBSCRIBED_ALERT_TAG || alertView.tag == SUBSCRIBED_ALERT_TAG)
            return;
        else if (self.dataTypeInTable == DataTypeInTableCategoryList)
            [[TCellNotificationManager sharedInstance] subscribeToCategoryWithCategoryName:self.selectedItemTitle completionHandler:^(id obj) {
                if ([obj isKindOfClass:[TCellCategorySubscriptionResult class]]){
                    TCellCategorySubscriptionResult *result = (TCellCategorySubscriptionResult*)obj;
                    if (result.isSuccessfull){
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Subscription" message:[NSString stringWithFormat:@"You are subscribed to %@ category successfully.", self.selectedItemTitle] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        alert.tag = SUBSCRIBED_ALERT_TAG;
                        [alert show];
                    }else{
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Subscription" message:[result.error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        alert.tag = SUBSCRIBED_ALERT_TAG;
                        [alert show];
                    }
                }
            }];
        else if (self.dataTypeInTable == DataTypeInTableSubscribedCategoryList)
            [[TCellNotificationManager sharedInstance] unSubscribeFromCategoryWithCategoryName:self.selectedItemTitle completionHandler:^(id obj) {
                if ([obj isKindOfClass:[TCellCategorySubscriptionResult class]]){
                    TCellCategorySubscriptionResult *result = (TCellCategorySubscriptionResult*)obj;
                    if (result.isSuccessfull){
                        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataArray];
                        [array removeObjectAtIndex:self.selectedItemIndex];
                        self.dataArray = array;
                        [self.tableView reloadData];
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Subscription" message:[NSString stringWithFormat:@"You are unsubscribed from %@ category successfully.", self.selectedItemTitle] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        alert.tag = UNSUBSCRIBED_ALERT_TAG;
                        [alert show];
                    }else{
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Subscription" message:[result.error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        alert.tag = UNSUBSCRIBED_ALERT_TAG;
                        [alert show];
                    }
                }
            }];
    }
    
}

@end

