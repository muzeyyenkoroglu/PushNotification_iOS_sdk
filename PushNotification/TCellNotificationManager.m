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

#import "TCellNotificationManager.h"
#import "TCellNotificationSettings.h"
#import "GlobalVariables.h"
#import "sha256.h"
#import "AFNetworking.h"
#import "TCellResult.h"
#import "Utilities.h"

@interface TCellNotificationManager ()

@property (assign, nonatomic) id<NotificationManagerDelegate> delegate;
@property (strong, nonatomic) NSString* deviceToken;

- (void)registrationResultInternal:(TCellApiResponse*)result;
- (void)unRegistrationResultInternal:(TCellApiResponse*)result;
- (void)categoryListQueryResultInternal:(TCellApiResponse*)result;
- (void)categoriesSubscribedToResultInternal:(TCellApiResponse*)result;
- (void)notificationHistoryResultInternal:(TCellApiResponse*)result;
- (void)subscribeToCategoryResultInternal:(TCellApiResponse*)result;
- (void)unSubscribeFromCategoryResultInternal:(TCellApiResponse*)result;

@end

@implementation TCellNotificationManager
@synthesize notificationSettings = _notificationSettings;
@synthesize delegate = _delegate;
@synthesize deviceToken = _deviceToken;

+ (TCellNotificationManager *)sharedInstance
{
    static TCellNotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TCellNotificationManager alloc] init];

#ifdef PROD
        NSLog(@"Push Notification SDK Prod v%@ build date %@", PROJECT_VERSION, [NSDate date]);
#else
        NSLog(@"Push Notification SDK Test v%@ build date %@", PROJECT_VERSION, [NSDate date]);
#endif
        

    });
    return sharedInstance;
}

- (void)registerApplicationForRemoteNotificationTypes
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(self.notificationSettings.notificationTypes)];
}

- (void)unRegisterApplicationForRemoteNotificationTypes
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (void)setNotificationDeviceTokenWithData:(NSData *)deviceToken
{
    NSString *devToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    devToken = [devToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceToken = devToken;
}

- (void)setNotificationDeviceTokenWithString:(NSString *)deviceToken
{
    self.deviceToken = deviceToken;
}

- (BOOL)hasDeviceToken
{
    if (self.deviceToken)
        return YES;
    
    return NO;
}

- (NSString*)encryptedStringAppIDTokenSecurityKey{
    // Prepare string for encryption -- String is in format: {appID} + {token} + {key}
    NSString* stringForEncryption = [[NSString alloc] initWithFormat:@"%@%@%@", self.notificationSettings.appId, self.deviceToken, self.notificationSettings.secretKey];
    // Call sha256 function
    sha256* hash = [[sha256 alloc] init];
    return [hash getEncryptedString:stringForEncryption];
}

- (NSString*)encryptedStringAppIDSecurityKey{
    // Prepare string for encryption -- String is in format: {appID} + {key}
    NSString* stringForEncryption = [[NSString alloc] initWithFormat:@"%@%@", self.notificationSettings.appId, self.notificationSettings.secretKey];
    // Call sha256 function
    sha256* hash = [[sha256 alloc] init];
    return [hash getEncryptedString:stringForEncryption];
}

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)makeRequestWithBaseURL:(NSString*)baseURL path:(NSString*)path delegate:(id<NotificationManagerDelegate>)delegate selector:(SEL)selector
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:path
                                                      parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    DLog(@"operation description: %@", [operation description]);
    
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        TCellApiResponse *result = [[TCellApiResponse alloc] initWithResponseObject:responseObject error:nil];
        [self performSelector:selector withObject:result withObject:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
        TCellApiResponse *result = [[TCellApiResponse alloc] initWithResponseObject:nil error:error];
        [self performSelector:selector withObject:result withObject:nil];
    }];
    [operation start];
}

- (void)registerDeviceWithDelegate:(id<NotificationManagerDelegate>)delegate customID:(NSString *)customID genericParam:(NSString *)genericParam
{
    self.delegate = delegate;
    NSString* path = [NSString stringWithFormat:@"%@%@/%@",REGISTRATION_PATH,self.notificationSettings.appId,self.deviceToken];
    
    
    NSString* deviceModelName = [[Utilities deviceModelName] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString* deviceOsVersion = [[[UIDevice currentDevice] systemVersion] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    path = [path stringByAppendingString:[NSString stringWithFormat:@"?%@=%@",PARAMETER_DEVICE_MODEL,deviceModelName]];
    path = [path stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",PARAMETER_OS_VERSION,deviceOsVersion]];;
    
    if (customID && [customID length] >0)
        path = [path stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",PARAMETER_CUSTOM_ID,customID]];
    
    if (genericParam && [genericParam length] >0)
        path = [path stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",PARAMETER_GENERIC_PARAM,genericParam]];
    
    [self makeRequestWithBaseURL:PUSH_SERVER_URL path:path delegate:self.delegate selector:@selector(registrationResultInternal:)];
}

- (void)registrationResultInternal:(TCellApiResponse*)result
{
    TCellRegistrationResult* _result= [[TCellRegistrationResult alloc] initRegistrationResultWithResponse:result.responseObject error:result.error];
    [self.delegate registrationResult:_result];
}

- (void)unRegisterDeviceWithDelegate:(id<NotificationManagerDelegate>)delegate
{
    self.delegate = delegate;
    NSString* path = [NSString stringWithFormat:@"%@%@/%@",UNREGISTRATION_PATH,self.notificationSettings.appId,self.deviceToken];
    [self makeRequestWithBaseURL:PUSH_SERVER_URL path:path delegate:self.delegate selector:@selector(unRegistrationResultInternal:)];
}

- (void)unRegistrationResultInternal:(TCellApiResponse*)result
{
    TCellRegistrationResult* _result= [[TCellRegistrationResult alloc] initRegistrationResultWithResponse:result.responseObject error:result.error];
    [self.delegate unRegistrationResult:_result];
}

- (void)getCategoryListWithDelegate:(id<NotificationManagerDelegate>)delegate
{
    self.delegate = delegate;
    NSString* path = [NSString stringWithFormat:@"%@%@.%@",CATEGORY_LIST_PATH,self.notificationSettings.appId,[self encryptedStringAppIDSecurityKey]];
    [self makeRequestWithBaseURL:PUSH_SERVER_URL path:path delegate:self.delegate selector:@selector(categoryListQueryResultInternal:)];
}

- (void)categoryListQueryResultInternal:(TCellApiResponse*)result
{
    TCellCategoryListQueryResult* _result= [[TCellCategoryListQueryResult alloc] initCategoryListQueryResultWithResponse:result.responseObject error:result.error];
    [self.delegate categoryListQueryResult:_result];
}

- (void)getCategorySubscriptionsWithDelegate:(id<NotificationManagerDelegate>)delegate
{
    self.delegate = delegate;
    NSString* path = [NSString stringWithFormat:@"%@%@.%@?token=%@",ALLOWED_CATEGORIES_PATH,self.notificationSettings.appId,[self encryptedStringAppIDSecurityKey],self.deviceToken];
    [self makeRequestWithBaseURL:PUSH_SERVER_URL path:path delegate:self.delegate selector:@selector(categoriesSubscribedToResultInternal:)];
}

- (void)categoriesSubscribedToResultInternal:(TCellApiResponse*)result
{
    TCellCategoryListQueryResult* _result= [[TCellCategoryListQueryResult alloc] initCategoryListQueryResultWithResponse:result.responseObject error:result.error];
    [self.delegate categoriesSubscribedToResult:_result];
}

- (void)getNotificationHistoryWithDelegate:(id<NotificationManagerDelegate>)delegate offSet:(int)offSet listSize:(int)listSize
{
    self.delegate = delegate;
    NSString* path = [NSString stringWithFormat:@"%@%@.%@/%i.%i",MESSAGE_HISTORY_PATH,self.notificationSettings.appId,[self encryptedStringAppIDSecurityKey],offSet,listSize];
    [self makeRequestWithBaseURL:PUSH_SERVER_URL path:path delegate:self.delegate selector:@selector(notificationHistoryResultInternal:)];
}

- (void)notificationHistoryResultInternal:(TCellApiResponse*)result
{
    TCellNotificationHistoryResult* _result= [[TCellNotificationHistoryResult alloc] initNotificationHistoryResultWithResponse:result.responseObject error:result.error];
    [self.delegate notificationHistoryResult:_result];
}

- (void)subscribeToCategoryWithDelegate:(id<NotificationManagerDelegate>)delegate categoryName:(NSString*)categoryName
{
    self.delegate = delegate;
    NSString* path = [NSString stringWithFormat:@"%@%@.%@?token=%@&categoryName=%@",SET_CATEGORY_PATH,self.notificationSettings.appId,[self encryptedStringAppIDSecurityKey],self.deviceToken,categoryName];
    [self makeRequestWithBaseURL:PUSH_SERVER_URL path:path delegate:self.delegate selector:@selector(subscribeToCategoryResultInternal:)];
}

- (void)subscribeToCategoryResultInternal:(TCellApiResponse*)result
{
    TCellCategorySubscriptionResult* _result= [[TCellCategorySubscriptionResult alloc] initCategorySubscriptionsResultWithResponse:result.responseObject error:result.error];
    [self.delegate subscribeToCategoryResult:_result];
}

- (void)unSubscribeFromCategoryWithDelegate:(id<NotificationManagerDelegate>)delegate categoryName:(NSString*)categoryName
{
    self.delegate = delegate;
    NSString* path = [NSString stringWithFormat:@"%@%@.%@?token=%@&categoryName=%@",UNSET_CATEGORY_PATH,self.notificationSettings.appId,[self encryptedStringAppIDSecurityKey],self.deviceToken,categoryName];
    [self makeRequestWithBaseURL:PUSH_SERVER_URL path:path delegate:self.delegate selector:@selector(unSubscribeFromCategoryResultInternal:)];
}

- (void)unSubscribeFromCategoryResultInternal:(TCellApiResponse*)result
{
    TCellCategorySubscriptionResult* _result= [[TCellCategorySubscriptionResult alloc] initCategorySubscriptionsResultWithResponse:result.responseObject error:result.error];
    [self.delegate unSubscribeFromCategoryResult:_result];
}

@end
