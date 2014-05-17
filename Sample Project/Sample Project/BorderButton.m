//
//  BorderButton.m
//  Sample Project
//
//  Created by Ross Gibson on 17/05/2014.
//  Copyright (c) 2014 Awarai Studios Limited. All rights reserved.
//

#import "BorderButton.h"

#import "UIColor+ios7.h"

@implementation BorderButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tintColor = [UIColor ios7BlueColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.tintColor = [UIColor ios7BlueColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CALayer *button = [self layer];
    [button setMasksToBounds:YES];
    [button setCornerRadius:4.0f];
    [button setBorderWidth:1.0f];
    [button setBorderColor:[[UIColor ios7BlueColor] CGColor]];
}

@end
