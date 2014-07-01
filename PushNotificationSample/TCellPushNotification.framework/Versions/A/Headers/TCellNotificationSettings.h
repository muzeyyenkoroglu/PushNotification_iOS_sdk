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
#import <UIKit/UIApplication.h>


/*!
 * Stores the notification settings.
 */
@interface TCellNotificationSettings : NSObject


/*!
 * Application ID which is provided by push notification center.
 */
@property(strong, nonatomic) NSString* appId;

/*!
 * Secret key which is provided by push notification center.
 */
@property(strong, nonatomic) NSString* secretKey;

/*!
 * The notification types which the appication wants to be notified by. 
 * Can be UIRemoteNotificationTypeNone, UIRemoteNotificationTypeBadge,UIRemoteNotificationTypeSound, UIRemoteNotificationTypeAlert, UIRemoteNotificationTypeNewsstandContentAvailability.
 */
@property(assign, nonatomic) UIRemoteNotificationType notificationTypes;

/*!
 * Creates an TCellNotificationSettings object initialized with the notification settings.
 * \param appId Application ID which is provided by push notification center.
 * \param secretKey Secret key which is provided by push notification center.
 * \param notificationTypes The notification types which the appication wants to be notified by. Can be UIRemoteNotificationTypeNone, UIRemoteNotificationTypeBadge,UIRemoteNotificationTypeSound, UIRemoteNotificationTypeAlert, UIRemoteNotificationTypeNewsstandContentAvailability.
 */
- (TCellNotificationSettings*)initWithAppId:(NSString*)appId secretKey:(NSString*)secretKey notificationTypes:(UIRemoteNotificationType)notificationTypes;
@end
