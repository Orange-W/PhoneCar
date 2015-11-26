//
//  MatchPhoneViewController.h
//  YCLCar
//
//  Created by user on 15/11/14.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchPhoneViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *matchTestField;
@property (strong, nonatomic) IBOutlet UIView *matchButton;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@end
