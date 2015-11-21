//
//  VoiceView.m
//  RecordDemo
//
//  Created by baj on 15/10/31.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "VoiceView.h"
@interface VoiceView()
@property (nonatomic,strong) NSArray *colors;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) NSInteger ledCount;
@end
@implementation VoiceView

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupView];
    }
    return self;
}

- (void) setupView{
    self.backgroundColor = [UIColor clearColor];
    
    UIColor *greenColor = [UIColor greenColor];
    UIColor *yelloColor = [UIColor yellowColor];
    UIColor *redColor = [UIColor redColor];
    self.colors = @[greenColor,yelloColor,redColor];
    
    _ledCount = 20;
    
    _width = CGRectGetWidth(self.frame) / _ledCount;
}
/**
如果音量满格 则分为20个小矩形.
 6个绿色,6个黄色,8个红色
 平均音量 0-0.3 ---显示绿色
        0.3-0.6 ---显示绿色,黄色
        0.6-1  绿色,黄色,红色
 */

- (void) drawRect:(CGRect)rect {
    if (self.level > 0.6 && self.level <= 1) {
         int reds = (int)((self.level - 0.6) / 0.4 * 8);
        for (int index = 0; index < (6 + 6 + reds - 1); index++) {
            CGRect frame = (CGRect){index * _width,0,_width,CGRectGetHeight(rect)};
            if (index < 6) {
                [self createRect:frame withColor:_colors[0]];
            }else if(index < 12){
                [self createRect:frame withColor:_colors[1]];
            }else{
                [self createRect:frame withColor:_colors[2]];
            }
        }
        //0.6-1  绿色,黄色,红色
    }else if(self.level > 0.3 && self.level <= 0.6){
        //0.3-0.6 ---显示绿色,黄色
        int yellows = (int)((self.level - 0.3) / 0.3 * 6);
        for (int index = 0; index < (6 + yellows - 1); index++) {
            CGRect frame = (CGRect){index * _width,0,_width,CGRectGetHeight(rect)};
            if (index < 6) {
                [self createRect:frame withColor:_colors[0]];
            }else if(index < 12){
                [self createRect:frame withColor:_colors[1]];
            }
        }

    }else if(self.level >= 0 && self.level <= 0.3){
        //0-0.3 ---显示绿色
        int greens = (int)(self.level / 0.3 * 6);
        for (int index = 0; index < (greens - 1); index++) {
            CGRect frame = (CGRect){index * _width,0,_width,CGRectGetHeight(rect)};
            [self createRect:frame withColor:_colors[0]];
        }

    }
}
- (void) createRect:(CGRect) rect withColor:(UIColor *)color {
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectInset(rect, 1.5, 0)];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1.5, 0) cornerRadius:3];
    
    [color setFill];
    [path fill];
}


- (void) resetLevel {
    self.level = 0;
    [self setNeedsDisplay];
}











@end
