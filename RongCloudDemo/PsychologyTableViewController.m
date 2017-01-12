//
//  TemplateTableViewController.m
//  RongCloudDemo
//
//  Created by 秦启飞 on 2016/12/18.
//  Copyright © 2016年 dlz. All rights reserved.
//

#import "PsychologyTableViewController.h"
#import "PsychologyTableViewCell.h"
#import "TestViewController.h"
#import "PhysicalTest.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
@interface PsychologyTableViewController ()

@end

@implementation PsychologyTableViewController{
    NSMutableArray *allDataFromServer;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=pubString;
    
    //防止与顶部重叠
//    self.tableView.contentInset=UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
//
//    //指定大标题
//    mData=[[NSMutableArray alloc]init];
//    [mData addObject:@"MBTI职业性格测试"];
//    [mData addObject:@"霍兰德职业倾向测试"];
//    [mData addObject:@"爱情测试：你内心有多相信爱情"];
//    [mData addObject:@"事业测试：你该去什么样的公司"];
//    [mData addObject:@"个性测试：你了解自己百分之多少"];
//    //指定封面
//    mImg=[[NSMutableArray alloc]init];
//    [mImg addObject:@"1.jpg"];
//    [mImg addObject:@"2.jpg"];
//    [mImg addObject:@"3.jpg"];
//    [mImg addObject:@"4.jpg"];
//    [mImg addObject:@"5.jpg"];
    PhysicalTest *model=[[PhysicalTest alloc]init];
    model.testId=@"1";
    model.picUrl=@"http://img05.tooopen.com/images/20150202/sy_80219211654.jpg";
    model.title=@"MBTI职业性格测试";
    model.price=@"600";
    model.testNumber=@"1234";
    
    allDataFromServer=[[NSMutableArray alloc]init];
    [allDataFromServer addObject:model];
 [allDataFromServer addObject:model];
     [allDataFromServer addObject:model];
     [allDataFromServer addObject:model];
     [allDataFromServer addObject:model];
    
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
    PhysicalTest *model=[[PhysicalTest alloc]init];
    model.testId=@"1";
    model.picUrl=@"http://img05.tooopen.com/images/20150202/sy_80219211654.jpg";
    model.title=@"下拉刷新数据";
    model.price=@"600";
    model.testNumber=@"1234";
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
    PhysicalTest *model=[[PhysicalTest alloc]init];
    model.testId=@"1";
    model.picUrl=@"http://img05.tooopen.com/images/20150202/sy_80219211654.jpg";
    model.title=@"向上拉。。。。刷新数据";
    model.price=@"600";
    model.testNumber=@"1234";
    // 1.添加假数据
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

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [allDataFromServer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PsychologyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(cell==nil){
        
        cell=[[PsychologyTableViewCell init] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    
    PhysicalTest  *model=[allDataFromServer objectAtIndex:indexPath.row];
    
    cell.UILabelTitle.text=model.title;
    cell.UILabelPrice.text=model.price;
    cell.UILabelNumOfTest=model.testNumber;

//    cell.UIImageViewCover.image=[UIImage imageNamed:[mImg objectAtIndex:indexPath.row]];
//    
     [cell.UIImageViewCover sd_setImageWithURL:model.picUrl placeholderImage:[UIImage imageNamed:@"favorites.png"]];
    // Configure the cell...
    
    return cell;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    //根据storyboard id来获取目标页面
    TestViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"TestViewController"];
    
    
//    //    传值
//    nextPage->pubString=[mDataNotification objectAtIndex:indexPath.row];
    //UITabBarController和的UINavigationController结合使用,进入新的页面的时候，隐藏主页tabbarController的底部栏
    nextPage.hidesBottomBarWhenPushed=YES;
    
    //跳转
    [self.navigationController pushViewController:nextPage animated:YES];
    
    
    
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
