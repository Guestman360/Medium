//
//  SettingsVC.m
//  Medium
//
//  Created by The Guest Family on 3/12/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import "SettingsVC.h"
#import "ViewController.h"
#import "CurrencyCell.h"
#import "CurrencySessionManager.h"

@interface SettingsVC ()

@end

@implementation SettingsVC {
    NSArray *pickerData;
    //NSDictionary *pickerNames;
    ViewController *vc;
    NSMutableDictionary *images;
    //NSArray *fullNames;
}
//-----------------------------------------------------------------------
//  THESE FILES ARE UNUSED IN FINAL VERSION OF APP BUT I THOUGHT I'D KEEP
//  THEM AS A REFERENCE AS I MADE SOME COOL THINGS WORK HERE
//-----------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    //https://ios.eezytutorials.com/nsdictionary-by-example.php#.WMm2ZGUzHzI
    //Dont reinstantiate it, already declared in .h so be careful
    _pickerNames = @{@"AUD":@"Australian Dollar",
                     @"BGN":@"Bulgarian Lev",
                     @"BRL":@"Brazilian Real",
                     @"CAD":@"Canadian Dollar",
                     @"CHF":@"Swiss Franc",
                     @"CNY":@"Chinese Yuan",
                     @"CZK":@"Czech Republic Koruna",
                     @"DKK":@"Danish Krone",
                     @"EUR":@"Euro",
                     @"GBP":@"British Pound",
                     @"HKD":@"Hong Kong Dollar",
                     @"HRK":@"Croatian Kuna",
                     @"HUF":@"Hungarian Forint",
                     @"IDR":@"Indonesian Rupiah",
                     @"ILS":@"Israeli New Sheqel",
                     @"INR":@"Indian Rupee",
                     @"JPY":@"Japanese Yen",
                     @"KRW":@"South Korean Won",
                     @"MXN":@"Mexican Peso",
                     @"MYR":@"Malaysian Ringgit",
                     @"NOK":@"Norwegian Krone",
                     @"NZD":@"New Zealand Dollar",
                     @"PHP":@"Philippine Peso",
                     @"PLN":@"Polish Zloty",
                     @"RON":@"Romanian Leu",
                     @"RUB":@"Russian Ruble",
                     @"SEK":@"Swedish Krona",
                     @"SGD":@"Singapore Dollar",
                     @"THB":@"Thai Baht",
                     @"TRY":@"Turkish Lira",
                     @"USD":@"United States Dollar",
                     @"ZAR":@"South African Rand"};

}

#pragma mark - Tableview

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];

}

#pragma mark - Table view/Picker delegate & datasource
// returns the number of 'columns' to display.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = (id)view;
    
    if (!label)
    {
        
        label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        NSArray *name = [[_pickerNames allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        label.text = name[row];
        
    }
    
    return label;
}


// returns the # of rows in each component..
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
   
    NSInteger pickerCount = [[_pickerNames allKeys] count];
    
    return pickerCount;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    NSArray *nameKeys = [[_pickerNames allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return nameKeys[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    UILabel *labelSelected = (UILabel*)[pickerView viewForRow:row forComponent:component];
    [labelSelected setTextColor:[UIColor whiteColor]];
    
    _currencyName.alpha = 0;
    _currencyFullName.alpha = 0;
    _baseCurrencyImage.alpha = 0;
    
    //if this row get the vlaue of that key
    NSArray *nameKey = [[_pickerNames allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [UIView animateWithDuration:0.5 animations:^{
        _currencyName.alpha = 1.0;
        _currencyFullName.alpha = 1.0;
        _baseCurrencyImage.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        NSLog(@"Nice Job!");
    }];
    
    self.currencyName.text = nameKey[row];
    self.currencyFullName.text = [_pickerNames valueForKey:nameKey[row]];
    self.baseCurrencyImage.image = [self getImageForCurrency:nameKey[row]];
    
//    //push new data to main vc, flag image and curreny name
//    vc.baseCurrencyImage.image = [self getImageForCurrency:nameKey[row]];
//    vc.baseCurrencyName.text = [pickerNames valueForKey:nameKey[row]];
    
    if ([nameKey[row]  isEqual: @"USD"]) {
        //self.baseCurrencyImage.image = [self getImageForCurrency:@"USD.png"];
        //WORK ON THIS LATER, GET WORKING
        self.baseCurrencyImage.image = [UIImage imageNamed:@"USD.png"];
    }
    
    NSLog(@"flag: %@", nameKey[row]);
}
#pragma mark - fetches the image
-(UIImage*)getImageForCurrency:(NSString*)currency {
    UIImage *img;
    
    currency = [currency uppercaseString];
    
    if([images objectForKey:currency] == nil) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",currency]];
    } else {
        img = (UIImage*)[images objectForKey:currency];
    }
    
    return img;
}

+ (void)updateDisplay:(ViewController *)vc {
    //push new data to main vc, flag image and curreny name
    
}

#pragma mark - IBAction to dismiss view
- (IBAction)dismissBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //keep data saved?
        
    }];
}

- (IBAction)saveDataBtn:(id)sender {
    
    
}


@end











