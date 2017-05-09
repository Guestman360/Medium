//
//  CurrencyCell.h
//  Medium
//
//  Created by The Guest Family on 2/28/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Currency;
@interface CurrencyCell : UITableViewCell


@property (nonnull, nonatomic) IBOutlet UIImageView *currencyFlag;
@property (nonnull, nonatomic) IBOutlet UILabel *currencyName;
@property (nonnull, nonatomic) IBOutlet UILabel *currencyRate;

-(void)updateUI:(nonnull Currency*)currency;

@end
