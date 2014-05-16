//
//  NetWorkWatchDogManager
//  网络监听程序
//
//  Created by Sean Li on 13-9-5.
//

#import "NetWorkWatchDogManager.h"
#import "EMELPSocketManager.h"

static int autoLoginBuildSocketCount = 0;//用来统计自动重新建立socket自动登录

static NetWorkWatchDogManager*  s_network_WatckDog = nil;

@interface NetWorkWatchDogManager()
@property(nonatomic,strong)Reachability* reachabilityDetector;
@property(nonatomic,assign)NetworkStatus  networkStatus;
@property(nonatomic,assign)SocketStatus  socketStatus;//是否和服务端socket连接
@end

@implementation NetWorkWatchDogManager

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)init
{
    self = [super init];
    if (self) {
        //网络状态变更通知处理
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rechabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        //socket 连接状态处理
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(socketConnectStatusChanged:)
                                                     name:ChatSocketConnectStatusNotice
                                                   object:nil];
        //socket  请求网络状态处理
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(socketRequestSlowStatusChanged:)
                                                     name:ChatSocketRequestSlowNotice
                                                   object:nil];
        //需要自动登录
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(socketRequestNeedRegisterHandle:)
                                                     name:ChatSocketRequestNeedRegisterNotice
                                                   object:nil];
        
        self.networkStatus = [self.reachabilityDetector currentReachabilityStatus];
    }
    return self;
}

+(NetWorkWatchDogManager*)shareInstance
{
    @synchronized(self){
        if (nil == s_network_WatckDog) {
            s_network_WatckDog = [[self alloc] init];
        }
    }
    return s_network_WatckDog;
}


+(void)destroyInstance
{
    if (nil != s_network_WatckDog) {
        [s_network_WatckDog stopWatchDog];
        s_network_WatckDog = nil;
    }

}


/*
 *开始网络看守
 *在程序开始启动的时候调用
 */

-(void) startWatchDog
{
    [self.reachabilityDetector startNotifier];
    _networkStatus = [self.reachabilityDetector currentReachabilityStatus];

}

/**
 * 停止网络看守
 * 在程序退出调用
 */
-(void) stopWatchDog
{
    [self.reachabilityDetector stopNotifier];
}


#pragma mark 网络状态检查

- (void)refrushCurrentNetworkStatus:(Reachability*)currentReach
{
    if ([currentReach isKindOfClass:[Reachability class]])
    {
        NetworkStatus netStatus = [currentReach currentReachabilityStatus];
        self.networkStatus = netStatus;
        switch (netStatus)
        {
            case NotReachable:
            {
                NIF_ALLINFO(@"没有网络");
                [self sendAlertMsgViewWithMsg:@"网络连接断开，请检查你的网络"];
				break;
            }
            case ReachableViaWiFi:
            {
              
                NIF_ALLINFO(@"wiFi 环境");
                break;
            }
                
            case ReachableViaWWAN:
            {
                NIF_ALLINFO(@"WWAN 环境");
                 break;
            }
            default:
                break;
        }
    }
    
    if ([self isHaveNetWork]) {
        //切换到有网络，需要延时进行socket 连接 和自动登录
        [self performSelector:@selector(autoLoginForNetworkChangedAndBuildSocketConnect) withObject:nil afterDelay:3.0];
    }

}

#pragma mark socket状态处理， 主要是处理连接成功、连接断开

//SocketStatus  = SocketStatusForConnectSuccess | SocketStatusForConnectCloseOrFail
-(void)socketConnectStatusChanged:(NSNotification*)notification
{
    NSDictionary* socketStatusDic = [notification object];
    if (socketStatusDic != nil) {
        self.socketStatus = [[socketStatusDic objectForKey:@"SocketStatus"]  integerValue] ;
    }else{
        NIF_ALLINFO(@"socket 连接状态通知错误");
    }

//  #warning 如果socket 连接失败，是否还需要去自动登录逻辑
    if (![self isSocketConnet]) {
        [self performSelector:@selector(autoLoginForNetworkChangedAndBuildSocketConnect) withObject:nil afterDelay:3.0];
    }
}


//网络变化导致的自动登录
-(void)autoLoginForNetworkChangedAndBuildSocketConnect
{
    //1. 如果不能自动登录，则不要重新登录，已经
    if (![[UserManager shareInstance] can_auto_login]) {
        return;
    }
    //2. 表示有网络,但是socket断开
    if (![self isSocketConnet]  && [self isHaveNetWork]) {
        NIF_ALLINFO(@"有网络，但是socket 已经断开");
        //需要重新连接socket 并且登录
        
         //3. 不是背景模式触发自动socket 连接
        if (![self isBackGroundRunMode]) {
            NIF_ALLINFO(@"前台运行需要自动连接");

            //4. 再确认一次socket 没有连接
            if (![[EMELPSocketManager shareInstance] isSocketConnect]) {
                autoLoginBuildSocketCount ++;
                if (autoLoginBuildSocketCount < 3) {
                    [[EMELPSocketManager shareInstance] startSocketConnect];
                }else{
                    NIF_ALLINFO(@"连接不上服务器，或者是服务端不稳定");
                    [self  performSelector:@selector(ClearAutoLoginBuildSocketCount) withObject:nil afterDelay:3*60];
                }
            }
 
        }else{
            NIF_ALLINFO(@"是背景运行不用自动连接");
        }
    }
}


-(void)ClearAutoLoginBuildSocketCount
{
    autoLoginBuildSocketCount = 0;
}

#pragma mark  socket响应缓慢，
//在发送每个socket请求之前，会先确认网络，如果网络超过9秒未做出响应，则认为socket 应该断开重新连接
-(void)socketRequestSlowStatusChanged:(NSNotification*)notification
{
    [self sendAlertMsgViewWithMsg:@"网络不给力，稍后再试"];
    NIF_ALLINFO(@"socket 缓慢的连接失败");
 }


//只处理socket服务注册
-(void)socketRequestNeedRegisterHandle:(NSNotification*)notification
{
    [[EMELPSocketManager shareInstance] registerToSocketServer];
}


////用于一个新的进程来执行
//-(void)autoWaitLoginForNewThread
//{
//    //尝试三次等待
//    int count = 30;
//    while (![[EMELPSocketManager shareInstance]  isSocketConnect]) {
//        count --;
//        sleep(1);//等待1秒
//        if (count == 0) {
//            break;
//        }
//        //如果木有网络直接退出
//        if (![self isHaveNetWork]) {
//            break;
//            return;
//        }
//    }
//    
//    if ([[EMELPSocketManager shareInstance]  isSocketConnect]) {
//          //不是背景模式的时候，给一个提示
//        if (![self isBackGroundRunMode]) {
//            [[EMELPSocketManager shareInstance] registerToSocketServer];
//        }
//    }
//    //否则 等等slow 网络提示
//}



- (void)rechabilityChanged:(NSNotification*)notification
{
    Reachability *currentReach = [notification object];
    [self refrushCurrentNetworkStatus:currentReach];
}

// 提示框统一控制
-(void)sendAlertMsgViewWithMsg:(NSString*)msg
{
     //不是背景模式的时候，给一个提示
    if (![self isBackGroundRunMode]) {
        //为了防止多次提示网络问题，这里设置存储一个时间
        NSDate* latestAlertRecordDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"networkLatestAlertDate"];
        if ( ([latestAlertRecordDate timeIntervalSince1970]+ 1.5*60) < [[NSDate date] timeIntervalSince1970]) {
            return;
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"networkLatestAlertDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [CommonUtils AlertWithTitle:@"提示" Msg:msg];
         }
    }
}

#pragma mark 是什么网络
- (BOOL) isReachableViaWWAN
{
 return  self.networkStatus == ReachableViaWWAN ? YES : NO;
}
- (BOOL) isReachableViaWiFi
{
    return  self.networkStatus == ReachableViaWiFi ? YES : NO;
}
- (BOOL) isHaveNetWork
{
    BOOL haveNetWork =  self.networkStatus == NotReachable ? NO: YES;
    if (!haveNetWork) {
        [self sendAlertMsgViewWithMsg:@"网络连接断开，请检你的网络"];
    }
    return haveNetWork;
}

+ (BOOL) isConnectNetWork {
    BOOL haveNetWork =  [self.class shareInstance].networkStatus == NotReachable ? NO: YES;
    return haveNetWork;
}

-(BOOL) isSocketConnet
{
    return self.socketStatus == SocketStatusForConnectSuccess ? YES :NO;
}


//是否是背景运行状态
-(BOOL)isBackGroundRunMode
{
  return  [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
    
}
#pragma mark - getter

-(Reachability*)reachabilityDetector
{
    if (nil == _reachabilityDetector) {
        _reachabilityDetector = [Reachability reachabilityForInternetConnection];
    }
    return _reachabilityDetector;
}

-(NetworkStatus)networkStatus
{
    _networkStatus = [self.reachabilityDetector currentReachabilityStatus];
    return _networkStatus;


}



@end
