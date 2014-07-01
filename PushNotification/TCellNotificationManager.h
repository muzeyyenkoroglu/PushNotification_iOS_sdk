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
 * \param customID holds any string to send to push server for an alternative identification of the client
 * \param genericParam holds any string to send to push server for any other parameter such as resolution etc.
 * \param completionBlock A block object to be executed when the responce is received from server. obj is the response object from server.
 */
- (void)registerDeviceWithCustomID:(NSString *)customID  genericParam:(NSString *)genericParam completionHandler:(void(^)(id obj))completionBlock;

/*!
 * Unregisters device from push notification center.
 * \param completionBlock A block object to be executed when the responce is received from server. obj is the response object from server.
 */
- (void)unRegisterDeviceWithCompletionHandler:(void(^)(id obj))completionBlock;
/*!
 * Gets the category list of the notification categories which you can subscribe to.
 * \param completionBlock A block object to be executed when the responce is received from server. obj is the response object from server.
 */
- (void)getCategoryListWithCompletionHandler:(void(^)(id obj))completionBlock;

/*!
 * Gets the category list of the notification categories which the application is subscribe to.
 * \param completionBlock A block object to be executed when the responce is received from server. obj is the response object from server.
 */
- (void)getCategorySubscriptionsWithCompletionHandler:(void(^)(id obj))completionBlock;

/*!
 * Gets a list of a push notification history.
 *
 * \param offSet Value of the start row of the list.
 * \param listSize Value of the row count to be listed.
 * \param completionBlock A block object to be executed when the responce is received from server. obj is the response object from server.
 */
- (void)getNotificationHistoryWithOffSet:(int)offSet listSize:(int)listSize completionHandler:(void(^)(id obj))completionBlock;

/*!
 * Subscribes to a pushnotification category.
 *
 * \param categoryName Name of the caretogry which intends to be unsubsscribed.
 * \param completionBlock A block object to be executed when the responce is received from server. obj is the response object from server.
 */
- (void)subscribeToCategoryWithCategoryName:(NSString*)categoryName completionHandler:(void(^)(id obj))completionBlock;

/*!
 * Unsubscribes from a push notification category.
 *
 * \param categoryName Name of the caretogry which intends to be unsubsscribed.
 * \param completionBlock A block object to be executed when the responce is received from server. obj is the response object from server.
 */
- (void)unSubscribeFromCategoryWithCategoryName:(NSString*)categoryName completionHandler:(void(^)(id obj))completionBlock;

@end
