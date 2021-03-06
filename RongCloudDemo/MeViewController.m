//
//  MeViewController.m
//  RongCloudDemo
//
//  Created by 秦启飞 on 2016/12/16.
//  Copyright © 2016年 dlz. All rights reserved.
//

#import "MeViewController.h"
#import "MeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "EntranceViewController.h"
#import "ArticleTableViewController.h"
#import "MBProgressHUD.h"
#import <RongIMLib/RongIMLib.h>
#import "PsychologyTableViewController.h"
#import "ShalongTableViewController.h"
#import "EditPhoneViewController.h"
#import "VipViewController.h"
#import "DataBaseNSUserDefaults.h"
#import "AppDelegate.h"
#import "Alert.h"
#import "AFNetworking.h"
#import "Toast.h"
#import "ChangePwdViewController.h"
#import "JsonUtil.h"
#import "MyCollectViewController.h"
#import "QiniuSDK.h"
#import "zxGenarateToken.h"
#import "MyActivityViewController.h"

#define AK @"Pgclum_hLBU2FKsYZbRijZgZ8p2PpwlsfloLTGrP"
#define SK @"GUF391mp5WDKRtxnSFQ0X1qBuXEEkXPHYZ2Q8x2f"
#define KscopeName @"schoolcon"

@interface MeViewController (){
    NSMutableArray *mDataKey;
    NSMutableArray *mDataImg;
    //NSData *selectedImgData;
    //UIImage *image;
    //上传头像进度条，就是一个劲旋转的进度
    MBProgressHUD *hud;
    
    NSString  *avatarImgUrl;
}
//@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewAvatar;

@end

@implementation MeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"我 的";
    
    _mUILabelUname.text=[DataBaseNSUserDefaults getData:@"name"];
    //[self QiNiuUploadImage:nil];
    //   navigationBar背景
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    [self.navigationController.navigationBar setBarTintColor:myDelegate.navigationBarColor];
    
    //      navigationBar标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    
    //    隐藏返回按钮navigationController的navigationBar
    self.navigationController.navigationBarHidden=YES;
    
    
    //    返回箭头和文字的颜色，只要写一次就行了，是全局的
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    修改下一个界面返回按钮的title，注意这行代码每个页面都要写一遍，不是全局的
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    mDataKey=[[NSMutableArray alloc]init];
    
    NSNumber *userType=[DataBaseNSUserDefaults getData:@"userType"];
    
    [mDataKey addObject:@"修改电话"];
    [mDataKey addObject:@"修改密码"];
    [mDataKey addObject:@"我的活动"];
    [mDataKey addObject:@"我的测试"];
    if(![AppDelegate isTeacher]){
        [mDataKey addObject:@"我的会员"];
    }
    [mDataKey addObject:@"我的收藏"];
    //[mDataKey addObject:@"退出登录"];
    
    mDataImg=[[NSMutableArray alloc]init];
    [mDataImg addObject:@"my_phone.png"];
    [mDataImg addObject:@"me_pwd.png"];
    [mDataImg addObject:@"my_activity.png"];
    [mDataImg addObject:@"my_test.png"];
    if(![AppDelegate isTeacher]){
        [mDataImg addObject:@"my_vip.png"];
    }
    
    [mDataImg addObject:@"my_collect.png"];
    //[mDataImg addObject:@"exit.png"];
    
    
    
    self.UIImageViewAvatar.image=[UIImage imageNamed:myDelegate.defaultAvatar];
    //    加载图片,如果加载不到图片，就显示favorites.png
    //[self.UIImageViewAvatar sd_setImageWithURL:@"http://img05.tooopen.com/images/20150202/sy_80219211654.jpg" placeholderImage:[UIImage imageNamed:myDelegate.defaultAvatar]];
    //设置图片为圆形
    /*
     *View都有一个layer的属性，我们正是通过layer的一些设置来达到圆角的目的，因此诸如UIImageView、UIButton
     *UILabel等view都可以设置相应的圆角。对于圆形的头像，要制作正圆，我们需要首先设置UIImageView的高宽的一致
     *的，然后我们设置其圆角角度为高度除以2即可，相当于90度
     * http://blog.csdn.net/cloudox_/article/details/50511531
     */
    self.UIImageViewAvatar.layer.masksToBounds = YES;
    self.UIImageViewAvatar.layer.cornerRadius = self.UIImageViewAvatar.frame.size.height / 2 ;
    
    //给图片添加点击事件更换图片
    self.UIImageViewAvatar.userInteractionEnabled = YES;//打开用户交互
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    //为图片添加手势
    [ self.UIImageViewAvatar addGestureRecognizer:singleTap];
    
    
    [self getUserInfo];
    
    //[DataBaseNSUserDefaults setData: [[doc objectForKey:@"data"]objectForKey:@"type"] forkey:@"userType"];
    //NSNumber *zero=[NSNumber numberWithInt:(0)];
    //NSNumber *code=[doc objectForKey:@"code"];
    //if([zero isEqualToNumber:code])
    
    
    
    //这是老师
    if([[NSNumber numberWithInt:(0)] isEqualToNumber:userType]){
        //_mUILabelKeyStudentName.text=@"";
        
        //_mUILabelKeyClass.text=@"";
        
        [self.mUILabelKeyStudentName setHidden:YES];
        [self.mUILabelKeyClass setHidden:YES];
        self.mUILabelKeyHeadTeacher.text=@"教学学科:";
        
        //把四个label变大一点，因为老师只显示两行信息，字体小就会显得很丑
        //self.mUILabelKeyHeadTeacher.font=[UIFont systemFontOfSize:14];
        self.mUILabelKeySchool.font=[UIFont systemFontOfSize:14];
        self.mUILabelSchool.font=[UIFont systemFontOfSize:14];
        self.mUILabelKeyHeadTeacher.font=[UIFont systemFontOfSize:14];
        self.mUILabelHeadTeacher.font=[UIFont systemFontOfSize:14];
    }
}

//头像点击事件
-(void)singleTapAction:(UIGestureRecognizer *) s{
    NSLog(@"单击了头像");
    if([self dealWithNetworkStatus])
        [self changePortrait];
}

- (void)changePortrait {
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"拍照"
                       otherButtonTitles:@"我的相册", nil];
    [actionSheet showInView:self.view];
}

/**
 *actionSheet点击事件
 */
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController
                 isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                NSLog(@"模拟器无法连接相机");
            }
            [self presentViewController:picker animated:YES completion:nil];
            //[Alert showMessageAlert:@"暂时不支持拍照，请选择我的相册" view:self];
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}
/**
 *这里是用户选中图片(照相后的使用图片或者图库中选中图片)时调用
 */
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    
    NSLog(@"更换头像imagePickerController  info=%@",info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqual:@"public.image"]) {
        UIImage *originImage =
        [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.8];
        //selectedImgData = UIImageJPEGRepresentation(scaleImage, 0.00001);
        //image = [UIImage imageWithData:selectedImgData];
        [self dismissViewControllerAnimated:YES completion:nil];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
        hud.labelText = @"上传头像中...";
        [hud show:YES];
        //上传头像
        [self UploadImage:scaleImage];
        //[self QiNiuUploadImage:scaleImage];
        
    }
}
/**
 *我还做了七牛的上传头像功能，但是好像token错了，本来是服务端传递token给我的，
 *现在自己客户端生成，但是仍旧错了，以后改吧
 */
-(void)QiNiuUploadImage:(UIImage  *)image2{
    
    
    
    
    zxGenarateToken *genetoken=[[zxGenarateToken alloc]init];
    NSString *token= [genetoken returnQiniuTokenWithAk:AK sk:SK scopeName:KscopeName];
    NSLog(@"token:%@",token);
    
    //        NSString *token=@"EJyvPPQiFEBvdmQsmAZhIiRyn7iNp7d_rCm4fh__:NDAgfOENeObsFUNXGeTV1mpuBGM=:eyJzY29wZSI6InFpbml1dGV4dCIsImRlYWRsaW5lIjoxNDU3OTI0MTMxfQ==";
    QNUploadManager  *upManager=[[QNUploadManager alloc]init];
    UIImage *image=[UIImage imageNamed:@"info.png"];
    NSArray *imageArr=@[image];
    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    
    for (UIImage *image1 in imageArr) {
        NSData *data=UIImagePNGRepresentation(image1);
        [dataArray addObject:data];
    }
    
    NSMutableArray *urlArry=[[NSMutableArray alloc]init];
    NSInteger i=90;
    for (NSData *data in dataArray) {
        i++;
        [upManager putData:data key:[NSString stringWithFormat:@"zxin%ld",i] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            //NSLog(@"*************************info %@",info);
            //NSLog(@"*************************resp %@",resp);
            if (resp!=nil) {
                [urlArry addObject:[resp objectForKey:@"key"]];
            }
        } option:nil];
    }
    
    
}

//头像上传
-(void)UploadImage:(UIImage  *)image
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlString= [NSString stringWithFormat:@"%@/api/sys/user/image",myDelegate.ipString];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 请求参数
    NSDictionary *parameters = @{ @"appId":@"03a8f0ea6a",
                                  @"appSecret":@"b4a01f5a7dd4416c",
                                  @"token":myDelegate.token
                                  // ,@"Filedata":@"head.jpg"
                                  };
    NSData *imageData =UIImageJPEGRepresentation(image,1);
    
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        //NSData *imageData=UIImageJPEGRepresentation(image, 0.7);
        [formData appendPartWithFileData:imageData name:@"Filedata" fileName:@"head.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        //成功后处理
        //NSLog(@"Success: %@", responseObject);
        //NSLog(@"上传图片Success");
        NSString *result=[JsonUtil DataTOjsonString:responseObject];
        NSLog(@"***************返回结果***********************");
        NSLog(result);
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=[[NSError alloc]init];
        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(doc!=nil){
            NSLog(@"*****doc不为空***********");
            //判断code 是不是0
            NSNumber *zero=[NSNumber numberWithInt:(0)];
            NSNumber *code=[doc objectForKey:@"code"];
            if([zero isEqualToNumber:code])
            {
                //[Alert showMessageAlert:@"头像更换成功"  view:self];
                [Toast showToast:@"头像更换成功" view:self.view];
                //头像
                NSString *picUrl=[NSString stringWithFormat:@"%@%@",myDelegate.ipString,[[doc objectForKey:@"data"] objectForKey:@"purl"]];
                [self.UIImageViewAvatar sd_setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"favorites.png"]];
            }
            else{
                if([@"token invalid" isEqualToString:[doc objectForKey:@"msg"]]){
                    [AppDelegate reLogin:self];
                }
                else{
                    NSString *msg=[NSString stringWithFormat:@"code是%d ： %@",[doc objectForKey:@"code"],[doc objectForKey:@"msg"]];
                    [Alert showMessageAlert:msg  view:self];
                }
            }
        }
        else
            NSLog(@"*****doc空***********");
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        NSString *errorUser=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if(error.code==-1009)
            errorUser=@"主人，似乎没有网络喔！";
        [Alert showMessageAlert:errorUser view:self];
    }];
}


- (UIImage *)scaleImage:(UIImage *)tempImage toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(tempImage.size.width * scaleSize,
                                           tempImage.size.height * scaleSize));
    [tempImage drawInRect:CGRectMake(0, 0, tempImage.size.width * scaleSize,
                                     tempImage.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *判断网络情况
 */
- (BOOL)dealWithNetworkStatus {
    BOOL isconnected = NO;
    RCNetworkStatus networkStatus = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
    if (networkStatus == 0) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:@"当前网络不可用，请检查你的网络设置"
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
        [alert show];
        return isconnected;
    }
    return isconnected = YES;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    return [[UIView alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [mDataKey count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[MeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImageView *mUIImageViewIcon=[cell viewWithTag:1];
    UILabel *mUILabelTitle=[cell viewWithTag:2];
    
    mUILabelTitle.text=[mDataKey objectAtIndex:indexPath.row];
    
    mUIImageViewIcon.image=[UIImage imageNamed:[mDataImg objectAtIndex:indexPath.row]];
    
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是不是退出登录
//    if([mDataKey count]-1==indexPath.row){
//    }
//    
    //修改电话
    if(0==indexPath.row){
        //显示顶部导航
        self.navigationController.navigationBarHidden=NO;
        EditPhoneViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"EditPhoneViewController"];
        nextPage.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:nextPage animated:YES];
    }
    //修改密码
    if(1==indexPath.row){
        //显示顶部导航
        self.navigationController.navigationBarHidden=NO;
        ChangePwdViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePwdViewController"];
        nextPage.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:nextPage animated:YES];
        //NSLog(@"修改密码");
    }
    
    //我的活动
    if(2==indexPath.row){
        //显示顶部导航
        self.navigationController.navigationBarHidden=NO;
        MyActivityViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"MyActivityViewController"];
        nextPage.hidesBottomBarWhenPushed=YES;
        //nextPage->type=@"ylsl";
        [self.navigationController pushViewController:nextPage animated:YES];
    }
    
    //我的测试
    if(3==indexPath.row){
        //显示顶部导航
        self.navigationController.navigationBarHidden=NO;
        PsychologyTableViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"PsychologyTableViewController"];
        
        nextPage->type=@"wdcs";
        
        nextPage.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:nextPage animated:YES];
    }
    
   if(![AppDelegate isTeacher]){
        //我的会员
        if(4==indexPath.row){
            //显示顶部导航
            self.navigationController.navigationBarHidden=NO;
            VipViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"VipViewController"];
            nextPage->avatarImgUrl=avatarImgUrl;
            nextPage.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:nextPage animated:YES];
            
        }
    }
    //我的收藏
    if([mDataKey count]-1==indexPath.row){
        //显示顶部导航
        self.navigationController.navigationBarHidden=NO;
        MyCollectViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"MyCollectViewController"];
        
        nextPage.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:nextPage animated:YES];
        
    }
}
//虽然viewDidLoad已经设置了隐藏，但是在进入下一个页面并返回此页面的时候，还是会出现，所以在这里再次隐藏
-(void) viewDidAppear:(BOOL)animated{
    //    隐藏返回按钮navigationController的navigationBar
    self.navigationController.navigationBarHidden=YES;
}
//获取用户个人信息
-(void) getUserInfo{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlString= [NSString stringWithFormat:@"%@/api/sys/user/myInfo",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    NSString *token=myDelegate.token;
    // 请求参数
    NSDictionary *parameters = @{ @"appId":@"03a8f0ea6a",
                                  @"appSecret":@"b4a01f5a7dd4416c",
                                  @"token":token
                                  };
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSString *result=[JsonUtil DataTOjsonString:responseObject];
        NSLog(@"***************返回结果***********************");
        NSLog(result);
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=[[NSError alloc]init];
        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(doc!=nil){
            NSLog(@"*****doc不为空***********");
            //判断code 是不是0
            NSNumber *zero=[NSNumber numberWithInt:(0)];
            NSNumber *code=[doc objectForKey:@"code"];
            if([zero isEqualToNumber:code])
            {
                NSNumber *userType=[DataBaseNSUserDefaults getData:@"userType"];
                //这是老师
                if([[NSNumber numberWithInt:(0)] isEqualToNumber:userType]){
                    _mUILabelHeadTeacher.text=[[doc objectForKey:@"data"] objectForKey:@"course"];
                    _mUILabelStudentName.text=@"";
                    _mUILabelClass.text=@"";
                }
                else{
                    //_mUILabelUname.text=[[doc objectForKey:@"data"] objectForKey:@"name"];
                    _mUILabelStudentName.text=[[doc objectForKey:@"data"] objectForKey:@"studentName"];
                    _mUILabelHeadTeacher.text=[[doc objectForKey:@"data"] objectForKey:@"teacher"];
                    _mUILabelClass.text=[[doc objectForKey:@"data"] objectForKey:@"class"];
                }
                _mUILabelSchool.text=[[doc objectForKey:@"data"] objectForKey:@"school"];
                _mUILabelUname.text=[[doc objectForKey:@"data"] objectForKey:@"name"];
                
                
                avatarImgUrl=[[doc objectForKey:@"data"] objectForKey:@"purl"];
                //头像
                NSString *picUrl=[NSString stringWithFormat:@"%@%@",myDelegate.ipString,avatarImgUrl];
                
                
                [self.UIImageViewAvatar sd_setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:myDelegate.defaultAvatar]];
                
            }
            else{
                if([@"token invalid" isEqualToString:[doc objectForKey:@"msg"]]){
                    [AppDelegate reLogin:self];
                }
                else{
                    NSString *msg=[NSString stringWithFormat:@"code是%d ： %@",[doc objectForKey:@"code"],[doc objectForKey:@"msg"]];
                    [Alert showMessageAlert:msg  view:self];
                }
            }
        }
        else
            NSLog(@"*****doc空***********");
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorUser=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if(-1009==error.code||-1016==error.code)
            errorUser=@"主人，似乎没有网络喔！";
        [Alert showMessageAlert:errorUser view:self];
    }];
    
    
}

- (IBAction)logOut:(id)sender {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"确定退出吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确认"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    
                                                           //清除token
                                                           [DataBaseNSUserDefaults removeData:@"token"];
    
                                                           //                                                       NSLog(@"退出登录");
    
                                                           //桌面图标右上角红点设置为0
                                                           [UIApplication sharedApplication].applicationIconBadgeNumber =0;
                                                           //根据storyboard id来获取目标页面
                                                           EntranceViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"EntranceViewController"];
                                                           nextPage.hidesBottomBarWhenPushed=YES;
                                                           //跳转
                                                           [self.navigationController pushViewController:nextPage animated:YES];
                                                       }];
    
            UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
            //        信息框添加按键
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];

    
}




@end
