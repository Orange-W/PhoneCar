//
//  FastTestViewController.m
//  智能车
//
//  Created by user on 15/11/5.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "FastTestViewController.h"
#import "PullCenterModel.h"
#import <MYIntroductionView.h>

@interface FastTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *changePhoneButton;
@property (weak, nonatomic) IBOutlet UILabel *showPhoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *unlockButton;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;


@property (copy, nonatomic) NSString *nowPhone;
@property (copy, nonatomic) NSString *showReturn;

@property (weak, nonatomic)PullCenterModel *pullCenter;
@end

@implementation FastTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pullCenter = [PullCenterModel sharePullCenter];
    _pullCenter.localViewController = self;
    
    
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.mode = MBProgressHUDModeAnnularDeterminate;
//    HUD.delegate = self;
//    HUD.labelText = @"Loading";
//    [HUD showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:nil animated:YES];
    
   
//    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
//    HUD.labelText = @"请求中";
//    HUD.detailsLabelText = @"剩余时间(60s)";
//    HUD.dimBackground = YES;
//    HUD.graceTime =1;
//    HUD.removeFromSuperViewOnHide = NO;
//    [_pullCenter unlockModel].progressView = self.view;
//    [HUD hide:NO];
//    [HUD show:YES];
    
    
    [self.openButton addTarget:self action:@selector(openAir:) forControlEvents:UIControlEventTouchDown];
    [self.closeButton addTarget:self action:@selector(closeAir:) forControlEvents:UIControlEventTouchDown];
    [self.unlockButton addTarget:self action:@selector(unlockCar:) forControlEvents:UIControlEventTouchDown];
    [self.lockButton addTarget:self action:@selector(lockCar:) forControlEvents:UIControlEventTouchDown];
    
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.changePhoneButton addTarget:self action:@selector(resetPhone) forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _showPhoneLabel.text = [NSString stringWithFormat:@"当前绑定:%@",_pullCenter.pullPhone];
    _pullCenter = [PullCenterModel sharePullCenter];
    
    //读取沙盒数据
//    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
//    NSString *key1 = [NSString stringWithFormat:@"isFirstLaunch"];
//    BOOL value = [settings1 boolForKey:key1];
//    if (!value)  //如果没有数据
//    {
        //STEP 1 Construct Panels
//        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"default.jpg"] title:@"第一步" description:@"欢迎使用益车利,使用前请先匹配您的设备号"];
//        
//        //You may also add in a title for each panel
//        MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"indexbc.png"] title:@"第二步" description:@"为您的 app 设定开启密码"];
//        /*A more customized version*/
//        MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerText:@"初始化设置" panels:@[panel, panel2] languageDirection:MYLanguageDirectionLeftToRight];
//        [introductionView setBackgroundImage:[UIImage imageNamed:@"112.png"]];
//        [UIImage imageNamed:@]
//
//        
//        //STEP 3: Show introduction view
//        [introductionView showInView:self.view animateDuration:1];

        //写入数据
//        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
//        NSString * key = [NSString stringWithFormat:@"isFirstLaunch"];
//        [setting setBool:YES forKey:key];
//        [setting synchronize];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)nowPhone{
    if(!_nowPhone){
        _nowPhone = kTestPhone;
    }
    
    return _nowPhone;
}

- (void) openAir:(UIButton *)button{
    [_pullCenter addPullEvent:YCLCarEventOpenAir forView:self.view];
    NSLog(@"在开空调\n");
}

- (void) closeAir:(UIButton *)button{
    [_pullCenter addPullEvent:YCLCarEventCloseAir forView:self.view];
    NSLog(@"在关空调\n");
}

- (void) lockCar:(UIButton *)button{
    [_pullCenter addPullEvent:YCLCarEventLock forView:self.view];
    NSLog(@"在锁车\n");
}

- (void) unlockCar:(UIButton *)button{
    [_pullCenter addPullEvent:YCLCarEventUnlock forView:self.view];
    NSLog(@"在开锁\n");
}

- (void)resetPhone{
    if (_phoneTextField.text.length!=11) {
        _showPhoneLabel.text = @"绑定号码必须为11位手机!";
    }else{
        
        _showPhoneLabel.text = [NSString stringWithFormat:@"改绑成功:%@",_phoneTextField.text];
        _pullCenter.pullPhone = [_phoneTextField.text mutableCopy];
        _phoneTextField.text = @"";
        [[NSUserDefaults standardUserDefaults] setObject:_pullCenter.pullPhone forKey:@"pullPhone"];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_phoneTextField resignFirstResponder];
}




@end
