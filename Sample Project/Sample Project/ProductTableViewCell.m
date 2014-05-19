//
//  ProductTableViewCell.m
//  Sample Project
//
//  Created by Ross Gibson on 17/05/2014.
//  Copyright (c) 2014 Awarai Studios Limited. All rights reserved.
//

#import "ProductTableViewCell.h"

@implementation ProductTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)startAnimating {
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.purchaseButton.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self.activityIndicator startAnimating];
                     }
     ];
}

- (void)stopAnimating {
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.purchaseButton.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [self.activityIndicator stopAnimating];
                     }
     ];
}

@end
