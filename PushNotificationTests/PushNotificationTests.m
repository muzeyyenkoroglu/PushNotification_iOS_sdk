//
//  PushNotificationTests.m
//  PushNotificationTests
//
//  Created by Abdulbasıt Tanhan on 2.07.2014.
//  Copyright (c) 2014 Abdulbasıt Tanhan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GlobalVariables.h"
#import "TCellNotificationManager.h"
#import "TCellResult.h"
#import "TCellNotificationSettings.h"

#define APPID @"dc390172b28183c2eb069f5131129287"
#define SECRETKEY @"215aaa1ffc19f4e89c8d398085e727d1"
#define TOKEN @"cd6d3180cbe4d75c84af61b45a1d1ce34cec72ee9fde8658f26f0e598e64b225"

@interface PushNotificationTests : XCTestCase{

NSString* appId;
NSString* deviceToken;
NSString* secretKey;

//BOOL resultRetrieved;
BOOL registerResultRetrieved;
BOOL unRegisterResultRetrieved;
BOOL categoryListResultRetrieved;
BOOL subscribedCategoryListRetrieved;
BOOL notificationHistoryResultRetrieved;
BOOL subscribeToCategoryResultRetrieved;
BOOL unSubscribeFromCategoryResultRetrieved;
TCellNotificationSettings* notificationSettings;
TCellNotificationManager* manager;
NSDictionary* registerResultDictionary;
}

@end

@implementation PushNotificationTests

- (void)setUp
{
    [super setUp];
    // reset values
    appId = APPID;
    secretKey = SECRETKEY;
    deviceToken = TOKEN;
    manager = [TCellNotificationManager sharedInstance];
    notificationSettings = [[TCellNotificationSettings alloc] initWithAppId:appId
                                                                  secretKey:secretKey
                                                          notificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    manager.notificationSettings = notificationSettings;
    [manager setNotificationDeviceTokenWithString:deviceToken];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - testRegisterDeviceToPushServer
- (void)test1_RegisterDeviceToPushServer
{
    __block BOOL resultRetrieved = NO;
    
    [[TCellNotificationManager sharedInstance] registerDeviceWithCustomID:@"" genericParam:@"genericParamTest" completionHandler:^(id obj) {
        if ([obj isKindOfClass:[TCellRegistrationResult class]]){
            TCellRegistrationResult *result = (TCellRegistrationResult*)obj;
            XCTAssertTrue([result isSuccessfull],"Device registration");
            resultRetrieved = YES;
        }            
    }];
    
    while (!resultRetrieved && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]);
}

#pragma mark - testGetCategoryListFromPushServer
- (void)test2_GetCategoryListFromPushServer
{
    __block BOOL resultRetrieved = NO;
    
    [[TCellNotificationManager sharedInstance] getCategoryListWithCompletionHandler:^(id obj) {
        if ([obj isKindOfClass:[TCellCategoryListQueryResult class]]){
            TCellCategoryListQueryResult *result = (TCellCategoryListQueryResult*)obj;
            //XCTAssertTrue([result isSuccessfull] && [result.categories count] > 0,"Get category list");
            XCTAssertTrue([result isSuccessfull],"Get category list");
            resultRetrieved = YES;
        }
    }];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (!resultRetrieved && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]);
}

#pragma mark - testSubscribeToCategoryInPushServer
- (void)test3_SubscribeToCategoryInPushServer
{
    __block BOOL resultRetrieved = NO;
    
    [[TCellNotificationManager sharedInstance] subscribeToCategoryWithCategoryName:@"spor" completionHandler:^(id obj) {
        if ([obj isKindOfClass:[TCellCategorySubscriptionResult class]]){
            TCellCategorySubscriptionResult *result = (TCellCategorySubscriptionResult*)obj;
            XCTAssertTrue([result isSuccessfull],"Subscribed to category");
            resultRetrieved = YES;
        }
    }];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (!resultRetrieved && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]);
}

#pragma mark - testGetSubscribedCategoriesFromPushServer
- (void)test4_GetSubscribedCategoriesFromPushServer
{
    __block BOOL resultRetrieved = NO;
    
    [[TCellNotificationManager sharedInstance] getCategorySubscriptionsWithCompletionHandler:^(id obj) {
        if ([obj isKindOfClass:[TCellCategoryListQueryResult class]]){
            TCellCategoryListQueryResult *result = (TCellCategoryListQueryResult*)obj;
            //XCTAssertTrue([result isSuccessfull] && [result.categories count] > 0,"Get subscribed category list.");
            XCTAssertTrue([result isSuccessfull],"Get subscribed category list.");
            resultRetrieved = YES;
        }
    }];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (!resultRetrieved && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]);
}

#pragma mark - testUnSubscribeFromCategoryInPushServer
- (void)test5_UnSubscribeFromCategoryInPushServer
{
    __block BOOL resultRetrieved = NO;
    
    [[TCellNotificationManager sharedInstance] unSubscribeFromCategoryWithCategoryName:@"spor" completionHandler:^(id obj) {
        if ([obj isKindOfClass:[TCellCategorySubscriptionResult class]]){
            TCellCategorySubscriptionResult *result = (TCellCategorySubscriptionResult*)obj;
            XCTAssertTrue([result isSuccessfull],"Unsubscribed from category.");
            resultRetrieved = YES;
        }
    }];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (!resultRetrieved && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]);
}

#pragma mark - testgetGetNotificationHistoryFromPushServer
- (void)test6_getGetNotificationHistoryFromPushServer
{
    __block BOOL resultRetrieved = NO;

    [[TCellNotificationManager sharedInstance] getNotificationHistoryWithOffSet:1 listSize:5 completionHandler:^(id obj) {
        if ([obj isKindOfClass:[TCellNotificationHistoryResult class]]){
            TCellNotificationHistoryResult *result = (TCellNotificationHistoryResult*)obj;
            //XCTAssertTrue([result isSuccessfull] && [result.messages count] > 0,"Get notification history.");
            XCTAssertTrue([result isSuccessfull],"Get notification history.");
            resultRetrieved = YES;
        }
    }];
 
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (!resultRetrieved && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]);
}

#pragma mark - testUnRegisterDeviceToPushServer
- (void)test7_UnRegisterDeviceToPushServer
{
    __block BOOL resultRetrieved = NO;
    
    [[TCellNotificationManager sharedInstance] unRegisterDeviceWithCompletionHandler:^(id obj) {
        if ([obj isKindOfClass:[TCellRegistrationResult class]]){
            TCellRegistrationResult *result = (TCellRegistrationResult*)obj;
            XCTAssertTrue([result isSuccessfull],"Device unregistration");
            resultRetrieved = YES;
        }
        
    }];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (!resultRetrieved && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]);
}

@end
