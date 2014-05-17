//
//  ProductsTableViewController.m
//  Sample Project
//
//  Created by Ross Gibson on 17/05/2014.
//  Copyright (c) 2014 Awarai Studios Limited. All rights reserved.
//

#import "ProductsTableViewController.h"

#import "ASBanker.h"
#import "Constants.h"
#import "ProductTableViewCell.h"
#import "ProductViewController.h"

@interface ProductsTableViewController () <ASBankerDelegate> {
    
}

@property (strong, nonatomic) ASBanker *banker;

@property (strong, nonatomic) NSArray *products;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ProductsTableViewController

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.banker = [ASBanker sharedInstance];
	self.banker.delegate = self;
    
#warning - These are not valid products, please change for your own
	[self.banker fetchProducts:@[kInAppPurchseIdentifierBasicGymPack,
                                 kInAppPurchseIdentifierProGymPack,
                                 kInAppPurchseIdentifierMembership]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (void)purchaseButtonTapped:(UIButton *)sender {
    SKProduct *product = [self.products objectAtIndex:sender.tag];
    
    [self.banker purchaseItem:product];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = (ProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kProductCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    SKProduct *product = [self.products objectAtIndex:indexPath.row];
	
	cell.productTitle.text = product.localizedTitle;
    cell.productDescription.text = product.localizedDescription;
    cell.productImage.image = [UIImage imageNamed:@"DummyIcon"];
    
	[cell.purchaseButton setTitle:product.localizedPrice forState:UIControlStateNormal];
    
    [cell.purchaseButton addTarget:self action:@selector(purchaseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.purchaseButton.tag = indexPath.row;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kStoryboardSegueIdentifierProduct]) {
        ProductViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.product = [self.products objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

#pragma mark - ASBankerDelegate

// Required

- (void)bankerFailedToConnect {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", @"Alert view title")
                                                 message:NSLocalizedString(@"Something went wrong whilst trying to connect to the iTunes Store. Please try again.", @"Alert message")
                                                delegate:nil
                                       cancelButtonTitle:NSLocalizedString(@"OK", @"Button title")
                                       otherButtonTitles:nil];
	[av show];
	
	[self.activityIndicator stopAnimating];
}

- (void)bankerNoProductsFound {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", @"Alert view title")
                                                 message:NSLocalizedString(@"Something went wrong whilst trying to connect to the iTunes Store. Please try again.", @"Alert message")
                                                delegate:nil
                                       cancelButtonTitle:NSLocalizedString(@"OK", @"Button title")
                                       otherButtonTitles:nil];
	[av show];
	
	[self.activityIndicator stopAnimating];
}

- (void)bankerFoundProducts:(NSArray *)products {
    [self.activityIndicator stopAnimating];
    
    if (self.products) {
        self.products = nil;
    }
    
    self.products = [NSArray arrayWithArray:products];
    
    [self.tableView reloadData];
}

- (void)bankerFoundInvalidProducts:(NSArray *)products {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", @"Alert view title")
                                                 message:NSLocalizedString(@"Something went wrong whilst trying to connect to the iTunes Store. Please try again.", @"Alert message")
                                                delegate:nil
                                       cancelButtonTitle:NSLocalizedString(@"OK", @"Button title")
                                       otherButtonTitles:nil];
	[av show];
	
	[self.activityIndicator stopAnimating];
}

- (void)bankerProvideContent:(SKPaymentTransaction *)paymentTransaction {
    // Unlock feature or content here before for the user.
    for (SKProduct *product in self.products) {
        if ([product.productIdentifier isEqualToString:paymentTransaction.payment.productIdentifier]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:product.productIdentifier];
            [defaults synchronize];
        }
    }
}

- (void)bankerPurchaseComplete:(SKPaymentTransaction *)paymentTransaction {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nice one!", @"Alert view title")
                                                 message:NSLocalizedString(@"Thanks for your support, we hope you enjoy the app.", @"Alert message")
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"OK", @"Button title")
                                       otherButtonTitles:nil];
	[av show];
    
    [self.activityIndicator stopAnimating];
}

- (void)bankerPurchaseFailed:(NSString *)productIdentifier withError:(NSString *)errorDescription {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", @"Alert view title")
                                                 message:NSLocalizedString(@"Something went wrong whilst trying to connect to the iTunes Store. Please try again.", @"Alert message")
                                                delegate:nil
                                       cancelButtonTitle:NSLocalizedString(@"OK", @"Button title")
                                       otherButtonTitles:nil];
	[av show];
	
	[self.activityIndicator stopAnimating];
}

- (void)bankerPurchaseCancelledByUser:(NSString *)productIdentifier {
    [self.activityIndicator stopAnimating];
}

- (void)bankerFailedRestorePurchases {
    [self.activityIndicator stopAnimating];
}

// Optional

- (void)bankerDidRestorePurchases {
    
}

- (void)bankerCanNotMakePurchases {
    // Tell user that In-App Purchase is disabled in Settings
}

- (void)bankerContentDownloadComplete:(SKDownload *)download {
    // Download is complete. Content file URL is at
    // path referenced by download.contentURL. Move
    // it somewhere safe, unpack it and give the user
    // access to it
    
    // The hosted content package is downloaded in the form of a Zip file.
}

- (void)bankerContentDownloading:(SKDownload *)download {
    NSLog(@"Download progress = %f", download.progress);
    NSLog(@"Download time = %f", download.timeRemaining);
}

@end
