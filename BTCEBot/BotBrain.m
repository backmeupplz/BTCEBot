//
//  BotBrain.m
//  BTCEBot
//
//  Created by Nikita Kolmogorov on 02.04.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "BotBrain.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation BotBrain {
    NSTimer *tracker;
}

@synthesize sellRateLabel;
@synthesize prevSellRateLabel;

- (IBAction)getRate:(NSButton *)sender {
    if ([sender.title isEqual:@"Start Tracking"]){
        tracker = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                           target:self
                                         selector:@selector(getExchangeRate)
                                         userInfo:nil repeats:YES];
    
    } else {
        [tracker invalidate];
    }
    [self changeButtonText:sender];
}

- (IBAction)getInfo:(NSButton *)sender {
    NSString *api = @"6OLMVLKF-6GBLLGAI-OBACQD1Q-R5C3IW82-WAE9NZGW";
    NSURL *url = [NSURL URLWithString:@"https://btc-e.com/tapi"];
    NSString *secret = @"5ef010b2a7f0073645b61e995b8f8a2a0a5257b35db43ba41d91a8726ce89615";
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *nonce = [NSNumber numberWithDouble: timeStamp];
    int nonce2 = nonce.intValue/1000;
    NSLog(@"%d", nonce2);
    
    NSString *post = [NSString stringWithFormat:@"nonce=%i&method=getinfo",nonce2];
    NSData *encriptedPost = hmacForKeyAndData(secret, post);
    NSLog(@"%@",encriptedPost);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:api forHTTPHeaderField:@"key"];
    [request setValue:@"111" forHTTPHeaderField:@"sign"];
    
    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;
    NSLog(@"%@",request.HTTPBody);
    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    
    
    NSString *theResponseString = [[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"response from server: %@",theResponseString);
    
}

- (void)changeButtonText:(NSButton *)button {
    if ([button.title isEqual:@"Start Tracking"]){
        [button setTitle:@"Stop Tracking"];
    } else {
        [button setTitle:@"Start Tracking"];
    }
}

- (void)getExchangeRate {
    dispatch_async(kBgQueue, ^{
        NSURL *url = [NSURL URLWithString:@"https://btc-e.com/api/2/ltc_usd/ticker"];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        NSDictionary* ticker = [json objectForKey:@"ticker"];
        NSString *sell = [ticker objectForKey:@"sell"];
        
        
        [prevSellRateLabel setStringValue:sellRateLabel.stringValue];
        [sellRateLabel setStringValue:sell];
    });
}

NSData *hmacForKeyAndData(NSString *key, NSString *data)
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *response = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString* myString;
    myString = [[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding];
    NSLog(@"%@",myString);
    
    return response;
}

@end
