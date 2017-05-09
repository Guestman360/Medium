//
//  CurrencySessionManager.m
//  Medium
//
//  Created by The Guest Family on 3/15/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import "CurrencySessionManager.h"

static NSString *ApiUrl = @"https://api.fixer.io/";

@implementation CurrencySessionManager

//This is the singleton class which is used to manage the swapping of currencies

+ (CurrencySessionManager *)sharedManager {
    static CurrencySessionManager *sharedManager = nil;

    sharedManager = [[self alloc]initWithBaseURL:[NSURL URLWithString:ApiUrl]];
    
    return sharedManager;
}

- (void)getExchangeForBaseCurrency:(NSString *)baseCurrency success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    NSString *commandString = [NSString stringWithFormat:@"/latest?base=%@", baseCurrency]; //removed a /
    
    [self GET:commandString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}

@end
