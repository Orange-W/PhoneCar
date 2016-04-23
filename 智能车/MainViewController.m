//
//  ViewController.m
//  智能车
//
//  Created by user on 15/11/2.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "MainViewController.h"
#import "PullCenterModel.h"

@interface MainViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollowView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_pageControl.currentPage) {
        _titleLabel.text = @"益车利支持多种使用场景";
    }else{
        _titleLabel.text = @"益车利,你的最佳选择";
    }
    
    _scrollowView.delegate = self;
    _scrollowView.contentSize = (CGSize){kSizeMainScreenWdth*2,0};
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kSizeMainScreenWdth,_scrollowView.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"slider.png"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(kSizeMainScreenWdth, 0,kSizeMainScreenWdth,_scrollowView.frame.size.height)];
    imageView2.image = [UIImage imageNamed:@"slider_control.png"];
    imageView.center = (CGPoint){imageView.center.x,imageView.center.y-20};
    
    [_scrollowView addSubview:imageView];
    [_scrollowView addSubview:imageView2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(IS_IPHONE_6){
        for(int i=1;i<=9;i++){
            UIButton *myButton = (UIButton *)[self.view viewWithTag:i];
            //        CGFloat buttomEdge = myButton.titleEdgeInsets.bottom;
            NSInteger buttonLabelTextLength = myButton.titleLabel.text.length;
            CGFloat rate = kSizeMainScreenWdth/320;
            
            myButton.titleEdgeInsets =
            (UIEdgeInsets){0,0,-40*rate*1.6,myButton.frame.size.width-30+(buttonLabelTextLength-3)*rate*6};
        }
    }else if (IS_IPHONE_4_OR_LESS){
        for(int i=1;i<=9;i++){
            UIButton *myButton = (UIButton *)[self.view viewWithTag:i];
            //        CGFloat buttomEdge = myButton.titleEdgeInsets.bottom;
            NSInteger buttonLabelTextLength = myButton.titleLabel.text.length;
//            CGFloat rate = kSizeMainScreenWdth/320;
            
            myButton.titleEdgeInsets =
            (UIEdgeInsets){0,0,-50,78-(4-buttonLabelTextLength)*9.5};
        }
    }else if (IS_IPHONE_5){
        for(int i=1;i<=9;i++){
            UIButton *myButton = (UIButton *)[self.view viewWithTag:i];
            //        CGFloat buttomEdge = myButton.titleEdgeInsets.bottom;
            NSInteger buttonLabelTextLength = myButton.titleLabel.text.length;
//            CGFloat rate = kSizeMainScreenWdth/320;
            
            myButton.titleEdgeInsets =
            (UIEdgeInsets){0,0,-65,86-(4-buttonLabelTextLength)*9.2};
        }
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  _pageControl.currentPage = scrollView.contentOffset.x >= kSizeMainScreenWdth?1:0;
    if (_pageControl.currentPage) {
        _titleLabel.text = @"益车利支持多种使用场景";
    }else{
        _titleLabel.text = @"益车利,你的最佳选择";
    }
    
}

- (IBAction)clickOnButton:(UIButton *)sender forEvent:(UIEvent *)event {
    NSInteger tag = sender.tag;
    YCLPullEvent pullEvent = 0;
    switch (tag) {
        case 1:
            pullEvent = YCLCarEventOpenAir;
            break;
        case 2:
            pullEvent = YCLCarEventCloseAir;
            break;
        case 3:
            pullEvent = YCLCarEventLock;
            break;
        case 4:
            pullEvent = YCLCarEventUnlock;
            break;
        case 5:
            pullEvent = YCLCarEventCarSituation;
            break;
        case 6:
            pullEvent = YCLCarEventFindCarOutside;
            break;
        case 7:
            pullEvent = YCLCarEventFindCarSilence;
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        default:
            break;
    }
    [[PullCenterModel sharePullCenter] addPullEvent:pullEvent forView:self.view];
}


@end
