//
//  MainViewController.m
//  TabBarController
//
//  Created by ios on 15/4/14.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "MainViewController.h"
#import "CityChooseViewController.h"
@interface MainViewController ()
{
    UIBarButtonItem *editButton;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"柠檬派";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCity:) name:userDidChooseCityNotify object:nil];
//    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//
//    buttonView.backgroundColor=[UIColor redColor];
//    UIButton *exampleButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    exampleButton1.frame = CGRectMake(0, 2, 30, 40);
//
////    [exampleButton1 addTarget:self action:@selector(FirstMethod) forControlEvents:UIControlEventTouchUpInside];
//    [buttonView addSubview:exampleButton1];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
    editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"北京"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(push)];
    self.navigationItem.leftBarButtonItem = editButton;
    
 
    
    
}

- (void)getCity:(NSNotification *)aNotify {
    
    CityChooseResult *result =aNotify.object;
    
    editButton.title=[NSString stringWithFormat:@"%@",result.cityName];
//    addressLable.text=[NSString stringWithFormat:@"中文名:%@\n英文名:%@",result.cityName,result.cityPingYingName];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)push {
    
    CityChooseViewController *city=[[CityChooseViewController alloc] init];

    UINavigationController *cityNg=[[UINavigationController alloc] initWithRootViewController:city];
//    city.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:city animated:YES];
    [self presentViewController:cityNg animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark TalbeViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==1) {
        return 190;
    }
    else if (indexPath.section==2) {
        return 190;
    }
    else if (indexPath.section==3) {
        return 128;
    }
    return 0;
}

//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return nil;
}

//别忘了设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    //返回头部高度
    if (section==0) {
        return 148;
    }
    else if (section==1)
    {
        return 80;
    }
    else if (section==2)
    {
        return 31;
    }
    else if (section==3)
    {
        return 32;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 150)];
        //        //轮播图

        
        return view;
    }
    else if (section==1)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        view.backgroundColor = [UIColor whiteColor];
        

        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
        

      headerLabel.text = [self timeFormatted:3600]; 

        headerLabel.opaque = NO;
        headerLabel.font=[UIFont systemFontOfSize:14];
        headerLabel.frame = CGRectMake(50, 10, 80.0, 15.0);

        headerLabel.center=view.center;
        headerLabel.textAlignment=NSTextAlignmentCenter;
        [headerLabel sizeToFit];
        
        
        
        [view addSubview:headerLabel];
        
        return view;
    }
    else if (section==2)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
        
        headerLabel.text=@"限时闪购";
        headerLabel.opaque = NO;
        headerLabel.font=[UIFont systemFontOfSize:14];
        headerLabel.frame = CGRectMake(30.0, 10, 80.0, 15.0);
        
        
        UIButton *morebtn=[[UIButton alloc] initWithFrame:CGRectZero];
        [morebtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        morebtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [morebtn setTitle:@"More..." forState:UIControlStateNormal];
        morebtn.frame=CGRectMake(240, 12.0, 73, 10.0);
        
        //
        UIImageView *newimage=[[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 15, 12)];
        newimage.image=[UIImage imageNamed:@"hot"];
        
        UIImageView *xianimage=[[UIImageView alloc] initWithFrame:CGRectMake(5, 33, 308, 0.5)];
        xianimage.image=[UIImage imageNamed:@"xian_12"];
        
        UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        
        
        UILabel *lable1=[[UILabel alloc] initWithFrame:CGRectMake(0, -10, 320, 0.5)];
        
        
        [view addSubview:lable1];
        [view addSubview:lable];
        [view addSubview:headerLabel];
        [view addSubview:morebtn];
        [view addSubview:newimage];
        [view addSubview:xianimage];
        return view;
        
    }
    else if (section==3)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
        
        headerLabel.text=@"营养配餐";
        headerLabel.opaque = NO;
        headerLabel.font=[UIFont systemFontOfSize:14];
        headerLabel.frame = CGRectMake(30.0, 10, 80.0, 15.0);
        
        UIButton *morebtn=[[UIButton alloc] initWithFrame:CGRectZero];
        [morebtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        morebtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [morebtn setTitle:@"More..." forState:UIControlStateNormal];
        morebtn.frame=CGRectMake(240, 12.0, 73, 10.0);

        //
        UIImageView *newimage=[[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 15, 17)];
        newimage.image=[UIImage imageNamed:@"bandIcon"];
        
        UIImageView *xianimage=[[UIImageView alloc] initWithFrame:CGRectMake(5, 33, 308, 0.5)];
        xianimage.image=[UIImage imageNamed:@"xian_12"];
        
        UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        
        
        UILabel *lable1=[[UILabel alloc] initWithFrame:CGRectMake(0, -10, 320, 0.5)];
        
        
        [view addSubview:lable1];
        [view addSubview:lable];
        [view addSubview:headerLabel];
        [view addSubview:newimage];
        [view addSubview:morebtn];
        [view addSubview:xianimage];
        return view;
        
    }
    
    return nil;
}



- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    
    NSLog(@"%02d:%02d:%02d",hours,minutes,seconds);

    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    
}
#pragma make button事件的点击方法



@end
