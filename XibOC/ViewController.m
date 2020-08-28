//
//  ViewController.m
//  XibOC
//
//  Created by 施峰磊 on 2020/2/29.
//  Copyright © 2020 施峰磊. All rights reserved.
//

#import "ViewController.h"
#import "XibCategory.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField.maxLength = 0;
    self.textField.maxLength = 0;
    
    self.textField.maxLength = 4;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.button.enabled = false;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.button.enabled = true;
    });
}


@end
