//
//  BotBrain.m
//  BTCEBot
//
//  Created by Nikita Kolmogorov on 02.04.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "BotBrain.h"
#import "BtceApiHandler.h"

@implementation BotBrain {
    BtceApiHandler *apiHandler;
    NSTimer *tracker;
}

@synthesize ltcToUsdSellRateLabel;
@synthesize ltcToUsdBuyRateLabel;
@synthesize btcToUsdBuyRateLabel;
@synthesize btcToUsdSellRateLabel;
@synthesize ltcToBtcBuyRateLabel;
@synthesize ltcToBtcSellRateLabel;

@synthesize usdLabel,rurLabel,eurLabel,btcLabel,ltcLabel,nmcLabel,nvcLabel,trcLabel,ppcLabel;
@synthesize apiInfo, apiTrade, apiWithdraw;
@synthesize openOrdersLabel, transactionCountLabel;

@synthesize sellRateTextField,sellAmountTextField,buyRateTextField,buyAmountTextField;

// Initialization

- (id)init {
    self = [super init];
    if (self) {
        apiHandler = [[BtceApiHandler alloc] init];
    }
    return self;
}

// User Interface

- (IBAction)startOrStopBot:(NSButton *)sender {
    if ([sender.title isEqual:@"Start Bot"]){
        tracker = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                   target:self
                                                 selector:@selector(update)
                                                 userInfo:nil repeats:YES];
        
    } else {
        [tracker invalidate];
    }
    [self changeButtonText:sender];
}

- (IBAction)sellButtonPressed:(NSButton *)sender {
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    [post setObject:@"Trade" forKey:@"method"];
    [post setObject:@"ltc_usd" forKey:@"pair"];
    [post setObject:@"sell" forKey:@"type"];
    [post setObject:sellRateTextField.stringValue forKey:@"rate"];
    [post setObject:sellAmountTextField.stringValue forKey:@"amount"];
    NSData *response = [apiHandler getResponseFromServerForPost:post];
    NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
}

- (IBAction)buyButtonPressed:(NSButton *)sender {
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    [post setObject:@"Trade" forKey:@"method"];
    [post setObject:@"ltc_usd" forKey:@"pair"];
    [post setObject:@"buy" forKey:@"type"];
    [post setObject:buyRateTextField.stringValue forKey:@"rate"];
    [post setObject:buyAmountTextField.stringValue forKey:@"amount"];
    NSData *response = [apiHandler getResponseFromServerForPost:post];
    NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
}

- (void)changeButtonText:(NSButton *)button {
    if ([button.title isEqual:@"Start Bot"]){
        [button setTitle:@"Stop Bot"];
    } else {
        [button setTitle:@"Start Bot"];
    }
}

// Bot Logic

- (void)update {
    [self updateLtcToUsdRate];
    [self updateBtcToUsdRate];
    [self updateLtcToBtcRate];
    [self updateAccountInfo];
}

- (void)updateLtcToUsdRate {
    dispatch_async(kBgQueue, ^{
        NSData *data = [apiHandler getResponseFromPublicServerUrl:@"https://btc-e.com/api/2/ltc_usd/ticker"];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        NSDictionary* ticker = [json objectForKey:@"ticker"];
        NSString *sell = [ticker objectForKey:@"sell"];
        NSString *buy = [ticker objectForKey:@"buy"];
        ltcToUsdSellRateLabel.stringValue = addDollarSign(sell);
        ltcToUsdBuyRateLabel.stringValue = addDollarSign(buy);
    });
}

- (void)updateBtcToUsdRate {
    dispatch_async(kBgQueue, ^{
        NSData *data = [apiHandler getResponseFromPublicServerUrl:@"https://btc-e.com/api/2/btc_usd/ticker"];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        NSDictionary* ticker = [json objectForKey:@"ticker"];
        NSString *sell = [ticker objectForKey:@"sell"];
        NSString *buy = [ticker objectForKey:@"buy"];
        btcToUsdSellRateLabel.stringValue = addDollarSign(sell);
        btcToUsdBuyRateLabel.stringValue = addDollarSign(buy);
    });
}

- (void)updateLtcToBtcRate {
    dispatch_async(kBgQueue, ^{
        NSData *data = [apiHandler getResponseFromPublicServerUrl:@"https://btc-e.com/api/2/ltc_btc/ticker"];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        NSDictionary* ticker = [json objectForKey:@"ticker"];
        NSString *sell = [ticker objectForKey:@"sell"];
        NSString *buy = [ticker objectForKey:@"buy"];
        ltcToBtcSellRateLabel.stringValue = addDollarSign(sell);
        ltcToBtcBuyRateLabel.stringValue = addDollarSign(buy);
    });
}

- (void)updateAccountInfo {
    dispatch_async(kBgQueue, ^{
        NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
        [post setObject:@"getInfo" forKey:@"method"];
        NSData *response = [apiHandler getResponseFromServerForPost:post];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:response
                              options:kNilOptions
                              error:&error];
        
        NSDictionary *info = [json objectForKey:@"return"];
        NSDictionary *funds = [info objectForKey:@"funds"];
        NSDictionary *rights = [info objectForKey:@"rights"];
        
        NSString *openOrders = [info objectForKey:@"open_orders"];
        NSString *transactionCount = [info objectForKey:@"transaction_count"];
        
        NSString *usd = [NSString stringWithFormat:@"%f",[[funds objectForKey:@"usd"] doubleValue]];
        NSString *rur = [NSString stringWithFormat:@"%f",[[funds objectForKey:@"rur"] doubleValue]];
        NSString *eur = [NSString stringWithFormat:@"%f",[[funds objectForKey:@"eur"] doubleValue]];
        NSString *btc = [NSString stringWithFormat:@"%f",[[funds objectForKey:@"btc"] doubleValue]];
        NSString *ltc = [NSString stringWithFormat:@"%f",[[funds objectForKey:@"ltc"] doubleValue]];
        NSString *nmc = [NSString stringWithFormat:@"%f",[[funds objectForKey:@"nmc"] doubleValue]];
        NSString *nvc = [NSString stringWithFormat:@"%f",[[funds objectForKey:@"nvc"] doubleValue]];
        NSString *trc = [NSString stringWithFormat:@"%f",[[funds objectForKey:@"trc"] doubleValue]];
        NSString *ppc = [NSString stringWithFormat:@"%f",[[funds objectForKey:@"ppc"] doubleValue]];
        
        NSString *infoRight = [rights objectForKey:@"info"];
        NSString *tradeRight = [rights objectForKey:@"trade"];
        NSString *withdrawRight = [rights objectForKey:@"withdraw"];
        
        usdLabel.stringValue = addDollarSign(usd);
        rurLabel.stringValue = addDollarSign(rur);
        eurLabel.stringValue = addDollarSign(eur);
        btcLabel.stringValue = addDollarSign(btc);
        ltcLabel.stringValue = addDollarSign(ltc);
        nmcLabel.stringValue = addDollarSign(nmc);
        nvcLabel.stringValue = addDollarSign(nvc);
        trcLabel.stringValue = addDollarSign(trc);
        ppcLabel.stringValue = addDollarSign(ppc);
        
        apiWithdraw.stringValue = withdrawRight;
        apiInfo.stringValue = infoRight;
        apiTrade.stringValue = tradeRight;
        
        openOrdersLabel.stringValue = openOrders;
        transactionCountLabel.stringValue = transactionCount;
    });
}

// Useful Functions

NSString *addDollarSign(NSString *string) {
    NSString *newString = [NSString stringWithFormat:@"$%@",string];
    return newString;
}

@end
