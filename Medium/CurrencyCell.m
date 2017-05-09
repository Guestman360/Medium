//
//  CurrencyCell.m
//  Medium
//
//  Created by The Guest Family on 2/28/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyCell.h"
#import "Currency.h"

@interface CurrencyCell()

@end

@implementation CurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI:(nonnull Currency*)currency {
    self.currencyName.text = currency.countryName; //This should update the cells with the proper flag, name and currency rate
    self.currencyRate.text = currency.rates;
    //self.currencyFlag.text = currency.flag [UIImagePNGRepresentation(@"%@.png",_currencyFlag)];
}


@end
