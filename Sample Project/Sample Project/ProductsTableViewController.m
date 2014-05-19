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

@interface ProductsTableViewController () <ASBankerDelegate>

@property (strong, nonatomic) ASBanker *banker;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) SKProduct *selectedProduct;

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
    
    self.banker = [ASBanker sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.banker) {
        self.banker.delegate = self;
    }
    
    if (!self.products) {
        [self.banker fetchProducts:@[kInAppPurchseIdentifierBasicGymPack,
                                     kInAppPurchseIdentifierProGymPack,
                                     kInAppPurchseIdentifierMembership]];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (void)purchaseButtonTapped:(UIButton *)sender {
    self.selectedProduct = [self.products objectAtIndex:sender.tag];
    
    ProductTableViewCell *cell = (ProductTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [cell startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.banker purchaseItem:self.selectedProduct];
}

#pragma mark - Private

- (void)somthingWentWrong {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.oops", @"Oops!")
                                                 message:NSLocalizedString(@"alert.message.error-connecting-to-itunes", @"Something went wrong whilst trying to connect to the iTunes Store. Please try again.")
                                                delegate:nil
                                       cancelButtonTitle:NSLocalizedString(@"alert.button.ok", @"OK")
                                       otherButtonTitles:nil];
	[av show];
}

- (void)stopActivityIndicators {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (self.selectedProduct) {
        NSUInteger idx = [self.products indexOfObjectIdenticalTo:self.selectedProduct];
        ProductTableViewCell *cell = (ProductTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        [cell stopAnimating];
        
        self.selectedProduct = nil;
    }
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
    cell.productImage.image = [UIImage imageNamed:kImageDummyIcon];
    
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
    [self somthingWentWrong];
    [self stopActivityIndicators];
}

- (void)bankerNoProductsFound {
    [self somthingWentWrong];
	[self stopActivityIndicators];
}

- (void)bankerFoundProducts:(NSArray *)products {
    [self stopActivityIndicators];
    
    if (self.products) {
        self.products = nil;
    }
    
    self.products = [NSArray arrayWithArray:products];
    
    [self.tableView reloadData];
}

- (void)bankerFoundInvalidProducts:(NSArray *)products {
    [self somthingWentWrong];
	[self stopActivityIndicators];
}

- (void)bankerProvideContent:(SKPaymentTransaction *)paymentTransaction {
    // Unlock feature or content here for the user.
    for (SKProduct *product in self.products) {
        if ([product.productIdentifier isEqualToString:paymentTransaction.payment.productIdentifier]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:product.productIdentifier];
            [defaults synchronize];
        }
    }
}

- (void)bankerPurchaseComplete:(SKPaymentTransaction *)paymentTransaction {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.purchased-in-app-purchase", @"Install Finished")
                                                 message:NSLocalizedString(@"alert.message.thanks", @"Thanks for your support, we hope you enjoy using our app.")
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"alert.button.ok", @"OK")
                                       otherButtonTitles:nil];
	[av show];
    
    [self stopActivityIndicators];
}

- (void)bankerPurchaseFailed:(NSString *)productIdentifier withError:(NSString *)errorDescription {
    [self somthingWentWrong];
	[self stopActivityIndicators];
}

- (void)bankerPurchaseCancelledByUser:(NSString *)productIdentifier {
    [self stopActivityIndicators];
}

- (void)bankerFailedRestorePurchases {
    [self stopActivityIndicators];
}

// Optional

- (void)bankerDidRestorePurchases {
    
}

- (void)bankerCanNotMakePurchases {
    // In-App Purchase are probally disabled in the Settings
    // Tell the user
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.in-app-purchases.disabled", @"Purchases Disabled")
                                                 message:NSLocalizedString(@"alert.message.in-app-purchases.disabled", @"Please check the restriction settings in the Settings app and then try again.")
                                                delegate:nil
                                       cancelButtonTitle:NSLocalizedString(@"alert.button.ok", @"OK")
                                       otherButtonTitles:nil];
	[av show];
}

- (void)bankerContentDownloadComplete:(SKDownload *)download {
    // Download is complete. Content file URL is at
    // path referenced by download.contentURL. Move
    // it somewhere safe, unpack it and give the user
    // access to it
    
    // The hosted content package is downloaded in the form of a Zip file.
}

- (void)bankerContentDownloading:(SKDownload *)download {
    DLog(@"Download progress = %f", download.progress);
    DLog(@"Download time = %f", download.timeRemaining);
}

@end
