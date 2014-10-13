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

#import "TCellResult.h"
#import "TCellResultCodeDescription.h"

@implementation TCellRegistrationResult

- (TCellRegistrationResult*)initRegistrationResultWithResponse:(id)response error:(NSError*)error
{
    self = [super initWithResponseObject:response error:error];
    if (self){
        if (self.error == nil){
            NSString* reponseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            if ([reponseString isEqualToString:REGISTRATION_SUCCESS_RESPONSE])
                self.isSuccessfull = YES;
            else{
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:reponseString forKey:NSLocalizedDescriptionKey];
                self.resultCode = @"-1";
                self.error = [[NSError alloc] initWithDomain:@"Registration" code:[self.resultCode intValue] userInfo:details];
            }
            
        }
    }
    return self;
}

@end

@implementation TCellCategoryListQueryResult

@synthesize categories = _categories;

- (TCellCategoryListQueryResult*)initCategoryListQueryResultWithResponse:(id)response error:(NSError*)error
{
    self = [super initWithResponseObject:response error:error];
    if (self){
        if (self.error == nil){
            NSError *jSONerror;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jSONerror];
            if (jSONerror == nil){
                
                self.isSuccessfull = YES;
                
                if ([jsonDict isKindOfClass:[NSArray class]])
                    self.categories = (NSArray*)jsonDict;
                else if ([jsonDict isKindOfClass:[NSString class]])
                    self.categories = [NSArray arrayWithObjects:jsonDict,nil];
                
                if ([self.categories count] <= 0){
                    self.isSuccessfull = NO;
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:@"No categories" forKey:NSLocalizedDescriptionKey];
                    self.resultCode = @"-1";
                    self.error = [[NSError alloc] initWithDomain:@"CategoryList" code:[self.resultCode intValue] userInfo:details];
                }
                    
            }
            else{
                self.error = jSONerror;
                NSLog(@"JSON Serialization error: %@", [jSONerror description]);
            }
            
        }
    }
    return self;
}

@end

@implementation TCellCategorySubscriptionResult

- (TCellCategorySubscriptionResult*)initCategorySubscriptionsResultWithResponse:(id)response error:(NSError*)error

{
    self = [super initWithResponseObject:response error:error];
    if (self){
        if (self.error == nil){
            NSError *jSONerror;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jSONerror];
            if (jSONerror == nil){
                
                if ([jsonDict objectForKey:@"resultCode"]){
                    
                    NSString* resultCodeString = [jsonDict objectForKey:@"resultCode"];
                    self.resultCode = [resultCodeString stringByReplacingOccurrencesOfString:@"_" withString:@""];
                    
                    TCellResultCodeDescription* resultCodeDescription = [TCellResultCodeDescription sharedInstance];
                    
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:[resultCodeDescription.resultCodeDescriptionMap objectForKey:self.resultCode] forKey:NSLocalizedDescriptionKey];
                    
                    if ([self.resultCode isEqualToString:CATEGORY_SUCCESS_RESULT_CODE])
                        self.isSuccessfull = YES;
                    else
                        self.error = [[NSError alloc] initWithDomain:@"CategorySubscription" code:[self.resultCode intValue] userInfo:details];
                }
            }
            else
            {
                self.error = jSONerror;
                NSLog(@"JSON Serialization error: %@", [jSONerror description]);
            }
            
        }
        
    }
    return self;
}

@end

@implementation TCellNotificationHistoryResult

@synthesize messages = _messages;

- (TCellNotificationHistoryResult*)initNotificationHistoryResultWithResponse:(id)response error:(NSError*)error

{
    self = [super initWithResponseObject:response error:error];
    if (self){
        if (self.error == nil){
            NSError *jSONerror;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jSONerror];
            if (jSONerror == nil){
                
                self.isSuccessfull = YES;
                
                if ([jsonDict isKindOfClass:[NSArray class]])
                    self.messages = (NSArray*)jsonDict;
                else if ([jsonDict isKindOfClass:[NSString class]])
                    self.messages = [NSArray arrayWithObjects:jsonDict,nil];
                
                if ([self.messages count] <= 0){
                    //self.isSuccessfull = NO;
                    //NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    //[details setValue:@"No messages" forKey:NSLocalizedDescriptionKey];
                    //self.resultCode = @"-1";
                    //self.error = [[NSError alloc] initWithDomain:@"Message History" code:[self.resultCode intValue] userInfo:details];
                    self.messages = [NSArray arrayWithObjects:@"No History Message",nil];
                }
            }
            else{
                self.error = jSONerror;
                NSLog(@"JSON Serialization error: %@", [jSONerror description]);
            }
            
        }
    }
    return self;

}

@end

