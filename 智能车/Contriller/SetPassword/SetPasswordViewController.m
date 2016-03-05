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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)setPassword:(UIButton *)sender {
    if (_passwordTextField.text.length <6) {
        _passwordLabel.text = @"密码至少6位";
        return ;
    }
    if (![_passwordTextField.text isEqualToString:_repeatPasswordTextField.text] ) {
        _passwordLabel.text = @"密码不一致";
        return ;
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:1];
    [HUD setLabelText:@"设置成功"];
    [HUD setRemoveFromSuperViewOnHide:YES];
    [HUD hide:YES afterDelay:2];
    [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:kApplicationUserDefaultKeyPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"_passwordTextField:%@",_passwordTextField.text);
    
    UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *loginViewController = [storyBord instantiateViewControllerWithIdentifier:@"LoginNav"];
    [self presentViewController:loginViewController animated:NO completion:nil];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kPasswordNumberSet] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_passwordTextField resignFirstResponder];
    [_repeatPasswordTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
