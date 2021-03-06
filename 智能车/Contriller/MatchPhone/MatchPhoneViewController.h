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
@property (weak, nonatomic) IBOutlet UITextField *nowPhoneTextField;
@property (assign, nonatomic) YCLMatchMode matchMode;
@property (weak, nonatomic) IBOutlet UITextField *matchTextField;
@property (weak, nonatomic) IBOutlet UIButton *matchButton;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
- (void)initViewWithMode:(YCLMatchMode)mode;
@end
