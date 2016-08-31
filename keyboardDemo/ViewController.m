//
//  ViewController.m
//  keyboardDemo
//
//  Created by chang on 16/8/31.
//  Copyright © 2016年 chang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    float _keyBoardHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];

}

-(void)viewDidDisappear:(BOOL)animated{

    // 记得一定要注销通知监听，否则有时会导致crash
    // 比如内存中两个类均收到通知，然后他们都想执行跳转,这个时候就crash了
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * indentifier = [NSString stringWithFormat:@"Cell%zi%zi",indexPath.row,indexPath.section];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField * txtField = [[UITextField alloc] initWithFrame:CGRectMake(50, 12, cell.frame.size.width-100, 20)];
        txtField.delegate = self;
        txtField.placeholder = @"请输入内容";
        txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell.contentView addSubview:txtField];
        
    }
    return cell;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _keyBoardHeight = keyboardSize.height;
    [self changeViewYByShow];

}

- (void)keyboardDidHide:(NSNotification *)notification{
    _keyBoardHeight = 0;
    [self changeViewYByHide];
}

#pragma mark - private methods
- (void)changeViewYByShow{
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, _keyBoardHeight, 0);
    /*  这个方法不好用
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y -= _keyBoardHeight;
        self.view.frame = rect;
    }];*/
}

- (void)changeViewYByHide{
    
    //self.tableView.contentOffset = CGPointMake(0, 0);
    self.tableView.contentInset = UIEdgeInsetsZero;
    /* 这个方法不好用
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;*/
}


@end
