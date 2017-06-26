//
//  XTAboutOursViewController.m
//  tian
//
//  Created by yyt on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAboutOursViewController.h"
#import "XTAboutOursSeverViewController.h"
@interface XTAboutOursViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)buttonClicked:(id)sender;
@end

@implementation XTAboutOursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"%@%@",name,version];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonClicked:(id)sender {
    XTAboutOursSeverViewController *aboutTwoVC = [[XTAboutOursSeverViewController alloc]init];
    [self.navigationController pushViewController:aboutTwoVC animated:YES];
}
@end
