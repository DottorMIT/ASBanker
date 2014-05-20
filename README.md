ASBanker
========

Simplifies adding In App Purchases to iOS applications. Create a Banker, set its delegate and pass an array of your In App Purchase products to it, easy! The Banker handles the rest including storing the transactions and handling errors. 

Preparing for In App Purchases
-----

**Important**

You will need to create an In App Purchase product for your app in iTunes Connect.

For a detailed tutorial on prepaing your app for In App Purchases, click [here](http://www.techotopia.com/index.php/Preparing_an_iOS_7_Application_for_In-App_Purchases) 

Installation
-----

**Installing with [CocoaPods](http://cocoapods.org)**

If you're unfamiliar with CocoaPods there is a great tutorial [here](http://www.raywenderlich.com/12139/introduction-to-cocoapods) to get you up to speed.

1. In Terminal navigate to the root of your project.
2. Run 'touch Podfile' to create the Podfile.
3. Open the Podfile using 'open -e Podfile'
4. Add the pod `ASBanker` to your [Podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile).

    	platform :ios
    	pod ASBanker'

5. Run `pod install`.
6. Open your app's `.xcworkspace` file to launch Xcode and start adding In App Purchases!

**Installing manually from GitHub**

1.	Download the `ASBanker.h` and `ASBanker.m` files and add them to your Xcode project.
2.	`#import ASBanker.h` wherever you need it.
3	Add the 'StoreKit.framework' to your project.
4.	Follow the included sample project to get started changing the products array for your product in iTunes Connect in 'ViewController.m'.

**Running the sample project**

Check out the [sample project](https://github.com/AwaraiStudios/ASBanker/tree/master/Sample%20Project) included in the repository. Open the '.xcodeproj' file in the Sample Project folder and the project should build correctly.

Configuration
========

To run the Sample Project with your own In App Purchases you'll need to change a few things:

1.  Set the Bundle Identifier and the Team for the project in Xcode. Image 1
2.  Chnage the Product Identifiers to your own. In the Sample Project these are in Constants.m and used in ProductTableViewController.m. Image 2

![](/Images/Bundle-Identifier.png?raw=true "Image 1")

![](/Images/Product-Identifiers.png?raw=true "Image 2")

Licence
-------

Distributed under the MIT License.

Credits
-------

This work is based on the original work of Paul Hudson, with permission.
