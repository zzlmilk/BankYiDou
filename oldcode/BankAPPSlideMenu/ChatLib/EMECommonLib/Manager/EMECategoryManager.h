
#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "EMEURLConnection.h"
static NSString *const EMENoticeDownloadfinishedNotification         = @"EMENoticeDownloadfinishedNotification";
@protocol EMECategoryManagerDelegate<NSObject>

- (void)categoryManagerDidFinishLoad:(id)manager;

@end


@protocol AppVersionUpdateDelegate<NSObject>

-(void)appVersionChecked:(NSDictionary *)info;

@end


@interface EMECategoryManager : NSObject <EMEURLConnectionDelegate>{
	NSString		*currentVersion;
	
    EMEURLConnection *categoryConnection;
    EMEURLConnection *versionConnection;
    EMEURLConnection *getTeamConnection;
    EMEURLConnection *getAreaConnection;
}
	
@property (nonatomic, strong)  NSDictionary *categories;
@property (nonatomic, assign)  id <EMECategoryManagerDelegate>delegate;
@property (nonatomic, assign,readonly)  id <AppVersionUpdateDelegate> appVersionUpdateDelegate;
@property (nonatomic, readonly) NSString *currentVersion;
@property (nonatomic, readonly) NSDictionary *serverVersionInfo;
@property (nonatomic, strong)   NSDictionary *numOfCouponDic;


+ (EMECategoryManager *)shareCategoryManager;

+ (BOOL)doesCategoryExist;

- (BOOL)dontAlertForVersion:(NSString *)version;
- (void)setDontAlertForVersion:(NSString *)version;

//检查颁布
- (void)checkAppVersionWithReceiver:(id)receiver;

//请求在线商城分类数据
- (void)catchCategory;

//请求团队数据
- (void)catchTeam;

//请求城市配置数据
- (void)catchArea;

//请求系统公告数据
- (void)catchNotice;


//从本地取分类数据
-(NSArray *)GetCategoryData;

//从本地取团队数据
-(NSArray *)GetTeamData;

//从本地取省数据
-(NSArray *)GetProvinceData;

//从本地市，区数据
-(NSArray *)GetCityDataByPid:(int)provinceId;

//从本地取公告数据
-(NSDictionary *)getNotice;

@end
