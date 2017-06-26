//
//  NSString+NSString_DES.m
//  EXO
//
//  Created by Lucifer on 14-4-8.
//  Copyright (c) 2014年 airspuer . All rights reserved.
//

#import "NSString+NSString_DES.h"
#import <CommonCrypto/CommonCryptor.h>
@implementation NSString (NSString_DES)

+ (NSString *)encryptDESPlaintext:(NSString *)plainString
{
    static const char *key = "MySecYYT";
    
    static char buffer [1024];
    memset(buffer, 0, sizeof(buffer));
    size_t numBytesEncrypted;
    
    const char *plaintext = [plainString cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          key,
                                          kCCKeySizeDES,
                                          NULL,
                                          plaintext,
                                          strlen(plaintext),
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSMutableString *result = [NSMutableString stringWithCapacity:numBytesEncrypted*2];
        for (int i=0; i<numBytesEncrypted; ++i) {
            char c = buffer[i];
            [result appendFormat:@"%02x",c&0xff];
        }
        return result;
    }
    
    return nil;
}

@end
