//
//  Record.m
//  RecordDemo
//
//  Created by baj on 15/10/31.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "Record.h"

@implementation Record

- (instancetype) initWithTitle:(NSString *)title withUrl:(NSURL *)url {
    if (self = [super init]) {
        _title = title;
        _url = url;
    }
    return self;
}
@end
