//
//  RecorderHelper.h
//  RecordDemo
//
//  Created by baj on 15/10/31.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MeterTable.h"
typedef void(^StopRecordSuccessBlock)(void);
typedef void(^CompletionCopyBlock)(BOOL,id);

@interface RecorderHelper : NSObject

@property (nonatomic,copy) StopRecordSuccessBlock stopRecordSuccessBlock;
@property (nonatomic,copy) CompletionCopyBlock completionCopy;


//录音方法
- (BOOL) record;

//停止方法
- (void) stopWithCompletionSuccessBlock:(StopRecordSuccessBlock)stop;

//暂停方法.
- (void) pause;


- (void)saveRecordingWithName :(NSString *) name withCompletionBlock:(CompletionCopyBlock)block;

- (void) playRecord :(NSURL *)url;

- (NSString *) formmatTimerString;

- (float) level ;

@end
