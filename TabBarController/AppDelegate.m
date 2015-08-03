//
//  AppDelegate.m
//  TabBarController
//
//  Created by ios on 15/4/14.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI/BMKMapManager.h>
#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#define BMAPKEY @"TEkuFyuybS76oFbAESkGv7df"

#import "MainViewController.h"

//BMKMapManager* _mapManager;

@interface AppDelegate ()<BMKGeneralDelegate>
@property(strong,nonatomic)BMKMapManager *bmkMapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.


    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
       self.window.backgroundColor = [UIColor whiteColor];

        //a.初始化一个tabBar控制器
        UITabBarController *tb=[[UITabBarController alloc]init];
         //设置控制器为Window的根控制器
//    tb.tabBar.tintColor=[UIColor redColor];

//    [tb.tabBar setTintColor:RGBA(96, 164, 222, 1)];
    [tb setSelectedIndex:1];
      self.window.rootViewController=tb;
   
      //b.创建子控制器
 
        MainViewController *c1=[[MainViewController alloc]init];
       c1.view.backgroundColor=[UIColor greenColor];
       UINavigationController *uiMainCtrl=[[UINavigationController alloc] initWithRootViewController:c1];
    [c1.tabBarItem setImage:[UIImage imageNamed:@"consult_item1"]];
    UIImage* selectedImage = [UIImage imageNamed:@"consult_item1Select"];
    //声明这张图片用原图(别渲染)
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c1.tabBarItem.selectedImage=selectedImage;
//    [c1.tabBarItem setSelectedImage:[UIImage imageNamed:@"iconH_03"]];
//         c1.tabBarItem.title=@"首页";
//        c1.tabBarItem.image=[UIImage imageNamed:@"consult_item1"];

        UIViewController *c2=[[UIViewController alloc]init];
//      c2.view.backgroundColor=[UIColor brownColor];
//         c2.tabBarItem.title=@"分类";
        c2.tabBarItem.image=[UIImage imageNamed:@"consult_item2"];
        UIImage* selectedImage2 = [UIImage imageNamed:@"consult_item2Select"];
        //声明这张图片用原图(别渲染)
        selectedImage2 = [selectedImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c2.tabBarItem.selectedImage=selectedImage2;
    
    
         UIViewController *c3=[[UIViewController alloc]init];
//         c3.tabBarItem.title=@"购物车";
        c3.tabBarItem.image=[UIImage imageNamed:@"consult_item4"];
    
    UIImage* selectedImage3 = [UIImage imageNamed:@"consult_item4Select"];
    //声明这张图片用原图(别渲染)
    selectedImage3 = [selectedImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c3.tabBarItem.selectedImage=selectedImage3;        c3.tabBarItem.badgeValue=@"8";
 
        UIViewController *c4=[[UIViewController alloc]init];
//         c4.tabBarItem.title=@"我的";
    c4.tabBarItem.image=[UIImage imageNamed:@"consult_item5"];
    
    UIImage* selectedImage4 = [UIImage imageNamed:@"consult_item5Select"];
    //声明这张图片用原图(别渲染)
    selectedImage4 = [selectedImage4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    c4.tabBarItem.selectedImage=selectedImage4;
    
        //c.添加子控制器到ITabBarController中
        //c.1第一种方式
     //    [tb addChildViewController:c1];
     //    [tb addChildViewController:c2];
   
         //c.2第二种方式
         tb.viewControllers=@[uiMainCtrl,c2,c3,c4];
    
       //2.设置Window为主窗口并显示出来
         [self.window makeKeyAndVisible];

    // 要使用百度地图，请先启动BaiduMapManager
//    _mapManager = [[BMKMapManager alloc]init];
//    BOOL ret = [_mapManager start:BMAPKEY generalDelegate:self];
//
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }

    self.bmkMapManager=[[BMKMapManager alloc] init];
  BOOL ret=  [self.bmkMapManager start:BMAPKEY generalDelegate:self];
        if (!ret) {
            NSLog(@"manager start failed定位失败!");
        }
         return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
@end
