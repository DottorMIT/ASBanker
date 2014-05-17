//
//  OptionsTableViewController.m
//  Sample Project
//
//  Created by Ross Gibson on 17/05/2014.
//  Copyright (c) 2014 Awarai Studios Limited. All rights reserved.
//

#import "OptionsTableViewController.h"

#import "ASBanker.h"

@interface OptionsTableViewController () <ASBankerDelegate> {
    
}

@property (strong, nonatomic) ASBanker *banker;

@property (weak, nonatomic) IBOutlet UIButton *restoreButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation OptionsTableViewController

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
    self.banker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.activityIndicator startAnimating];
    
	self.restoreButton.hidden = YES;
	
	[self.banker restorePurchases];
}

#pragma mark - ASBankerDelegate

// Required

- (void)bankerFailedToConnect {
    [self somthingWentWrong];
	[self.activityIndicator stopAnimating];
}

- (void)bankerNoProductsFound {
    [self somthingWentWrong];
	[self.activityIndicator stopAnimating];
}

- (void)bankerFoundProducts:(NSArray *)products {
	[self.activityIndicator stopAnimating];
	self.restoreButton.hidden = NO;
}

- (void)bankerFoundInvalidProducts:(NSArray *)products {
    [self somthingWentWrong];
	[self.activityIndicator stopAnimating];
}

- (void)bankerProvideContent:(SKPaymentTransaction *)paymentTransaction {
    // Unlock feature or content here before for the user.
    
    // TODO:
    if ([paymentTransaction.payment.productIdentifier isEqualToString:@"com.awaraistudios.testapp.upgrade"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"InAppPurchase"];
        [defaults synchronize];
    }
    
}

- (void)bankerPurchaseComplete:(SKPaymentTransaction *)paymentTransaction {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.purchased-in-app-purchase", @"Install Finished")
                                                 message:NSLocalizedString(@"alert.message.thanks", @"Thanks for your support, we hope you enjoy using our app.")
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"alert.button.ok", @"OK")
                                       otherButtonTitles:nil];
	[av show];
    
    [self.activityIndicator stopAnimating];
    self.restoreButton.hidden = NO;
}

- (void)bankerPurchaseFailed:(NSString *)productIdentifier withError:(NSString *)errorDescription {
    [self somthingWentWrong];
	[self.activityIndicator stopAnimating];
	self.restoreButton.hidden = NO;
}

- (void)bankerPurchaseCancelledByUser:(NSString *)productIdentifier {
    [self.activityIndicator stopAnimating];
	self.restoreButton.hidden = NO;
}

- (void)bankerFailedRestorePurchases {
    [self.activityIndicator stopAnimating];
	self.restoreButton.hidden = NO;
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
    NSLog(@"Download progress = %f", download.progress);
    NSLog(@"Download time = %f", download.timeRemaining);
}

@end
