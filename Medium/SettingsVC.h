//
//  SettingsVC.h
//  Medium
//
//  Created by The Guest Family on 3/12/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@interface SettingsVC : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate>

- (IBAction)dismissBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UITableView *staticTableView;
@property (weak, nonatomic) IBOutlet UIImageView *baseCurrencyImage;
@property (weak, nonatomic) IBOutlet UILabel *currencyName;
@property (weak, nonatomic) IBOutlet UILabel *currencyFullName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveDataBtn;

//@property (nonatomic, assign) ViewController *mainVC;
@property (strong, nonatomic) NSDictionary *pickerNames;

+ (void)updateDisplay:(ViewController *)vc;
//@property (strong, nonatomic) NSDictionary *pickerNames;

@end
