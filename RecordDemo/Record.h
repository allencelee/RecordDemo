//
//  Record.h
//  RecordDemo
//
//  Created by baj on 15/10/31.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSURL * url;

- (instancetype) initWithTitle:(NSString *)title withUrl:(NSURL *)url;

@end
