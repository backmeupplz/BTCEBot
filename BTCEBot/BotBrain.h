//
//  BotBrain.h
//  BTCEBot
//
//  Created by Nikita Kolmogorov on 02.04.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BotBrain : NSObject

@property (weak) IBOutlet NSTextField *sellRateLabel;
@property (weak) IBOutlet NSTextField *prevSellRateLabel;

- (IBAction)getRate:(NSButton *)sender;

- (IBAction)getInfo:(NSButton *)sender;

@end
