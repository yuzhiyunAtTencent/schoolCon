//
//  TestViewController.h
//  RongCloudDemo
//
//  Created by 秦启飞 on 2016/12/21.
//  Copyright © 2016年 dlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    
    NSMutableArray *mData;
    NSMutableArray *mImg;
    
    
@public
    NSString *pubString;
    
    
}
@end
