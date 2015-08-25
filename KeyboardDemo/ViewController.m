//
//  ViewController.m
//  KeyboardDemo
//
//  Created by WilliamZhang on 15/8/24.
//  Copyright (c) 2015年 WilliamZhang. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSUInteger, wz_keyboardType) {
    wz_keyboardType1 = 0,
    wz_keyboardType2,
    wz_keyboardType3,
    wz_keyboardType4,
    wz_keyboardType5,
    wz_keyboardType6,
    wz_keyboardType7,
    wz_keyboardType8,
    wz_keyboardType9,
    wz_keyboardType10,
    wz_keyboardType11,
    wz_keyboardType12,
    wz_keyboardType13,
    wz_keyboardType14
};

@interface ViewController ()

@property (nonatomic , strong) NSArray *array;
@property (nonatomic , strong) UIButton *deleteButton;
@property (nonatomic , strong) UIButton *doneButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *lastButton = [self.array firstObject];
    [self.view addSubview:lastButton];
    
    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
    }];
    
    for (UIButton *button in self.array) {
        NSInteger index = [self.array indexOfObject:button];
        if (!index) {
            continue;
        }
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(lastButton);
            if (index % 3) {
                make.left.equalTo(lastButton.mas_right);
                make.top.equalTo(lastButton);
            } else {
                make.left.equalTo(self.view);
                make.top.equalTo(lastButton.mas_bottom);
            }
        }];
        
        lastButton = button;
    }
    
    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - Button Click
- (void)clickToNumber:(UIButton *)button {
    
}

#pragma mark - Initializer
- (UIButton *)createButton:(NSInteger)buttonIndex {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    NSString *stringIndex = [NSString stringWithFormat:@"%ld",buttonIndex + 1];
    [button setTitle:stringIndex forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(clickToNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (NSArray *)array {
    if (!_array) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = wz_keyboardType1; i <= wz_keyboardType9; i ++) {
            UIButton *button = [self createButton:i];
            [array addObject:button];
        }
        _array = [NSArray arrayWithArray:array];
    }
    return _array;
}

@end
