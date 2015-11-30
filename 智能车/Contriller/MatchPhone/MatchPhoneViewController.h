//
//  MatchPhoneViewController.h
//  YCLCar
//
//  Created by user on 15/11/14.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YCLMatchMode) {
    YCLMatchPhone = 0,
    YCLMatchAuthKey,
};

@interface MatchPhoneViewController : UIViewController <UITextFieldDelegate>
@property (assign, nonatomic) YCLMatchMode matchMode;
@property (weak, nonatomic) IBOutlet UITextField *matchTestField;
@property (weak, nonatomic) IBOutlet UIButton *matchButton;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@end
