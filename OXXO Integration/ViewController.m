//
//  ViewController.m
//  OXXO Integration
//
//  Created by Cameron Sabol on 7/13/20.
//  Copyright © 2020 Stripe. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

#warning("Please use your own backend url below")
static NSString * const kBackendURL = @"";

@interface ViewController () {
    UITextView *_outputTextView;
    
    UITextField *_nameField;
    UITextField *_emailField;
    
    UIActivityIndicatorView *_spinner;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"OXXO iOS Demo";
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];
    
    _nameField = [[UITextField alloc] init];
    _nameField.textContentType = UITextContentTypeName;
    _nameField.borderStyle = UITextBorderStyleLine;
    _nameField.placeholder = @"Full Name";
    _nameField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_nameField];
    
    _emailField = [[UITextField alloc] init];
    _emailField.textContentType = UITextContentTypeEmailAddress;
    _emailField.borderStyle = UITextBorderStyleLine;
    _emailField.placeholder = @"Email";
    _emailField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_emailField];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [payButton setTitle:@"Submit Payment" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.backgroundColor = [UIColor colorWithRed:50.f/255.f green:50.f/255.f blue:93.f/255.f alpha:1.f];
    payButton.contentEdgeInsets = UIEdgeInsetsMake(4.f, 6.f, 4.f, 6.f);
    payButton.layer.cornerRadius = 5.f;
    [payButton addTarget:self action:@selector(_pay) forControlEvents:UIControlEventTouchUpInside];
    payButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:payButton];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    _spinner.color = [UIColor darkGrayColor];
    _spinner.hidden = YES;
    _spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_spinner];
    
    _outputTextView = [[UITextView alloc] init];
    _outputTextView.editable = NO;
    _outputTextView.layer.borderColor = [UIColor purpleColor].CGColor;
    _outputTextView.layer.borderWidth = 1.f;
    _outputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_outputTextView];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToSystemSpacingBelowAnchor:self.view.safeAreaLayoutGuide.topAnchor multiplier:1.f],
        [titleLabel.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [titleLabel.leadingAnchor constraintGreaterThanOrEqualToSystemSpacingAfterAnchor:self.view.safeAreaLayoutGuide.leadingAnchor multiplier:1.f],
        [self.view.safeAreaLayoutGuide.trailingAnchor constraintGreaterThanOrEqualToSystemSpacingAfterAnchor:titleLabel.trailingAnchor multiplier:1.f],
        
        [_nameField.topAnchor constraintEqualToSystemSpacingBelowAnchor:titleLabel.bottomAnchor multiplier:4.f],
        [_nameField.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.layoutMarginsGuide.leadingAnchor multiplier:1.f],
        [self.view.layoutMarginsGuide.trailingAnchor constraintEqualToSystemSpacingAfterAnchor:_nameField.trailingAnchor multiplier:1.f],
        
        [_emailField.topAnchor constraintEqualToSystemSpacingBelowAnchor:_nameField.bottomAnchor multiplier:1.f],
        [_emailField.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.layoutMarginsGuide.leadingAnchor multiplier:1.f],
        [self.view.layoutMarginsGuide.trailingAnchor constraintEqualToSystemSpacingAfterAnchor:_emailField.trailingAnchor multiplier:1.f],

        [payButton.topAnchor constraintEqualToSystemSpacingBelowAnchor:_emailField.bottomAnchor multiplier:2.f],
        [payButton.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [payButton.leadingAnchor constraintGreaterThanOrEqualToSystemSpacingAfterAnchor:self.view.safeAreaLayoutGuide.leadingAnchor multiplier:1.f],
        [self.view.safeAreaLayoutGuide.trailingAnchor constraintGreaterThanOrEqualToSystemSpacingAfterAnchor:payButton.trailingAnchor multiplier:1.f],
        
        [_spinner.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [_spinner.topAnchor constraintEqualToSystemSpacingBelowAnchor:payButton.bottomAnchor multiplier:4.f],
        
        [self.view.layoutMarginsGuide.bottomAnchor constraintEqualToSystemSpacingBelowAnchor:_outputTextView.bottomAnchor multiplier:8.f],
        [_outputTextView.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.layoutMarginsGuide.leadingAnchor multiplier:1.f],
        [self.view.layoutMarginsGuide.trailingAnchor constraintEqualToSystemSpacingAfterAnchor:_outputTextView.trailingAnchor multiplier:1.f],
        [_outputTextView.topAnchor constraintEqualToSystemSpacingBelowAnchor:_spinner.bottomAnchor multiplier:4.f],
    ]];
    
}

- (void)_setLoading:(BOOL)isLoading {
    if (isLoading) {
        [_spinner startAnimating];
        _spinner.hidden = NO;
    } else {
        [_spinner stopAnimating];
        _spinner.hidden = YES;
    }
}

- (void)_logMessage:(NSString *)message {
    NSString *loggedMessages = _outputTextView.text ?: @"";
    [_outputTextView setText:[loggedMessages stringByAppendingFormat:@"%@\n", message]];
    [_outputTextView scrollRangeToVisible:[_outputTextView.text rangeOfString:message options:NSBackwardsSearch]];
}

- (void)_pay {
    [self _setLoading:YES];
    
    // 1) [server-side] Create a PaymentIntent
    [self _logMessage:@"Creating PaymentIntent"];
    
    // 2) [client-side] Confirm the PaymentIntent
}


@end

NS_ASSUME_NONNULL_END
