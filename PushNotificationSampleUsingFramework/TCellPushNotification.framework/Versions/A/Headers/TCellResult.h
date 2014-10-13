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
#import "TCellApiResponse.h"

/*!
 * Keeps the registration result
 */
@interface TCellRegistrationResult : TCellApiResponse

/*!
 * Creates a TCellRegistrationResult object initialized with response parameters.
 \param response Response from json request
 \param error Error object from failed response
 */
- (TCellRegistrationResult*)initRegistrationResultWithResponse:(id)response error:(NSError*)error;

@end

/*!
 * Keeps the category list results.
 */
@interface TCellCategoryListQueryResult : TCellApiResponse

/*!
 * Categories from category list result.
 */
@property (strong, nonatomic) NSArray* categories;

/*!
 * Creates a TCellCategoryListQueryResult object initialized with response parameters.
 \param response Response from json request
 \param error Error object from failed response
 */
- (TCellCategoryListQueryResult*)initCategoryListQueryResultWithResponse:(id)response error:(NSError*)error;

@end

/*!
 * Keeps the subscription results.
 */
@interface TCellCategorySubscriptionResult : TCellApiResponse

/*!
 * Creates a TCellCategorySubscriptionResult object initialized with response parameters.
 \param response Response from json request
 \param error Error object from failed response
 */
- (TCellCategorySubscriptionResult*)initCategorySubscriptionsResultWithResponse:(id)response error:(NSError*)error;

@end

/*!
 * Keeps the notification history list.
 */
@interface TCellNotificationHistoryResult : TCellApiResponse


/*!
 * Messages from notification history list.
 */
@property (strong, nonatomic) NSArray* messages;

/*!
 * Creates a TCellNotificationHistoryResult object initialized with response parameters.
 \param response Response from json request
 \param error Error object from failed response
 */
- (TCellNotificationHistoryResult*)initNotificationHistoryResultWithResponse:(id)response error:(NSError*)error;

@end
