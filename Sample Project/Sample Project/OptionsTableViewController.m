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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.banker = [ASBanker sharedInstance];
    self.banker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.activityIndicator startAnimating];
    
	self.restoreButton.hidden = YES;
	
	[self.banker restorePurchases];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ASBankerDelegate

// Required

- (void)bankerFailedToConnect {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", @"Alert view title") message:NSLocalizedString(@"Something went wrong whilst trying to connect to the iTunes Store. Please try again.", @"Alert message") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button title") otherButtonTitles:nil];
	[av show];
	
	[self.activityIndicator stopAnimating];
}

- (void)bankerNoProductsFound {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", @"Alert view title") message:NSLocalizedString(@"Something went wrong whilst trying to connect to the iTunes Store. Please try again.", @"Alert message") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button title") otherButtonTitles:nil];
	[av show];
	
	[self.activityIndicator stopAnimating];
}

- (void)bankerFoundProducts:(NSArray *)products {
	[self.activityIndicator stopAnimating];
	self.restoreButton.hidden = NO;
}

- (void)bankerFoundInvalidProducts:(NSArray *)products {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", @"Alert view title") message:NSLocalizedString(@"Something went wrong whilst trying to connect to the iTunes Store. Please try again.", @"Alert message") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button title") otherButtonTitles:nil];
	[av show];
	
	[self.activityIndicator stopAnimating];
}

- (void)bankerProvideContent:(SKPaymentTransaction *)paymentTransaction {
    // Unlock feature or content here before for the user.
    
    if ([paymentTransaction.payment.productIdentifier isEqualToString:@"com.awaraistudios.testapp.upgrade"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"InAppPurchase"];
        [defaults synchronize];
    }
    
}

- (void)bankerPurchaseComplete:(SKPaymentTransaction *)paymentTransaction {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nice one!", @"Alert view title") message:NSLocalizedString(@"Thanks for your support, we hope you enjoy the app.", @"Alert message") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"Button title") otherButtonTitles:nil];
	[av show];
    
    [self.activityIndicator stopAnimating];
    self.restoreButton.hidden = NO;
}

- (void)bankerPurchaseFailed:(NSString *)productIdentifier withError:(NSString *)errorDescription {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", @"Alert view title") message:NSLocalizedString(@"Something went wrong whilst trying to connect to the iTunes Store. Please try again.", @"Alert message") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button title") otherButtonTitles:nil];
	[av show];
	
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
