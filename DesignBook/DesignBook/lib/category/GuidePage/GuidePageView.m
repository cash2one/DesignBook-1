//
//  GuidePageView.m
//  引导页-UIPageControl
//
//  Created by 陈行 on 15-11-10.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "GuidePageView.h"
#import "UIImageView+WebCache.h"

@interface GuidePageView()<UIScrollViewDelegate>
/*定时器*/
@property(nonatomic,strong) NSTimer * timer;

/*是否自动播放*/
@property(nonatomic,assign)BOOL isAutoPlay;
/*自动播放事件间隔*/
@property(nonatomic,assign)NSInteger timeInterval;
/*是否循环播放，此条件必须在isAutoPlay为true的情况下才有效*/
@property(nonatomic,assign)BOOL isCirculationPlay;

@end

@implementation GuidePageView

+ (GuidePageView *)guidePageViewWithBackGroundImage:(NSString *)imageName andFrame:(CGRect)frame andIsWebImage:(BOOL)isWebImage{
    return [[self alloc]initWithBackGroundImage:imageName andFrame:frame andIsWebImage:isWebImage];
}
- (GuidePageView *)initWithBackGroundImage:(NSString *)imageName andFrame:(CGRect)frame andIsWebImage:(BOOL)isWebImage{
    if(self=[super initWithFrame:frame]){
        if(imageName!=nil){
            UIImageView * imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
            imageView.frame=self.bounds;
            [self addSubview:imageView];
            self.backgroundImage=imageView;
        }
        
        self.isWebImage=isWebImage;
    }
    return self;
}

/**
 *  设置引导页的图片名称
 */
- (void)setImagesArray:(NSArray *)imagesArray{
    _imagesArray=imagesArray;
    CGFloat width=self.bounds.size.width;
    CGFloat height=self.bounds.size.height;
    
    UIScrollView * scrollView=[[UIScrollView alloc]init];
    scrollView.frame=CGRectMake(0, 0, width, height);
    scrollView.contentSize=CGSizeMake(width*imagesArray.count, height);
    //自动分页
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    scrollView.bounces=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:scrollView];
    self.scrollView=scrollView;
    
    
    for(int i=0;i<imagesArray.count;i++){
        CGFloat x=width*i;
        CGFloat y=0;
        NSString * name=imagesArray[i];
        UIImageView * imageView=[[UIImageView alloc]init];
        //不全部拉伸，只拉伸到最短边
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        
        if(self.isWebImage){
            [imageView sd_setImageWithURL:[NSURL URLWithString:name]];
        }else{
            NSString * path=[[NSBundle mainBundle]pathForResource:name ofType:nil];
            UIImage * image=[[UIImage alloc]initWithContentsOfFile:path];
            imageView.image=image;
        }
        imageView.frame=CGRectMake(x, y, width, height);
        [scrollView addSubview:imageView];
    }
    //引导页
    UIPageControl * pageCon=[[UIPageControl alloc]init];
    pageCon.numberOfPages=imagesArray.count;
    pageCon.frame=CGRectMake(width*0.5, height-25, 0, 0);
    pageCon.currentPageIndicatorTintColor=[UIColor orangeColor];
    pageCon.pageIndicatorTintColor=[UIColor purpleColor];
    
    [self addSubview:pageCon];
    self.pageCon=pageCon;
    
    
}

-(void)startTimer{
    if(self.isAutoPlay==true){
        NSTimer * timer =  [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoPlay) userInfo:nil repeats:YES];
        self.timer = timer;
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)autoPlay{
    long page = self.pageCon.currentPage;
    //判断是否是最后一页，并且设定循环播放
    if(page == self.imagesArray.count-1 && self.isCirculationPlay!=true){
        [self.timer invalidate];
        self.timer = nil;
    }else{
        page = page >= self.imagesArray.count-1? 0 :  page + 1;
        self.scrollView.contentOffset = CGPointMake(page * self.scrollView.frame.size.width, 0);
    }
}
/**
 *  设置是否自动播放，循环播放，播放间隔
 */
- (void)setAutoPlay:(BOOL)isAutoPlay andCirculationPlay:(BOOL)isCirculationPlay andTimeInterval:(NSInteger)timeInterval{
    _isAutoPlay=isAutoPlay;
    if(timeInterval<=0){
        timeInterval=1;
    }
    _timeInterval=timeInterval;
    _isCirculationPlay=isCirculationPlay;
    [self startTimer];
}


//最后一页的按钮点击进入app页面事件
- (void)openAppBtnTouch:(UIButton *)btn{
    NSLog(@"openAppBtnTouch打开");
    [self.delegate btnTouchToOpenApp:self];
}

/**
 *  滑动事件
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page=(scrollView.contentOffset.x+scrollView.frame.size.width*0.5)/scrollView.frame.size.width;
    //如果最后一页设置为不打开，则最后一页不会生成一个按钮
    if(self.isOpenAppBtn==false){
        
    }else if(page+1==self.imagesArray.count){
        if(self.openAppBtn==nil){
            CGFloat btnW=200;
            CGFloat btnH=70;
            CGFloat btnX = self.frame.size.width*0.5-btnW*0.5;
            CGFloat btnY = self.frame.size.height-165;
            CGRect frame=CGRectMake(btnX, btnY, btnW, btnH);
            UIButton * openAppBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            BOOL r= CGRectEqualToRect(self.openAppBtnFrame,CGRectZero);
            if(r==true){
                openAppBtn.frame=frame;
            }else{
                openAppBtn.frame=self.openAppBtnFrame;
            }
            
            //            openAppBtn.backgroundColor=[UIColor redColor];
            [openAppBtn addTarget:self action:@selector(openAppBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:openAppBtn];
            self.openAppBtn=openAppBtn;
        }else{
            self.openAppBtn.userInteractionEnabled=YES;
        }
    }else{
        self.openAppBtn.userInteractionEnabled=NO;
    }
    self.pageCon.currentPage=page;
}
//准备开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //timer 一旦调用invalidate之后,就不能够重新启动,必须重新创建
    [self.timer invalidate];
    self.timer = nil;
}
//滑动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

@end
