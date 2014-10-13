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

#import "sha256.h"

#include <CommonCrypto/CommonDigest.h>

@implementation sha256

/* getEncryptedString
 *
 * \param stringToBeEncrypted (NSString *)  -> String to be encrypted with sha256.
 * \returns encryptedString (NSString *)     -> Encrypted String.
 */
-(NSString*)getEncryptedString:(NSString *)stringToBeEncrypted
{
    const char *s=[stringToBeEncrypted cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *encryptedString=[out description];
    encryptedString = [encryptedString stringByReplacingOccurrencesOfString:@" " withString:@""];
    encryptedString = [encryptedString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    encryptedString = [encryptedString stringByReplacingOccurrencesOfString:@">" withString:@""];
    return encryptedString;
}

@end


