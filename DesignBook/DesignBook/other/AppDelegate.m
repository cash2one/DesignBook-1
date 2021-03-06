//
//  AppDelegate.m
//  DesignBook
//
//  Created by 陈行 on 16-1-2.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@property(nonatomic,strong)CustomTabbar * myTabbar;

@end

@implementation AppDelegate

+(CustomTabbar *)getTabbar{
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.myTabbar;
}

- (void)createMyTabbarWith:(UITabBarController *)tbc{
    tbc.tabBar.hidden=YES;
    
    NSArray * tabbarArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tabbar.plist" ofType:nil]];
    NSMutableArray * itemArray=[[NSMutableArray alloc]init];
    NSMutableArray * viewCons=[[NSMutableArray alloc]init];
    for (NSDictionary * dict in tabbarArray) {
        CustomTabbarItem * item = [CustomTabbarItem tabbarItemWithDict:dict];
        [itemArray addObject:item];
        
        RootViewController * con= [[NSClassFromString([NSString stringWithString:item.controller]) alloc]init];
        
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:con];
        [viewCons addObject:nav];
    }
    tbc.viewControllers=viewCons;
    
    
    CustomTabbar * tabbar=[CustomTabbar tabbarWithTabbarItemArray:itemArray andTabbarController:tbc];
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    view.backgroundColor=[UIColor grayColor];
    [tabbar addSubview:view];
    
    [tbc.view addSubview:tabbar];
    tabbar.frame=CGRectMake(0, HEIGHT-49, WIDTH, 49);
    [tbc.view bringSubviewToFront:tabbar];
    self.myTabbar=tabbar;
    tabbar.currentIndex=0;
    
}






#pragma mark - 系统代理方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SQLiteManager checkAndUpdateDatabaseVersion];
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    UITabBarController * tbc=[[UITabBarController alloc]init];
    
    [self createMyTabbarWith:tbc];
    
    self.window.rootViewController=tbc;
    
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

@end
