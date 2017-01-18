//
//  ArticleDetailViewController.h
//  RongCloudDemo
//
//  Created by 秦启飞 on 2016/12/16.
//  Copyright © 2016年 dlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    
@public
    NSString *articleId;
@public
    NSString *title;
    
@public
    NSString *pubString;
@public
    NSString *urlString;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *UIWebViewArticle;

@end
