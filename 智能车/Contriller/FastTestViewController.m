//
//  FastTestViewController.m
//  智能车
//
//  Created by user on 15/11/5.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "FastTestViewController.h"
#import "PullCenterModel.h"
@interface FastTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *changePhoneButton;
@property (weak, nonatomic) IBOutlet UILabel *showPhoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *unlockButton;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UILabel *showReturnLabel;

@property (strong, nonatomic) NSString *nowPhone;
@property (strong, nonatomic) NSString *showReturn;

@property (strong, nonatomic)PullCenterModel *pullCenter;
@end

@implementation FastTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.mode = MBProgressHUDModeAnnularDeterminate;
//    HUD.delegate = self;
//    HUD.labelText = @"Loading";
//    [HUD showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:nil animated:YES];
    
    _pullCenter = [PullCenterModel sharePullCenter];
    _pullCenter.showReturnLabel = self.showReturnLabel;
    _pullCenter.pullPhone = kTestPhone;
    [_pullCenter pullLoopStart];
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
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_phoneTextField resignFirstResponder];
}




@end
