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

#import "TCellResultCodeDescription.h"

NSString* const REGISTRATION_SUCCESS_RESPONSE = @"OK";
NSString* const CATEGORY_SUCCESS_RESULT_CODE = @"0000";

@implementation TCellResultCodeDescription
@synthesize resultCodeDescriptionMap = _resultCodeDescriptionMap;

+ (TCellResultCodeDescription *)sharedInstance
{
    static TCellResultCodeDescription *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TCellResultCodeDescription alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (NSDictionary*)resultCodeDescriptionMap
{
    if (_resultCodeDescriptionMap == nil)
        _resultCodeDescriptionMap = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:
                                                                           @"Invalid token",
                                                                           @"Secret key is wrong",
                                                                           @"Token has already been sent to push server",
                                                                           @"App id is unrecognized by push server",
                                                                           @"No registration found!",
                                                                           @"Operation succeeded",
                                                                           @"System exception. Please retry.",
                                                                           @"Mandatory parameter is null (Message content is incomplete)",
                                                                           @"AppId does not exist",
                                                                           @"Invalid Key",
                                                                           @"No device found. Message is canceled.",
                                                                           @"Scheduled message is successfully defined.",
                                                                           @"No test device found.",
                                                                           @"Message Type is not selected.",
                                                                           @"Parameter ‚Äòcount‚Äô is not numeric.",
                                                                           @"Device or Registration is not found.",
                                                                           @"Category is not found",
                                                                           @"Category is already set for the device.",
                                                                           nil] forKeys:[NSArray arrayWithObjects:
                                                                                         @"invalid token",
                                                                                         @"invalid KEY",
                                                                                         @"TOKEN EXISTS",
                                                                                         @"invalid AppId",
                                                                                         @"no registration found!",
                                                                                         @"0000",
                                                                                         @"1001",
                                                                                         @"1002",
                                                                                         @"2001",
                                                                                         @"2002",
                                                                                         @"2003",
                                                                                         @"2004",
                                                                                         @"2005",
                                                                                         @"2006",
                                                                                         @"2007",
                                                                                         @"2008",
                                                                                         @"2009",
                                                                                         @"2010",
                                                                                         nil]];
    return _resultCodeDescriptionMap;
}

@end
