//
//  ActiveViewController.m
//  RongCloudDemo
//
//  Created by 秦启飞 on 2017/1/7.
//  Copyright © 2017年 dlz. All rights reserved.
//
#import "ActiveViewController.h"
#import "MainViewController.h"
#import "SetPwdAfterActiveViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Toast.h"
#import "JsonUtil.h"
#import "DataBaseNSUserDefaults.h"
#import "Alert.h"
//#define JsonGet @"http://192.168.229.1:8080/schoolCon/api/sys/sms/send?appId=03a8f0ea6a&appSecret=b4a01f5a7dd4416c&phone=12345&1564do12spa"
@interface ActiveViewController ()

@end

@implementation ActiveViewController{
    //用于计算验证码等待秒数
    int count;
    NSTimer *countDownTimer;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"激活";
    //全局ip
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"全局ip地址是 %@",myDelegate.ipString);
    
    //处理软键盘遮挡输入框事件
    _UITextFieldPhone.delegate=self;
    _UITextFieldPwd.delegate=self;
    _UITextFieldVerifyCode.delegate=self;
    
    
    [self.mUIButtonGetCode.layer setMasksToBounds:YES];
    
    
    [self.mUIButtonGetCode.layer setCornerRadius:4.0]; //设置圆角，数学不好，数值越小越不明显，自己找一个合适的值
    
    
    [self.mUIButtonGetCode.layer setBorderWidth:0.8];//设置边框的宽度
    
    [self.mUIButtonGetCode.layer setBorderColor:[[UIColor colorWithRed:3/255.0 green:121/255.0 blue:251/255.0 alpha:1.0] CGColor]];//设置颜色
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

//获取验证码
-(void)httpGetVerifyCode{
    //#import "AFNetworking.h"
    //#import "AppDelegate.h"
    //#import "MBProgressHUD.h"
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
    hud.labelText = @" 获取数据...";
    [hud show:YES];
    //获取全局ip地址
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlString= [NSString stringWithFormat:@"%@/api/sys/sms/validate",myDelegate.ipString];
    
    //创建数据请求的对象，不是单例
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //设置响应数据的类型,如果是json数据，会自动帮你解析
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    // 请求参数
    //    NSDictionary *parameters = @{
    //                                 @"appId":myDelegate.appId,
    //                                 @"appSecret":myDelegate.appSecret,
    //                                 @"schoolId":myDelegate.schoolId,
    //                                 @"phone":@"123456",
    //                                 @"pwd":@"123456",
    //                                 @"vcode":@"1234"
    //                                 };
    
    
    // 请求参数
    NSDictionary *parameters = @{
                                 @"appId":myDelegate.appId,
                                 @"appSecret":myDelegate.appSecret,
                                 @"schoolId":myDelegate.schoolId,
                                 @"phone":_UITextFieldPhone.text
                                 };
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //隐藏圆形进度条
        [hud hide:YES];
        NSString *result=[JsonUtil DataTOjsonString:responseObject];
        
        NSLog(@"***************返回结果***********************");
        NSLog(result);
        /**
         *开始解析json
         */
        
        
        
        //
        //        //NSString *result=[self DataTOjsonString:responseObject];
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=[[NSError alloc]init];
        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        //        {
        //         "msg" : "激活失败,该账号已经进行过激活",
        //         "code" : 205
        //         }
        NSLog([doc objectForKey:@"msg"]);
        NSLog(@"%i",[doc objectForKey:@"code"]);
        
        NSNumber *zero=[NSNumber numberWithInt:(0)];
        NSNumber *code=[doc objectForKey:@"code"];
        if([zero isEqualToNumber:code])
        {
            [Toast showToast:@"验证码发送成功" view:self.view];
            [self setSixtySecond ];
        }
        else{
            
            [Alert showMessageAlert:[doc objectForKey:@"msg"]  view:self];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //隐藏圆形进度条
        [hud hide:YES];
        NSString *errorUser=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if(error.code==-1009)
            errorUser=@"主人，似乎没有网络喔！";
        [Alert showMessageAlert:errorUser view:self];
    }];
}



- (IBAction)active:(id)sender {
    
    if(_UITextFieldPhone.text.length == 0||_UITextFieldPwd.text.length==0||_UITextFieldVerifyCode==0){
        
        [Toast showToast:@"确保输入框不为空" view:self.view];
        //        NSLog(@"手机号不能为空");
    }
    
    else
        
        
        [self httpActive];
    //    SetPwdAfterActiveViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"SetPwdAfterActiveViewController"];
    //    nextPage.hidesBottomBarWhenPushed=YES;
    //    [self.navigationController pushViewController:nextPage animated:YES];
    
}

-(void)httpActive{
    //#import "AFNetworking.h"
    //#import "AppDelegate.h"
    //#import "MBProgressHUD.h"
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
    hud.labelText = @" 获取数据...";
    [hud show:YES];
    //获取全局ip地址
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    
    NSString *urlString= [NSString stringWithFormat:@"%@/api/sys/user/activate",myDelegate.ipString];
    
    //创建数据请求的对象，不是单例
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //设置响应数据的类型,如果是json数据，会自动帮你解析
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    // 请求参数
    NSDictionary *parameters = @{
                                 @"appId":myDelegate.appId,
                                 @"appSecret":myDelegate.appSecret,
                                 @"schoolId":myDelegate.schoolId,
                                 @"phone":_UITextFieldPhone.text,
                                 @"pwd":_UITextFieldPwd.text,
                                 @"vcode":_UITextFieldVerifyCode.text
                                 };
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //隐藏圆形进度条
        [hud hide:YES];
        NSString *result=[JsonUtil DataTOjsonString:responseObject];
        
        NSLog(@"***************返回结果***********************");
        NSLog(result);
        /**
         *开始解析json
         */
        
        
        
        //
        //        //NSString *result=[self DataTOjsonString:responseObject];
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=[[NSError alloc]init];
        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        
        NSNumber *zero=[NSNumber numberWithInt:(0)];
        NSNumber *code=[doc objectForKey:@"code"];
        if([zero isEqualToNumber:code])
        {
            
            //激活成功之后获取token
            AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
            myDelegate.token=[[doc objectForKey:@"data"]objectForKey:@"token"];
            myDelegate.rtoken=[[doc objectForKey:@"data"]objectForKey:@"rtoken"];
            myDelegate.phone=_UITextFieldPhone.text;
            myDelegate.pwd=_UITextFieldPwd.text;
            
            NSString *name=[[doc objectForKey:@"data"]objectForKey:@"name"];
            
            //存储name
            [DataBaseNSUserDefaults setData: name forkey:@"name"];

            
            NSLog(@"激活之后存储token%@",myDelegate.token);
            [DataBaseNSUserDefaults setData: myDelegate.token forkey:@"token"];
            NSLog(@"激活之后存储rtoken%@",myDelegate.rtoken);
            [DataBaseNSUserDefaults setData: myDelegate.rtoken forkey:@"rtoken"];
            [DataBaseNSUserDefaults setData: myDelegate.phone forkey:@"phone"];
            [DataBaseNSUserDefaults setData: myDelegate.pwd forkey:@"pwd"];
            [DataBaseNSUserDefaults setData: myDelegate.schoolId forkey:@"schoolId"];
            
            [DataBaseNSUserDefaults setData: [[doc objectForKey:@"data"]objectForKey:@"type"] forkey:@"userType"];
            
            MainViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            nextPage.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:nextPage animated:YES];
            //获取融云的token，并且连接融云服务器
            [AppDelegate   loginRongCloud:[[doc objectForKey:@"data"]objectForKey:@"rtoken"]];
            
            
            
            
        }
        else
        {
            [Alert showMessageAlert:[doc objectForKey:@"msg"] view:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //隐藏圆形进度条
        [hud hide:YES];
        NSString *errorUser=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if(error.code==-1009)
            errorUser=@"主人，似乎没有网络喔！";
        [Alert showMessageAlert:errorUser view:self];
    }];
}

-(void)setSixtySecond{
    
    
    //开始倒计时
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    
    
}
-(void)timeFireMethod{
    //倒计时-1
    count--;
    //修改倒计时标签现实内容
    [_mUIButtonGetCode setTitle:[NSString stringWithFormat:@"%d S",count] forState:UIControlStateNormal];
    //labelText.text=[NSString stringWithFormat:@"%d",secondsCountDown];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(count==0){
        [countDownTimer invalidate];
        count=60;
        [_mUIButtonGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
- (IBAction)getCode:(id)sender {
    if(_UITextFieldPhone.text.length == 0){
        [Toast showToast:@"手机号不能为空" view:self.view];
        NSLog(@"手机号不能为空");
    }
    else
        [self httpGetVerifyCode];
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y +frame.size.height - (self.view.frame.size.height - 270);//键盘高度270
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


@end



