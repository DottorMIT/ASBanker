//
//  ProductViewController.m
//  Sample Project
//
//  Created by Ross Gibson on 17/05/2014.
//  Copyright (c) 2014 Awarai Studios Limited. All rights reserved.
//

#import "ProductViewController.h"

#import "Constants.h"

@interface ProductViewController () <ASBankerDelegate>

@property (strong, nonatomic) ASBanker *banker;

@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UITextView *productDescription;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ProductViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.productTitle.text = self.product.localizedTitle;
    self.productDescription.text = self.product.localizedDescription;
    self.productImage.image = [UIImage imageNamed:kImageDummyIcon];
    [self.purchaseButton setTitle:self.product.localizedPrice forState:UIControlStateNormal];
    
    self.banker = [ASBanker sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.banker) {
        self.banker.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)purchaseButtonTapped:(id)sender {
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.purchaseButton.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self.activityIndicator startAnimating];
                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                     }
     ];
    
    [self.banker purchaseItem:self.product];
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
    [self.activityIndicator stopAnimating];
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.purchaseButton.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
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
}

- (void)bankerFoundInvalidProducts:(NSArray *)products {
    [self somthingWentWrong];
	[self stopActivityIndicators];
}

- (void)bankerProvideContent:(SKPaymentTransaction *)paymentTransaction {
    // Unlock feature or content here for the user.
    if ([paymentTransaction.payment.productIdentifier isEqualToString:self.product.productIdentifier]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:self.product.productIdentifier];
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
