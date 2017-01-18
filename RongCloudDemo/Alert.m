//
//  Alert.m
//  RongCloudDemo
//
//  Created by 秦启飞 on 2017/1/18.
//  Copyright © 2017年 dlz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alert.h"

@implementation Alert

+(void)showMessageAlert:(NSString *)msg{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确认"
                                               style:UIAlertActionStyleDefault handler:nil];
    //        信息框添加按键
    [alert addAction:ok];
    [alert presentViewController:alert animated:YES completion:nil];
}
@end
