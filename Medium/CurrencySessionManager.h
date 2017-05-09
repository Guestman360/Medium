//
//  CurrencySessionManager.h
//  Medium
//
//  Created by The Guest Family on 3/15/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface CurrencySessionManager : AFHTTPSessionManager

//INSTALL AFNETWORKING POD

+ (CurrencySessionManager *)sharedManager;

- (void)getExchangeForBaseCurrency:(NSString *)baseCurrency
                           success:(void (^)(NSDictionary *response))success
                           failure:(void (^)(NSError *error))failure;

@end
