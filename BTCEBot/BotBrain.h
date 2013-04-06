//
//  BotBrain.h
//  BTCEBot
//
//  Created by Nikita Kolmogorov on 02.04.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BotBrain : NSObject

@property (weak) IBOutlet NSTextField *ltcToUsdSellRateLabel;
@property (weak) IBOutlet NSTextField *ltcToUsdBuyRateLabel;
@property (weak) IBOutlet NSTextField *btcToUsdSellRateLabel;
@property (weak) IBOutlet NSTextField *btcToUsdBuyRateLabel;
@property (weak) IBOutlet NSTextField *ltcToBtcSellRateLabel;
@property (weak) IBOutlet NSTextField *ltcToBtcBuyRateLabel;

@property (weak) IBOutlet NSTextField *usdLabel;
@property (weak) IBOutlet NSTextField *rurLabel;
@property (weak) IBOutlet NSTextField *eurLabel;
@property (weak) IBOutlet NSTextField *btcLabel;
@property (weak) IBOutlet NSTextField *ltcLabel;
@property (weak) IBOutlet NSTextField *nmcLabel;
@property (weak) IBOutlet NSTextField *nvcLabel;
@property (weak) IBOutlet NSTextField *trcLabel;
@property (weak) IBOutlet NSTextField *ppcLabel;

@property (weak) IBOutlet NSTextField *apiInfo;
@property (weak) IBOutlet NSTextField *apiTrade;
@property (weak) IBOutlet NSTextField *apiWithdraw;

@property (weak) IBOutlet NSTextField *openOrdersLabel;
@property (weak) IBOutlet NSTextField *transactionCountLabel;

@property (weak) IBOutlet NSTextField *sellAmountTextField;
@property (weak) IBOutlet NSTextField *sellRateTextField;
@property (weak) IBOutlet NSTextField *buyAmountTextField;
@property (weak) IBOutlet NSTextField *buyRateTextField;

- (IBAction)startOrStopBot:(NSButton *)sender;
- (IBAction)sellButtonPressed:(NSButton *)sender;
- (IBAction)buyButtonPressed:(NSButton *)sender;

@end
