//
//  PhoneChangeViewController.m
//  
//
//  Created by user on 15/11/26.
//
//

#import "PhoneChangeViewController.h"
#import "PullCenterModel.h"

@interface PhoneChangeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *matchTestField;
@property (strong, nonatomic) IBOutlet UIView *matchButton;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@end

@implementation PhoneChangeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_opreationType isEqualToString:@"addPhone"]) {
        
    }else{
       
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchMatchButton:(UIButton *)sender {
    NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    PullCenterModel *pullCenter = [PullCenterModel sharePullCenter];
    number = number?:kTestPhone;
    pullCenter.localViewController = self;
    if(!number){
        NSLog(@"号码不合法");
        MBProgressHUD *HUD = [pullCenter showProgresstoView:self.view];
        HUD.labelText = @"获取手机号失败";
        HUD.detailsLabelText = @"请检查: 设置->电话->本机号码";
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:number forKey:kApplicationUserDefaultKeyPullPhone];
//        [pullCenter addPullEvent:YCLCarEventMatchPhone forView:self.view];
    }
}

- (IBAction)isAllowable:(UITextField *)sender {

    if (sender.text.length!=11) {
        _warningLabel.text = @"绑定设备号应为11位!";
        _warningLabel.textColor = [UIColor redColor];
    }else{
        _warningLabel.textColor = [UIColor greenColor];
        _warningLabel.text = @"设备号合格!";
        [[NSUserDefaults standardUserDefaults] setObject:sender.text forKey:@"pullPhone"];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_matchTestField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
