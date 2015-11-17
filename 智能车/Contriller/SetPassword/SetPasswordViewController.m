//
//  SetPasswordViewController.m
//  YCLCar
//
//  Created by user on 15/11/15.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "SetPasswordViewController.h"

@interface SetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;

@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatPasswordLabel;
@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField.delegate = self;
    
    self.repeatPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.repeatPasswordTextField.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)setPassword:(UIButton *)sender {
    if (_passwordTextField.text.length <6) {
        _passwordLabel.text = @"请设置至少6位密码!";
        return ;
    }
    if (![_passwordTextField.text isEqualToString:_repeatPasswordTextField.text] ) {
        _repeatPasswordLabel.text = @"两次密码不一致";
        return ;
    }
    
    _passwordLabel.text = @"";
    _repeatPasswordLabel.text = @"密码合法";
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:1];
    [HUD setLabelText:@"设置成功"];
    [HUD setRemoveFromSuperViewOnHide:YES];
    [HUD hide:YES afterDelay:2];
    [[NSUserDefaults standardUserDefaults] setObject:_repeatPasswordLabel.text forKey:kApplicationUserDefaultKeyPassword];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kPasswordNumberSet] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
