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

/*!
 * Keeps the response from push notification center
 */
@interface TCellApiResponse : NSObject

/*!
 * Set to YES if the response is successfull. Set to NO if the response contains failure.
 */
@property(assign,nonatomic) BOOL isSuccessfull;

/*!
 * Response from json request
 */
@property(strong, nonatomic) id responseObject;

/*!
 * Error object from failed response
 */
@property(strong, nonatomic) NSError* error;

/*!
 * resultCode code of httpResponse
 */
@property(strong, nonatomic) NSString* resultCode;

/*!
 * Creates a TCellApiResponse object initialized with response parameters.
 \param responseObject Response from request
 \param error Error object from failed response
 */
- (TCellApiResponse*)initWithResponseObject:(id)responseObject
                                    error:(NSError*)error;

@end
