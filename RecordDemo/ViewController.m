//
//  ViewController.m
//  RecordDemo
//
//  Created by baj on 15/10/31.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "ViewController.h"
#import "RecorderHelper.h"
#import "Record.h"
#import "VoiceView.h"
@interface ViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) RecorderHelper *helper;

@property (strong,nonatomic) NSMutableArray *datas;

@property (weak, nonatomic) IBOutlet VoiceView *voiceView;

@property (strong,nonatomic) NSTimer *timer;


@property (strong,nonatomic) CADisplayLink *leverTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    [self.storyboard instantiateViewControllerWithIdentifier:@"UserVC"];
    NSLog(@"home path is %@",NSHomeDirectory());
    [super viewDidLoad];
    [self initViews];
}

- (void) initViews{
    [self.recordButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
    self.stopButton.enabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"recordCell"];
    _helper = [[RecorderHelper alloc] init];
    _datas = [NSMutableArray array];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Record *record = _datas[indexPath.row];
    [_helper playRecord:record.url];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //数据源中 装载 Record 对象
    Record *record = _datas[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell" forIndexPath:indexPath];
    cell.textLabel.text = record.title;
    return cell;
}


- (void) startTimer {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updateTimerText) userInfo:nil repeats:YES];
}

- (void) updateTimerText {
    self.timerLabel.text = self.helper.formmatTimerString;
}

- (void) stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)recordAction:(id)sender {
    self.stopButton.enabled = YES;
    if (![sender isSelected]) {
        //更新时间lebal
        [self startTimer];
        [self startDLinkTimer];
        //要录音.
        [_helper record];
    }else{
        [self stopTimer];
        //要暂停
        [_helper pause];
        [self stopDLinkTimer];
    }
    self.recordButton.selected = !self.recordButton.selected;
}

- (IBAction)stopAction:(id)sender {
    self.recordButton.selected = !self.recordButton.selected;
    [self stopTimer];
    [self stopDLinkTimer];
    [_helper stopWithCompletionSuccessBlock:^{
       //弹出输入名字的提示框
        [self showSaveMessage];
    }];
}



- (void) startDLinkTimer {
//    CADisplayLink //NSTimer 1秒60
    [self.leverTimer invalidate];
    self.leverTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    self.leverTimer.frameInterval = 5;
    [self.leverTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}
- (void) stopDLinkTimer {
    [self.leverTimer invalidate];
    self.leverTimer = nil;
    [self.voiceView resetLevel];
}

- (void) updateMeters {
    CGFloat level = [self.helper level];
    self.voiceView.level = level;
    [self.voiceView setNeedsDisplay];
}

- (void) showSaveMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存录音" message:@"输入名字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark UIALERTVIEW DELEGAGTE
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //拿到输入的名字
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (textField.text == nil || [textField.text isEqualToString:@""]) {
            return;
        }
        //保存录音
        NSString *recordName = textField.text;
        [_helper saveRecordingWithName:recordName withCompletionBlock:^(BOOL success, id result) {
           //拷贝成功之后要进行回掉处理
            if (success) {
                //更新
                [_datas addObject:result];
                [_tableView reloadData];
                self.timerLabel.text = @"00:00:00";
            }
        }];
    }
}

@end
