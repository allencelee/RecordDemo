//
//  RecorderHelper.m
//  RecordDemo
//
//  Created by baj on 15/10/31.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "RecorderHelper.h"
#import "Record.h"
@interface RecorderHelper()<AVAudioRecorderDelegate>
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;
//声音大小转换类
@property (nonatomic,strong) MeterTable *meterTable;
@end


@implementation RecorderHelper

- (instancetype) init {
    if (self = [super init]) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record.caf"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        
        NSDictionary *options = @{
                                  AVFormatIDKey : @(kAudioFormatAppleIMA4),
                                  AVSampleRateKey : @44100.0f,
                                  AVNumberOfChannelsKey : @1,
                                  AVEncoderBitDepthHintKey : @16,
                                  AVEncoderAudioQualityKey : @(AVAudioQualityMedium)
                                  };
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:options error:nil];
        
        if (_recorder) {
            _recorder.delegate = self;
            //开启监听声音的属性.
            _recorder.meteringEnabled = YES;
            [_recorder prepareToRecord];
        }
        _meterTable = [[MeterTable alloc] init];
    }
    return self;
}

//录音
- (BOOL) record {
  return [self.recorder record];
}

//录音暂停
- (void)pause{
    [self.recorder pause];
}
//录音停止.
- (void) stopWithCompletionSuccessBlock:(StopRecordSuccessBlock)stop{
    
    self.stopRecordSuccessBlock = stop;
    
    
    [self.recorder stop];
}
//将录好的音频保存到自定义的路径上
- (void)saveRecordingWithName :(NSString *) name withCompletionBlock:(CompletionCopyBlock)block{
    //保存copy
    //如果成功
//    block(YES,/*保存的数据*/)
//    如果失败
//    block(NO,error);
    NSTimeInterval timeStamp = [NSDate timeIntervalSinceReferenceDate];
    NSString *fileName = [NSString stringWithFormat:@"%@-%f.m4a",name,timeStamp];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"records"];
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:filePath]) {
        if (![manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return;
        }
    }
    
    filePath = [filePath stringByAppendingPathComponent:fileName];
    
    NSURL *descUrl = [NSURL fileURLWithPath:filePath];
    
    NSURL *srcUrl = _recorder.url;
    
    //复制操作
    if ([manager copyItemAtURL:srcUrl toURL:descUrl error:nil]) {
        //保存成功
        [_recorder prepareToRecord];
        block(YES,[[Record alloc] initWithTitle:name withUrl:descUrl]);
    }else{
        //保存失败
        block(NO,nil);
    }
}

- (void) playRecord :(NSURL *)url {
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    if (self.player) {
        [self.player prepareToPlay];

        [self.player play];
        self.player.volume = 1;
    }
}


//代理方法,结束录音的时候调用.
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (self.stopRecordSuccessBlock) {
        self.stopRecordSuccessBlock();
    }
}


- (NSString *) formmatTimerString {
    
    NSInteger time = self.recorder.currentTime;
    NSInteger hours = time / 3600;
    NSInteger minutes = (time / 60) % 60;
    NSInteger seconds = time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours,minutes,seconds];

}
//获取声音的大小
- (float) level {
    
    
    [self.recorder updateMeters];//每次调用此方法来更新当前的音量.
    //获取当前声道的音量大小.
    float avgPower = [self.recorder averagePowerForChannel:0];
    
    float lineLevel = [self.meterTable valueForPower:avgPower];
    
    NSLog(@"lineLevel is %f",lineLevel);
    
    return lineLevel;
}



@end
