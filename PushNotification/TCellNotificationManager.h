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

#import <Foundation/Foundation.h>
#import "TCellResult.h"
#import "TCellNotificationSettings.h"

/*!
 * Methods that the TCellNotificationManager delegate would call back.
 */
@protocol NotificationManagerDelegate <NSObject>
@optional
/*!
 * registrationResult
 *
 * To be called back when registerDeviceWithDelegate:(id<NotificationManagerDelegate>)delegate customID:(NSString *)customID receives a response.
 * \param result Inherits TCellApiResponse. Is set after registerDeviceWithDelegate receives a response.
 */
- (void)registrationResult:(TCellRegistrationResult*)result;

/*!
 * unRegistrationResult
 *
 * To be called back when unRegisterDeviceWithDelegate:(id<NotificationManagerDelegate>)delegate receives a response.
 * \param result Inherits TCellApiResponse. Is set after unRegisterDeviceWithDelegate receives a response.
 */
- (void)unRegistrationResult:(TCellRegistrationResult*)result;

/*!
 * registrationResult
 *
 * To be called back when getCategoryListWithDelegate:(id<NotificationManagerDelegate>)delegate receives a response.
 * \param result Inherits TCellApiResponse. Is set after getCategoryListWithDelegate receives a response.
 */
- (void)categoryListQueryResult:(TCellCategoryListQueryResult*)result;

/*!
 * registrationResult
 *
 * To be called back when getCategorySubscriptionsWithDelegate:(id<NotificationManagerDelegate>)delegate receives a response.
 * \param result Inherits TCellApiResponse. Is set after getCategorySubscriptionsWithDelegate receives a response.
 */
- (void)categoriesSubscribedToResult:(TCellCategoryListQueryResult*)result;

/*!
 * notificationHistoryResult
 *
 * To be called back when getNotificationHistoryWithDelegate:(id<NotificationManagerDelegate>)delegate offSet:(int)offSet listSize:(int)listSize; receives a response.
 * \param result Inherits TCellApiResponse. Is set after getNotificationHistoryWithDelegate receives a response.
 */
- (void)notificationHistoryResult:(TCellNotificationHistoryResult*)result;

/*!
 * subscribeToCategoryResult
 *
 * To be called back when subscribeToCategoryWithDelegate:(id<NotificationManagerDelegate>)delegate categoryName:(NSString*)categoryName receives a response.
 * \param result Inherits TCellApiResponse. Is set after registerDeviceWithDelegate receives a response.
 */
- (void)subscribeToCategoryResult:(TCellCategorySubscriptionResult*)result;

/*!
 * unSubscribeFromCategoryResult
 *
 * To be called back when unSubscribeFromCategoryWithDelegate:(id<NotificationManagerDelegate>)delegate categoryName:(NSString*)categoryName receives a response.
 * \param result Inherits TCellApiResponse. Is set after unSubscribeFromCategoryWithDelegate receives a response.
 */
- (void)unSubscribeFromCategoryResult:(TCellCategorySubscriptionResult*)result;
@end



/*!
 * Is a singleton class that has the main functionalities of push notificaton framework. 
 * Provides application to register for remote notifications and communication with server.
 */
@interface TCellNotificationManager : NSObject


/*!
 * Keeps the notification settings such as app id, secret key and notification types
 */
@property (strong, nonatomic) TCellNotificationSettings* notificationSettings;

/*!
 * Returns the shared TCellNotificationManager instance.
 *
 * \returns The shared instance
 */
+ (TCellNotificationManager *)sharedInstance;

/*!
 * Stores the devicetoken. Gets rid of characters such as >, < and spaces.
 *
 * \param deviceToken Value of the token in type of NSData.
 */
- (void)setNotificationDeviceTokenWithData:(NSData *)deviceToken;

/*!
 * Stores the devicetoken
 *
 * \param deviceToken Value of the token in type of NSString.
 */
- (void)setNotificationDeviceTokenWithString:(NSString *)deviceToken;


/*!
 * Checks if the device token is set.
 *
 * \returns Returns yes if the device token is set.
 */

- (BOOL)hasDeviceToken;

/*!
 * Registers device for remote notification types which is set in notificationSettings variable.
 * Does the same thing as in UIApplication class registerForRemoteNotificationTypes: method.
 */
- (void)registerApplicationForRemoteNotificationTypes;

/*!
 * Unregisters device for all remote notification types.
 * Does the same thing as in UIApplication class registerForRemoteNotificationTypes:UIRemoteNotificationTypeNone method.
 */
- (void)unRegisterApplicationForRemoteNotificationTypes;

/*!
 * Registers device to push notification center.
 *
 * \param delegate Class that implements NotificationManagerDelegate protocol.
 * \param customID holds any string to send to push server. 
 */
- (void)registerDeviceWithDelegate:(id<NotificationManagerDelegate>)delegate customID:(NSString *)customID;

/*!
 * Unregisters device from push notification center.
 *
 * \param delegate Class that implements NotificationManagerDelegate protocol.
 */
- (void)unRegisterDeviceWithDelegate:(id<NotificationManagerDelegate>)delegate;

/*!
 * Gets the category list of the notification categories which you can subscribe to.
 *
 * \param delegate Class that implements NotificationManagerDelegate protocol.
 */
- (void)getCategoryListWithDelegate:(id<NotificationManagerDelegate>)delegate;

/*!
 * Gets the category list of the notification categories which the application is subscribe to.
 *
 * \param delegate Class that implements NotificationManagerDelegate protocol.
 */
- (void)getCategorySubscriptionsWithDelegate:(id<NotificationManagerDelegate>)delegate;

/*!
 * Gets a list of a push notification history.
 *
 * \param delegate Class that implements NotificationManagerDelegate protocol.
 * \param offSet Value of the start row of the list.
 * \param listSize Value of the row count to be listed.
 */
- (void)getNotificationHistoryWithDelegate:(id<NotificationManagerDelegate>)delegate offSet:(int)offSet listSize:(int)listSize;

/*!
 * Subscribes to a pushnotification category.
 *
 * \param delegate Class that implements NotificationManagerDelegate protocol.
 * \param categoryName Name of the caretogry which intends to be unsubsscribed.
 */
- (void)subscribeToCategoryWithDelegate:(id<NotificationManagerDelegate>)delegate categoryName:(NSString*)categoryName;

/*!
 * Unsubscribes from a push notification category.
 *
 * \param delegate Class that implements NotificationManagerDelegate protocol.
 * \param categoryName Name of the caretogry which intends to be unsubsscribed.
 */
- (void)unSubscribeFromCategoryWithDelegate:(id<NotificationManagerDelegate>)delegate categoryName:(NSString*)categoryName;

@end
