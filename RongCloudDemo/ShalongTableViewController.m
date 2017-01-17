//
//  ShalongTableViewController.m
//  RongCloudDemo
//
//  Created by 秦启飞 on 2016/12/18.
//  Copyright © 2016年 dlz. All rights reserved.
//

#import "ShalongTableViewController.h"
#import "ShalongTableViewCell.h"
#import "DetailYuluViewController.h"
#import "UIImageView+WebCache.h"
#import "Activity.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "ArticleTableViewController.h"
#import "Vp1TableViewCell.h"
#import "ArticleDetailViewController.h"
#import "AppDelegate.h"
#import "WMPageController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Article.h"
#import "JsonUtil.h"
#import "MJRefresh.h"
@interface ShalongTableViewController ()

@end

@implementation ShalongTableViewController{
    NSMutableArray *allDataFromServer;
    
    UITableView *mTableView;
    //页面索引，分页查询数据，下拉刷新的时候需要使用到
    int pageIndex;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据默认为先加载第一页
    pageIndex=1;
    [self loadData:pageIndex orientation:@"up"];
    
    self.title=@"岳麓沙龙";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:3/255.0 green:121/255.0 blue:251/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    //    修改下一个界面返回按钮的title，注意这行代码每个页面都要写一遍，不是全局的
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //防止与顶部重叠
//    self.tableView.contentInset=UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);

//    Activity *model=[[Activity alloc]init];
//    model.activityId=@"1";
//    model.picUrl=@"http://mmbiz.qpic.cn/mmbiz_jpg/6qu8KwIJTLcqTxT8jqPOKCEAvGuhbFpzscsPC8FeDEYkQxsQ1AFSeJjYWgMeicQU2gJrgb3bhu7quicok24sLwIw/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1";
//    model.title=@"在生活中找寻游赏，也找寻写作 | 舒国治五城巡讲";
//    model.publisher=@"理想国、听道";
//    model.place=@"厦门·纸的时代书店";
//    model.date=@"2017-02-29";
//    
//    Activity *modelPhysicalActicity=[[Activity alloc]init];
//    modelPhysicalActicity.activityId=@"1";
//    modelPhysicalActicity.picUrl=@"https://imgsa.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=cb319e894290f60310bd9415587bd87e/ac345982b2b7d0a24d471625c3ef76094a369aff.jpg";
//    modelPhysicalActicity.title=@"长沙地面 | 儿童精神分析系统培训工作坊（第一阶)";
//    modelPhysicalActicity.publisher=@" 大成心理工作室";
//    modelPhysicalActicity.place=@"长沙市星沙向阳路金科时代 3栋613  ";
//    modelPhysicalActicity.date=@"2017-02-29";
//    allDataFromServer=[[NSMutableArray alloc]init];
//    if([@"ylsl" isEqualToString:type])
//    for(int i=0;i<5;i++)
//        [allDataFromServer addObject:model];
//    else
//        for(int i=0;i<5;i++)
//            [allDataFromServer addObject:modelPhysicalActicity];
//    
//

    // 2.集成刷新控件
    [self setupRefresh];
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在为您刷新。。。";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在为您刷新。。。";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    Activity *model=[[Activity alloc]init];
    model.activityId=@"1";
    model.picUrl=@"http://mmbiz.qpic.cn/mmbiz_jpg/6qu8KwIJTLcqTxT8jqPOKCEAvGuhbFpzscsPC8FeDEYkQxsQ1AFSeJjYWgMeicQU2gJrgb3bhu7quicok24sLwIw/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1";
    model.title=@"在生活中找寻游赏，也找寻写作 | 舒国治五城巡讲";
    model.publisher=@"理想国、听道";
    model.place=@"厦门·纸的时代书店";
    model.date=@"2017-02-29";
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [allDataFromServer insertObject:model atIndex:0];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    Activity *model=[[Activity alloc]init];
    model.activityId=@"1";
    model.picUrl=@"http://img05.tooopen.com/images/20150202/sy_80219211654.jpg";
    model.title=@"长沙第一次岳麓活动";
    model.publisher=@"中南大学软件学院";
    model.place=@"向上拉。。。刷新数据";
    model.date=@"2017-02-29";    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [allDataFromServer addObject:model];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [allDataFromServer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShalongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(cell==nil){
        cell=[[ShalongTableViewCell init] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Activity *model=[allDataFromServer objectAtIndex:indexPath.row];
//    NSString *t1=[mData objectAtIndex:indexPath.row];
//    cell.UILabelTitle.text=t1;
    cell.UILabelTitle.text=model.title;
    cell.UILabelDate.text=model.date;
    cell.UILabelPlace.text=model.place;
    cell.UILabelPublisher.text=model.publisher;
//    cell.UIImgCover.image=[UIImage imageNamed:[mImg objectAtIndex:indexPath.row]];
//        加载图片,如果加载不到图片，就显示favorites.png
    [cell.UIImgCover sd_setImageWithURL: model.picUrl placeholderImage:[UIImage imageNamed:@"favorites.png"]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据storyboard id来获取目标页面
    DetailYuluViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"DetailYuluViewController"];
    if([@"ylsl" isEqualToString:type])
        nextPage->pubString=@"http://mp.weixin.qq.com/s/uikPkoBVZkE5KXwCqrzscg";
    else
    nextPage->pubString=@"https://mp.weixin.qq.com/s?__biz=MzI0NzcwMjk4OA==&mid=100000022&idx=1&sn=27cf85ac5608ce44155933b96a5ceb82&chksm=69aab5b55edd3ca379bfd80fef1a5a40f974fc4ff609751a10ce36d267d662c418df83c4a050&mpshare=1&scene=1&srcid=0109wYB7kXr9UDvmRYqExeBD&key=b4386489b84c1a425fed004ec36f553c36a2512955542db4ec3527929a8dc8ee8425aa3cd42627026c893c457e5890656757e099e3cc47b5938ed9444d874275789f09f4738713b1951b5959b668dd2a&ascene=0&uin=ODk4MzEwMTY5&devicetype=iMac+MacBookAir6%2C2+OSX+OSX+10.12.1+build(16B2555)&version=12010210&nettype=WIFI&fontScale=100&pass_ticket=gLigsYUageUfMfyUCRYEEUnvhAkH2%2BwYNaz83cLnA%2F3bXoIpzkMunbIBNAu2VYbw";
    //    传值
//    nextPage->pubString=[mData objectAtIndex:indexPath.row];
    //UITabBarController和的UINavigationController结合使用,进入新的页面的时候，隐藏主页tabbarController的底部栏
    nextPage.hidesBottomBarWhenPushed=YES;
    
    //跳转
    [self.navigationController pushViewController:nextPage animated:YES];
}
#pragma mark 加载活动列表
-(void)loadData:(int)pageIndex orientation:(NSString *) orientation {
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
    hud.labelText = @" 获取数据...";
    [hud show:YES];
    //获取全局ip地址
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    
    NSString *urlString= [NSString stringWithFormat:@"%@/api/cms/activity/getList",myDelegate.ipString];
    //创建数据请求的对象，不是单例
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //设置响应数据的类型,如果是json数据，会自动帮你解析
    //注意setWithObjects后面的s不能少
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    NSString *token=myDelegate.token;
    // 请求参数
    NSDictionary *parameters = @{ @"appId":@"03a8f0ea6a",
                                  @"appSecret":@"b4a01f5a7dd4416c",
                                  @"channelType":type,
                                  @"pageNumber":[NSString stringWithFormat:@"%d",pageIndex],
                                  @"token":token
                                  };
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
        //隐藏圆形进度条
        [hud hide:YES];
        NSString *result=[JsonUtil DataTOjsonString:responseObject];
        NSLog(@"***************返回结果***********************");
        NSLog(result);
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=[[NSError alloc]init];
        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(doc!=nil){
            NSLog(@"*****doc不为空***********");
            if([[doc objectForKey:@"code"] isKindOfClass:[NSNumber class]])
                NSLog(@"code 是 NSNumber");
            //判断code 是不是0
            NSNumber *zero=[NSNumber numberWithInt:(0)];
            NSNumber *code=[doc objectForKey:@"code"];
            if([zero isEqualToNumber:code])
            {
                if(nil!=[doc allKeys]){
                    
                    NSArray *articleArray=[doc objectForKey:@"data"];
                    if(0==[articleArray count]){
                        
                        if([orientation isEqualToString:@"down"])
                            self.tableView.headerRefreshingText = @"亲，没有更多数据了";
                        else
                            self.tableView.footerRefreshingText = @"亲，没有更多数据了";
                        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"抱歉,没有更多数据了" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确认"
                                                                   style:UIAlertActionStyleDefault handler:nil];
                        
                        //        信息框添加按键
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }
                    else{
                        
                        for(NSDictionary *item in  articleArray ){
                            Article *model=[[Article alloc]init];
                            model.articleId=item [@"id"];
                            model.picUrl=item [@"picurl"];
                            model.title=item [@"title"];
                            model.author=item [@"author"];
                            
                            //                    注意，publishat是NSNumber 类型的，所以不要用字符串去接收，否则报错
                            //                    -[__NSCFNumber rangeOfCharacterFromSet:]: unrecognized selector sent to instance 0x7fa5216589d0"，对于IOS开发感兴趣的同学可以参考一下： 这个算是类型的不匹配，就是把NSNumber类型的赋给字符串了自己还不知情，
                            
                            model.date=item [@"publishat"];
                            
                            
                            NSLog(@"******打印文章列表**********");
                            NSLog(@"文章articleId是%@",model.articleId);
                            NSLog(@"文章picUrl是%@",model.picUrl);
                            NSLog(@"文章title是%@",model.title);
                            NSLog(@"文章author是%@",model.author);
                            NSLog(@"文章publishat是%i",model.date);
                            //添加到数组以便显示到tableview
                            NSLog(@"addObject之前");
                            if([orientation isEqualToString:@"up"])
                                [allDataFromServer addObject:model];
                            else
                                [allDataFromServer insertObject:model atIndex:0];
                            NSLog(@"addObject之后");
                        }
                        NSLog(@"mDataArticle项数为%i",[allDataFromServer count]);
                        NSLog(@"//更新界面");
                        //更新界面
                        [mTableView reloadData];
                    }
                    //            }
                }
                else
                {
                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"抱歉，尚无文章可以阅读" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确认"
                                                               style:UIAlertActionStyleDefault handler:nil];
                    
                    //        信息框添加按键
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
            }
            
            else{
                
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[doc objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确认"
                                                           style:UIAlertActionStyleDefault handler:nil];
                //        信息框添加按键
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
        }
        else
            NSLog(@"*****doc空***********");
        
        
        
        
        
        
        
        //        NSLog([self DataTOjsonString:responseObject]);
        //          NSLog([self convertToJsonData:dic]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
        //隐藏圆形进度条
        [hud hide:YES];
        NSString *errorUser=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if(error.code==-1009)
            errorUser=@"主人，似乎没有网络喔！";
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:errorUser preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确认"
                                                   style:UIAlertActionStyleDefault handler:nil];
        
        //        信息框添加按键
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];}



@end
