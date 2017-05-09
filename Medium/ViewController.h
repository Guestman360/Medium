//
//  ViewController.h
//  Medium
//
//  Created by The Guest Family on 2/27/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate, UISearchControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

//Properties
@property(nonatomic,strong) NSMutableArray *currencyRatesList;
@property(nonatomic,strong) NSArray *currencyNamesList;
@property(nonatomic, strong) NSMutableArray *filteredArray; 
@property(strong, nonatomic) UISearchController *searchController;
@property(nonatomic, assign) BOOL isFiltered;
@property(strong, nonatomic) NSMutableDictionary *images;
@property(nonatomic,strong) NSDictionary *exchanges;
@property(strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSMutableString *currentBaseCountry;
@property (strong, nonatomic) UIPickerView *pickerViewCurrency;
@property (nonatomic, strong) UITextField *pickerViewTextField;
@property (strong, nonatomic) NSDictionary *fullNames;

//Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *currencyTextField;
@property (weak, nonatomic) IBOutlet UIImageView *baseCurrencyImage;
@property (weak, nonatomic) IBOutlet UILabel *baseCurrencyName;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *swapCurrencyBtn;
@property (weak, nonatomic) IBOutlet UILabel *currencyFullName;


-(void)updateTableData;
-(void)getRates;
-(UIImage*)getImageForCurrency:(NSString*)currency;


@end

