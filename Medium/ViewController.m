//
//  ViewController.m
//  Medium
//
//  Created by The Guest Family on 2/27/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//
#import "ViewController.h"
#import "CurrencyCell.h"
#import "Currency.h"
#import "CurrencySessionManager.h"
#import "SettingsVC.h"

#define CURRENCY_EXCHANGE_URL @"http://api.fixer.io/latest?base=USD"
static NSString *const baseDefaultCurrency = @"USD";

@interface ViewController ()
@property (strong, nonatomic)UIRefreshControl *refreshControl;
@end

@implementation ViewController {
    float exchangeRateValue;
    CurrencyCell *tableCell;
}
//http://medium-app-supportblog.blogspot.com/2017/03/medium-currency-converter-support-blog.html Make sure to use this for app submission
@synthesize currencyNamesList;
@synthesize currencyRatesList;
@synthesize filteredArray;
@synthesize searchController;
@synthesize isFiltered;
@synthesize pickerViewTextField;
@synthesize currencyFullName;

-(void)viewDidLoad {
    [super viewDidLoad];
    _fullNames = @{@"AUD":@"Australian Dollar",
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
    
    //This adds a pull to refresh - UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:68/255.0 green:174/255.0 blue:125/255.0 alpha:1.0];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(updateTableData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    
    self.searchBar.delegate = (id)self;
    self.currencyTextField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.pickerViewCurrency.delegate = self;
    self.pickerViewCurrency.dataSource = self;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Set some attributes for appearance
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    //Add to decimal pad so you can back out
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
    id space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.items = @[space, doneButton];
    self.currencyTextField.inputAccessoryView = toolbar;
    
    //Set up the picker view for the button action --- PickerView
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pickerView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.pickerViewTextField.inputView = pickerView;
    
    UIToolbar *toolbarPick = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
    toolbar.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
//    [barItems addObject:cancelButton];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneButtonPick = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    [barItems addObject:doneButtonPick];
    toolbarPick.items = barItems;
    
    self.pickerViewTextField.inputAccessoryView = toolbarPick;
    
    [self getRates];
    [self getCurrencyData];
    [self updateTableData];
    [self.tableView reloadData];
}

#pragma mark - fetching the currency data
//funtion that fetches the json data and sets the initial tableview
-(void)getRates{
    NSURL *fixerURL = [NSURL URLWithString:CURRENCY_EXCHANGE_URL];
    NSData *url = [NSData dataWithContentsOfURL:fixerURL];
    NSError *error;
    
    if(error == nil){
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:url options:kNilOptions error:&error];
        //NSString *base = [[NSString alloc]initWithString:[jsonDict objectForKey:@"base"]];
        NSDictionary *json = [[NSDictionary alloc]initWithDictionary:[jsonDict objectForKey:@"rates"]];
        //Put the NSDictionary *json in exchanges which is also NSDictionary, to pass around
        self.exchanges = json;
        //Fetches and sorts all the keys alphabetically
        self.countries = [[json allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; //currencyNamesList
        
        [self.refreshControl endRefreshing]; //might be useful
    }
}
//make and call this as a means to display the flag, name and rates in tableview - SINGELTON
-(void)getCurrencyData {
    [[CurrencySessionManager sharedManager] getExchangeForBaseCurrency:self.baseCurrencyName.text success:^(NSDictionary *response) {
        //put contents of "rates" in the exchnages, then countries stores all the keys of exchanges
        self.exchanges = response[@"rates"]; //dictionary stores "rates"
        self.countries = [[self.exchanges allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        //self.currentBaseCountry = [NSMutableString stringWithFormat:@"%@", self.baseCurrencyName.text];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        //self.baseCurrencyName.text = [NSMutableString stringWithFormat:@"%@", self.currentBaseCountry];
    }];
}

#pragma mark - status bar customization & refresh control
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}

-(void)updateTableData {
    dispatch_async(dispatch_get_main_queue(), ^{
        // End the refreshing
        if (self.refreshControl) {
            //Create the format for current date object
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            //Another object for the title, works with date, string interpolation
            NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
            //Create dictionary of attributes, to be used in attributed string with the title
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                        forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
            self.refreshControl.attributedTitle = attributedTitle;
            [self.refreshControl endRefreshing];
            [self getCurrencyData];
        }
    });
}
//Captures country names and appends .png at the end, this gets the appropriate image
-(UIImage*)getImageForCurrency:(NSString*)currency {
    UIImage *img;
    currency = [currency uppercaseString];
    
    if([self.images objectForKey:currency] == nil) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",currency]];
    } else {
        img = (UIImage*)[self.images objectForKey:currency];
    }
    return img;
}

#pragma mark - PickerView Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (id)view;
    if (!label) {
        label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        NSArray *name = [[self.exchanges allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        label.text = name[row];
    }
    return label;
}

// returns the # of rows in each component
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.countries count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.countries[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UILabel *labelSelected = (UILabel*)[pickerView viewForRow:row forComponent:component];
    [labelSelected setTextColor:[UIColor whiteColor]];
    //TOOK AWAY ANIMATION
//    self.baseCurrencyImage.alpha = 0;
//    self.baseCurrencyName.alpha = 0;
//    self.currencyFullName.alpha = 0;
//    [UIView animateWithDuration:0.05 animations:^{
//        self.baseCurrencyImage.alpha = 1.0;
//        self.baseCurrencyName.alpha = 1.0;
//        self.currencyFullName.alpha = 1.0;
//    } completion:^(BOOL finished) {
//    }]; //when all cells are scrolled through then it returns to normal...update this bug in later versions
    self.baseCurrencyName.text = self.countries[row];
    self.baseCurrencyImage.image = [self getImageForCurrency:self.countries[row]];
    self.currencyFullName.text = [self getFullCurrencyName:self.countries[row]];
    [self getCurrencyData];
}

-(NSString*)getFullCurrencyName:(NSString*)currency {
    NSString *fullName;
    currency = [currency uppercaseString];
    
    if([self.fullNames objectForKey:currency] == nil) {
        fullName = [NSString stringWithFormat:@"%@", [self.fullNames valueForKey:currency]];
    } else {
        fullName = (NSString*)[self.fullNames objectForKey:currency];
    }
    //self.currentBaseCountry = [NSString stringWithFormat:@"%@", [self.fullNames valueForKey:currency]];
    //self.baseCurrencyName.text = self.currentBaseCountry;
    return fullName;
}
//Here are the cancel and done buttons for the pickerview menu - WORK ON THESE IN LATER UPDATE
//-(void)cancelButtonPressed {
//    [self.pickerViewTextField resignFirstResponder];
//    self.baseCurrencyName.text = self.currentBaseCountry;
//    self.baseCurrencyImage.image = [self getImageForCurrency:self.currentBaseCountry];
//    self.currencyFullName.text = [self.fullNames valueForKey:self.currentBaseCountry];
//    //    self.baseCurrencyName.text = self.currentBaseCountry;
////    NSLog(@"Current Base: %@",_currentBaseCountry);
////    self.baseCurrencyImage.image = [self getImageForCurrency:self.currentBaseCountry];
////    self.currencyFullName.text = self.fullNames[self.currentBaseCountry];
//    //MAKE SURE THE RATES ARE SET BACK (GETCURRENCYUPDATE) AND THE FULLCURRENCY NAME IS SET
//}

-(void)doneButtonPressed {
    [self.pickerViewTextField resignFirstResponder];
    [self updateTableData];
    [self.tableView reloadData];
}
#pragma mark - TableView Delegate Methods
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //get the frame of the row in tableview
    CGRect originalFrameCell = [self.tableView rectForRowAtIndexPath:indexPath];
    self.tableView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    //cell frame equals 0 - size of originalFameCell, this puts it offscreen to slide in
    cell.frame = CGRectMake(0 - originalFrameCell.size.width,
                            originalFrameCell.origin.y,
                            originalFrameCell.size.width,
                            originalFrameCell.size.height);
    
    [UIView animateWithDuration:0.65 delay:0.15 usingSpringWithDamping:1.0 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
        cell.frame = originalFrameCell;
    } completion:^(BOOL finished) {
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"main";
    CurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NSString *country = self.countries[indexPath.row];
    NSNumber *rates = self.exchanges[country];
    cell.currencyName.text = country;
    cell.currencyRate.text = [NSString stringWithFormat:@"%.02f", [rates doubleValue]];
    [cell.currencyFlag setImage:[self getImageForCurrency:country]];
    //[self getCurrencyData];
    if(self.currencyTextField.text != 0) {
        double value = [self.currencyTextField.text doubleValue];
        double rate = [rates doubleValue];
        double sum = rate * value;
        cell.currencyRate.text = [NSString stringWithFormat:@"%.02f", sum];
    }
    
    if(isFiltered){
        if(self.currencyTextField.text != 0) {
            cell.currencyName.text = [filteredArray objectAtIndex:indexPath.row];
            [cell.currencyFlag setImage:[self getImageForCurrency:cell.currencyName.text]];
            NSNumber *rates1 = self.exchanges[cell.currencyName.text];
            //ALLOWS THE CURRENCY RATES TO BE CORRECTLY DISPLAYED AFTER BEING FILTERED
            double value = [self.currencyTextField.text doubleValue];
            double rate1 = [rates1 doubleValue];
            double sum = rate1 * value;
            cell.currencyRate.text = [NSString stringWithFormat:@"%.02f", sum];
        }
        [self getCurrencyData];
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered) {
        return [self.filteredArray count];
    } else {
        return [self.countries count];
    }
}

#pragma mark - TextField Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.currencyTextField = textField;
    NSLocale *locale = [NSLocale currentLocale];
    NSString *thousandSeparator = [locale objectForKey:NSLocaleGroupingSeparator];
    NSString *result = [thousandSeparator stringByReplacingOccurrencesOfString:thousandSeparator withString:@""];
    
    return result;
}

-(void)dismissKeyboard {
    [self.currencyTextField resignFirstResponder];
    [self getCurrencyData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currencyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.currencyTextField = textField;
    tableCell.currencyRate.alpha = 0.0;
    [UIView animateWithDuration:0.15 delay:0.05 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        tableCell.currencyRate.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    [self getCurrencyData];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.currencyTextField = textField;
    [UIView transitionWithView:tableCell.currencyRate
                      duration:0.55
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.tableView reloadData];
                        [self getCurrencyData];
                    } completion:^(BOOL finished) {
                        //[self.tableView reloadData]; //watch this maybe remove?
                    }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.currencyTextField resignFirstResponder];
    return YES;
}
//did some minor work here Mar 23 1:55 PM!
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length == 0) {
        [filteredArray removeAllObjects];
        [self getCurrencyData];
        isFiltered = NO;
    } else {
        isFiltered = YES;
        filteredArray = [[NSMutableArray alloc]init];
        [self.filteredArray removeAllObjects];
        
        for(NSString *names in self.exchanges) {
            NSRange nameRange = [names rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [names.description rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound) {
                [filteredArray addObject:names];
            }
            [self.tableView reloadData];
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
    [self getCurrencyData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
    [self getCurrencyData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self getCurrencyData];
}

#pragma mark - button action
-(IBAction)swapCurrency:(id)sender {
    [self.pickerViewTextField becomeFirstResponder];
}

-(IBAction)shareBtn:(id)sender {
    NSArray* sharedObjects=[NSArray arrayWithObjects:@"sharecontent",  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}
@end
