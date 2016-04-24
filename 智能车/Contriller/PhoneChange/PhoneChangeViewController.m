//
//  PhoneChangeViewController.m
//  
//
//  Created by user on 15/11/26.
//
//

#import "PhoneChangeViewController.h"
#import "PullCenterModel.h"

@interface PhoneChangeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (copy, nonatomic) NSMutableArray<NSString *> *phoneArray;
@property (weak, nonatomic) IBOutlet UITextField *matchTestField;
@property (strong, nonatomic) IBOutlet UIButton *matchButton;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UITableView *phoneList;

@end

@implementation PhoneChangeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _phoneList.dataSource = self;
    _phoneList.delegate = self;
    [_phoneList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _phoneList.layer.borderWidth = 1;
    _phoneList.layer.borderColor = [UIColor blueColor].CGColor;
    _phoneList.layer.cornerRadius = 5;
    _phoneList.layer.masksToBounds = YES;
    _phoneList.contentSize = CGSizeMake(0, 0);
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [_phoneList setTableHeaderView:view];
    
    UIView *footerView = [[UIView   alloc] initWithFrame:CGRectMake(0, 10, 20, 40)];
    //footerView.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 10, 20)];
    label.text = @"<< 左滑删除号码";
    label.font = [UIFont fontWithName:@"AmericanTypewriter" size:12];
    label.tintColor = [UIColor grayColor];
    label.alpha = 0.3;
    [label sizeToFit];
    CGSize labelSize = label.frame.size;
    
    //label.backgroundColor = [UIColor redColor];
    [footerView addSubview:label];
    [_phoneList setTableFooterView:footerView];
    [label setFrame:CGRectMake([_phoneList contentSize].width-labelSize.width-10, 10, labelSize.width, labelSize.height)];
    
    //NSLog(@"%f-%@",_phoneList.frame.size.width,NSStringFromCGPoint(footerView.center));
    
    //_phoneList.tableFooterView.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"手机管理";
    [_matchButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_matchButton setEnabled:NO];
    [_matchButton setAlpha:0.6];
    NSString *allPhoneString = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUserDefaultPhoneString];
    _phoneArray = [[NSMutableArray alloc] initWithArray:[allPhoneString componentsSeparatedByString:@"#"]];
    [_phoneArray removeObjectAtIndex:0];
    [_phoneList reloadData];
    //self.phoneArray = @[@"18883867540",@"11111111111"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchMatchButton:(UIButton *)sender {
    NSLog(@"添加");
    if (_phoneArray.count>=3) {
        _warningLabel.text = @"绑定设备号已满,请先删除!";
        _warningLabel.textColor = [UIColor redColor];
        return;
    }
    
    NSString *addPhone = [_matchTestField text];
    PullCenterModel *pullCenter = [PullCenterModel sharePullCenter];
    __weak PhoneChangeViewController *weakSelf = self;
    [pullCenter setCompleteBlock:^(BOOL isSuccess){
            NSString *allPhoneString = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUserDefaultPhoneString];
        
            NSMutableArray *phoneArray = [[NSMutableArray alloc] initWithArray:[allPhoneString componentsSeparatedByString:@"#"]];
            [phoneArray removeObjectAtIndex:0];
            weakSelf.phoneArray = [phoneArray mutableCopy];
            [weakSelf.phoneList reloadData];

    }];
    [pullCenter addPullEvent:YCLCarEventAddPhone forView:self.view userInfo:@[addPhone]];
    
}

- (IBAction)isAllowable:(UITextField *)sender {

    if (sender.text.length!=11) {
        _warningLabel.text = @"绑定设备号应为11位!";
        _warningLabel.textColor = [UIColor redColor];
        [_matchButton setEnabled:NO];
        [_matchButton setAlpha:0.6];
    }else{
        _warningLabel.textColor = [UIColor greenColor];
        _warningLabel.text = @"设备号合格!";
        [_matchButton setEnabled:YES];
        [_matchButton setAlpha:1.0];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_matchTestField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --
#pragma mark tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    cell.textLabel.text = self.phoneArray[indexPath.row];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.phoneArray.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
  
        // Delete the row from the data source.
        PullCenterModel *pullCenter = [PullCenterModel sharePullCenter];
        NSString *deletePhone = [_phoneList cellForRowAtIndexPath:indexPath].textLabel.text;
        
        [pullCenter addPullEvent:YCLCarEventDeletePhone forView:self.view userInfo:@[deletePhone]];
        __weak PhoneChangeViewController *weakSelf = self;
        
        [pullCenter setCompleteBlock:^(BOOL isSuccess){
            NSString *allPhoneString = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUserDefaultPhoneString];
            
            NSMutableArray *phoneArray = [[NSMutableArray alloc] initWithArray:[allPhoneString componentsSeparatedByString:@"#"]];
            [phoneArray removeObjectAtIndex:0];
            weakSelf.phoneArray = [phoneArray mutableCopy];
            [weakSelf.phoneList reloadData];
        }];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
