
#import "EMECategoryManager.h"
#import "NSString+Category.h"
#import "UserManager.h"
#import "EMEConstants.h"
#import "NSObject+Universal.h"
#import "EMEConfigManager.h"



static EMECategoryManager *shareCategoryManager = nil;

@interface EMECategoryManager (Private)

- (NSDictionary *)categoriesFromFile;
- (NSString *)categoryPath;
- (NSString *)categoryPathByCityCode:(NSString *)cityCode;
- (id)templateCollectionByName:(NSString *)template cityCode:(NSString *)cityCode;

@end


@implementation EMECategoryManager

@synthesize currentVersion;
@synthesize categories;
@synthesize appVersionUpdateDelegate = _appVersionUpdateDelegate;
@synthesize serverVersionInfo = _serverVersionInfo;
+ (EMECategoryManager *)shareCategoryManager {
	@synchronized(self) {
		if (shareCategoryManager == nil) {
			shareCategoryManager = [[EMECategoryManager alloc] init];
		}
		return shareCategoryManager;
	}
}
+ (BOOL)doesCategoryExist
{
    NIF_ERROR(@"未现实改方法");
    return NO;
}
- (id)init {
	if (self = [super init]) {
	}
	return self;
}

- (void)dealloc {
	_delegate = nil;
    _appVersionUpdateDelegate = nil;
 	self.categories = nil;
}


- (NSString *)currentCategoryVersion {
#ifdef DEBUG 		
	return @"0.0.0";
#else
	NSString *version = [[self categories] valueForKeyPath:@"infoMap.data_version"];
	if (version) {
		return version;
	} else {
		return @"0.0.0";
	}
#endif	
}
	////////////////////////////////////////////////////////////////////////////
- (NSString *)currentVersion {
		//	if (categories == nil) {
	self.categories = [self categoriesFromFile];
		//	}
	
	if (categories) {
		NSString *version = [categories valueForKeyPath:@"infoMap.version"];
		if (version) {
			return version;
		} else {
			return @"1.0.0";
		}
	} else {
		return @"1.0.0";
	}
	
}

- (NSDictionary *)categories {
    NSString *path = [self categoryPath];
	if (!path) return nil;
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
	if (dic) return dic;
	
	return nil;

}

-(NSArray *)GetCategoryData{
    NSString *path = [self categoryPath];
	if (!path) return nil;
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *dic1 = [dic objectForKey:@"result"];
    if (dic1 && [[dic1 objectForKey:@"status"] isEqualToString:@"0"]) {
        NSArray *arr = [dic1 objectForKey:@"content"];
        if (arr){
            return arr;
        }else{
            return nil;
        }
    }
	return nil;
}

-(NSArray *)GetTeamData{
    NSString *path = [self teamPath];
	if (!path) return nil;
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *dic1 = [dic objectForKey:@"result"];
    if (dic1 && [[dic1 objectForKey:@"status"] isEqualToString:@"0"]) {
        NSArray *arr = [dic1 valueForKeyPath:@"content.teamitems"];
        if (arr){
            NIF_TRACE(@"team:%@",arr);
            return arr;
        }else{
            return nil;
        }
    }
	return nil;
}
 
-(NSArray *)GetProvinceData{
    NSString *path = [self areaPath];
	if (!path) return nil;
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *dic1 = [dic objectForKey:@"result"];
    if (dic1 && [[dic1 objectForKey:@"status"] isEqualToString:@"0"]) {
        NSArray *arr = [dic1 valueForKeyPath:@"content.areaitems"];
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (NSDictionary *d in arr) {
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:[d objectForKey:@"id"],@"id",[d objectForKey:@"name"],@"name", nil];
            [tmpArray addObject:tmpDic];
        }
        if (tmpArray){
            NIF_TRACE(@"Province:%@",tmpArray);
            return tmpArray;
        }else{
            return nil;
        }
    }
	return nil;
}


-(NSArray *)GetCityDataByPid:(int)provinceId{
    NSString *path = [self areaPath];
	if (!path) return nil;
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *dic1 = [dic objectForKey:@"result"];
    if (dic1 && [[dic1 objectForKey:@"status"] isEqualToString:@"0"]) {
        NSArray *arr = [dic1 valueForKeyPath:@"content.areaitems"];
        for (NSDictionary *d in arr) {
            if ([[d objectForKey:@"id"] intValue] == provinceId) {
                return [d objectForKey:@"areaitems2"];
            }
        }
    }
	return nil;
}

-(NSDictionary *)getNotice{
    NSString *path = [self noticePath];
	if (!path) return nil;
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
	if (dic) return dic;
	
	return nil;
}

- (NSDictionary *)categoriesFromFile {
	NSString *path = [self categoryPath];
	if (!path) return nil;
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
	if (dic) return dic;
	return nil;	
}

- (void)catchCategory {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:emptyString([UserManager shareInstance].user.userId),@"userid",@"",@"code", nil];
    NSDictionary *urlDic = [NSDictionary dictionaryWithObjectsAndKeys:@"S_TRADE",@"service",@"CATEGORY",@"function", dic,@"param",nil];
	NSString *url = EMERequestURL;
    categoryConnection = [EMEURLConnection connectionWithDelegate:self connectionTag:EMEURLConnectionTagSecond];
    getAreaConnection.isHiddenLoadingView = YES;
    [categoryConnection connectToURL:url params:urlDic];
}

- (void)catchTeam {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:emptyString([UserManager shareInstance].user.userId),@"userid", nil];
    NSDictionary *urlDic = [NSDictionary dictionaryWithObjectsAndKeys:@"S_PERSON",@"service",@"GET_TEAM",@"function", dic,@"param",nil];
	NSString *url = EMERequestURL;
    getTeamConnection = [EMEURLConnection connectionWithDelegate:self connectionTag:EMEURLConnectionTagThird];
    getAreaConnection.isHiddenLoadingView = YES;
    [getTeamConnection connectToURL:url params:urlDic];
}

- (void)catchArea {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:emptyString([UserManager shareInstance].user.userId),@"userid",nil];
    NSDictionary *urlDic = [NSDictionary dictionaryWithObjectsAndKeys:@"S_PERSON",@"service",@"GET_AREA",@"function", dic,@"param",nil];
	NSString *url = EMERequestURL;
    getAreaConnection = [EMEURLConnection connectionWithDelegate:self connectionTag:EMEURLConnectionTagForth];
    getAreaConnection.isHiddenLoadingView = YES;
    [getAreaConnection connectToURL:url params:urlDic];
}

- (void)catchNotice {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:emptyString([UserManager shareInstance].user.userId),@"uid",nil];
    NSDictionary *urlDic = [NSDictionary dictionaryWithObjectsAndKeys:@"S_NOTICE",@"service",@"GET_NOTICEDATA",@"function", dic,@"param",nil];
	NSString *url = EMERequestURL;
    getAreaConnection = [EMEURLConnection connectionWithDelegate:self connectionTag:EMEURLConnectionTagFifth];
    getAreaConnection.isHiddenLoadingView = YES;
    [getAreaConnection connectToURL:url params:urlDic];
}

- (void)checkAppVersionWithReceiver:(id)receiver {
    _appVersionUpdateDelegate = receiver;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:emptyString([UserManager shareInstance].user.userId),@"uid",[[EMEConfigManager shareConfigManager] getAppVersion],@"product_ver",[[EMEConfigManager shareConfigManager] getAppVersion],@"file_ver",nil];
    NSDictionary *urlDic = [NSDictionary dictionaryWithObjectsAndKeys:@"S_UPGRADE",@"service",@"GET_UPDATEINFO",@"function", dic,@"param",nil];
	NSString *url = EMERequestURL;
    versionConnection = [EMEURLConnection connectionWithDelegate:self connectionTag:EMEURLConnectionTagFirst];
	[versionConnection connectToURL:url params:urlDic];
}

static NSString *versionAlertKey = @"versionAlertKey-";

- (BOOL)dontAlertForVersion:(NSString *)version {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@-%@",versionAlertKey,version]];
}

- (void)setDontAlertForVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-%@",versionAlertKey,version]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/////////////////////////////////////////////////////////////////////////////
// EMEURLConnectionDelegate
- (void)dURLConnection:(EMEURLConnection *)connection didFinishLoadingJSONValue:(NSDictionary *)json
{
	if(connection.connectionTag == EMEURLConnectionTagSecond) {
        NSDictionary *dic = [json objectForKey:@"result"];
        if (dic && [[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            if ([json writeToFile:[self categoryPath] atomically:YES]) {
            }
        }
   
        if ([_delegate respondsToSelector:@selector(categoryManagerDidFinishLoad:)]) {
            [_delegate categoryManagerDidFinishLoad:self];
        }
    }else if (connection.connectionTag == EMEURLConnectionTagThird){
        NSDictionary *dic = [json objectForKey:@"result"];
        if (dic && [[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            if ([json writeToFile:[self teamPath] atomically:YES]) {
            }
        }
    }else if (connection.connectionTag == EMEURLConnectionTagForth){
        NSDictionary *dic = [json objectForKey:@"result"];
        if (dic && [[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            if ([json writeToFile:[self areaPath] atomically:YES]) {
            }
        }
    }else if (connection.connectionTag == EMEURLConnectionTagFifth){
        NSDictionary *dic = [json objectForKey:@"result"];
        if (dic && [[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            if ([[dic valueForKeyPath:@"content"] writeToFile:[self noticePath] atomically:YES]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:EMENoticeDownloadfinishedNotification object:nil userInfo:nil];
            }
        }
    }else if(connection.connectionTag == EMEURLConnectionTagFirst){ 
         _serverVersionInfo =[json valueForKeyPath:@"result"];
      
		if ([_appVersionUpdateDelegate respondsToSelector:@selector(appVersionChecked:)]) {
			[_appVersionUpdateDelegate appVersionChecked:_serverVersionInfo];
		}
    }
}
 

- (void)dURLConnection:(EMEURLConnection *)connection didFailWithError:(NSError *)error
{

}

- (NSString *)categoryPath{
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	return [docDir stringByAppendingPathComponent:SANDBOX_CATEGORY_GROUP_PATH];
}

- (NSString *)teamPath{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	return [docDir stringByAppendingPathComponent:SANDBOX_TEAM_PATH];
}

- (NSString *)areaPath{
    return [[NSBundle mainBundle]pathForResource:SANDBOX_AREA_PATH ofType:@""];
}


- (NSString *)noticePath{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	return [docDir stringByAppendingPathComponent:SANDBOX_NOTICE_PATH];
}

@end
