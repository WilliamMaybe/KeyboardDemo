//
//  KeyboardViewController.m
//  Keyboard
//
//  Created by WilliamZhang on 15/8/24.
//  Copyright (c) 2015年 WilliamZhang. All rights reserved.
//

#import "KeyboardViewController.h"
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
    
    /** dot  */
    wz_keyboardTypeDot,
    /** 0  */
    wz_keyboardTypeZero,
    /** dismiss  */
    wz_keyboardTypeDismiss,
    /** delete  */
    wz_keyboardTypeDelete,
    /** done  */
    wz_keyboardTypeDone,
    
    wz_keyboardTypeMax
};

@interface KeyboardViewController ()

@property (nonatomic , strong) NSArray *array;
@property (nonatomic , strong) UIButton *deleteButton;
@property (nonatomic , strong) UIButton *doneButton;

@end

@implementation KeyboardViewController

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
        
        if (index == wz_keyboardTypeDismiss) {
            break;
        }
        // 为9宫格排列取到lastButton
    }
    
    // 处理删除、确定
    UIButton *deleteButton = [self.array objectAtIndex:wz_keyboardTypeDelete];
    [self.view addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(lastButton);
        make.top.right.equalTo(self.view);
    }];
    
    UIButton *doneButton = [self.array objectAtIndex:wz_keyboardTypeDone];
    [self.view addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deleteButton.mas_bottom);
        make.height.width.right.equalTo(deleteButton);
        make.bottom.equalTo(self.view);
    }];
    
    // 最终确定位置 😁
    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(doneButton);
        make.right.equalTo(doneButton.mas_left);
    }];
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
}

#pragma mark - Button Click
- (void)clickToNumber:(UIButton *)button {
    NSString *index = [NSString stringWithFormat:@"%ld",button.tag];
    
    switch (button.tag - 1) {
        case wz_keyboardTypeDelete:
            [self.textDocumentProxy deleteBackward];
            return;
        case wz_keyboardTypeDismiss:
            [self dismissKeyboard];
            return;
        case wz_keyboardTypeDone:
            [self dismissKeyboard];
            return;
        case wz_keyboardTypeDot:
            index = @".";
            break;
        case wz_keyboardTypeZero:
            index = @"0";
            break;
    }
    
    [self.textDocumentProxy insertText:index];
}

#pragma mark - Private Method

- (UIImage *)imageColor:(UIColor *)color size:(CGSize)size
{
    size = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *ColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ColorImg;
}

- (NSArray *)numberArray {
    return @[@"1️⃣", @"2️⃣", @"3️⃣", @"4️⃣", @"5️⃣", @"6️⃣", @"7️⃣", @"8️⃣", @"9️⃣", @"⨀", @"0️⃣",@"⬇︎", @"🔙", @"✔️"];
}

- (NSString *)getNumber:(NSInteger)index {
    if (index >= wz_keyboardTypeMax) {
        return @"";
    }
    return [[self numberArray] objectAtIndex:index];
}

#pragma mark - Initializer
- (UIButton *)createButton:(NSInteger)buttonIndex {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setBackgroundImage:[self imageColor:[UIColor whiteColor] size:CGSizeZero] forState:UIControlStateNormal];

    [button.layer setBorderWidth:0.4];
    [button.layer setBorderColor:[UIColor grayColor].CGColor];

    NSString *stringIndex = [self getNumber:buttonIndex];
    
    [button setTag:buttonIndex + 1];
    [button setTitle:stringIndex forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(clickToNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (NSArray *)array {
    if (!_array) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = wz_keyboardType1; i < wz_keyboardTypeMax; i ++) {
            UIButton *button = [self createButton:i];
            [array addObject:button];
        }
        _array = [NSArray arrayWithArray:array];
    }
    return _array;
}

@end
