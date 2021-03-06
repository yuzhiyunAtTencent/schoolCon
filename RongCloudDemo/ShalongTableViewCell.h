//
//  ShalongTableViewCell.h
//  RongCloudDemo
//
//  Created by 秦启飞 on 2016/12/18.
//  Copyright © 2016年 dlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShalongTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mUILabelPublisherKey;
@property (weak, nonatomic) IBOutlet UILabel *mUILabelPlaceKey;


@property (weak, nonatomic) IBOutlet UIImageView *UIImgCover;
@property (weak, nonatomic) IBOutlet UILabel *UILabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *UILabelPublisher;
@property (weak, nonatomic) IBOutlet UILabel *UILabelPlace;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDate;
@end
