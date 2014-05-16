//
//  EMEBaseDataManager.m
//  EMEAPP
//
//  Created by YXW on 13-11-5.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMEBaseDataManager.h"
#import "EMEConstants.h"

@interface EMEBaseDataManager ()
@property BOOL hideLoadingView;
@end
@implementation EMEBaseDataManager

-(void)dealloc
{
    _delegate = nil;
}

-(id)init{
    if (self == [super init]) { 
        urlDic = nil;
        paramDic = nil;
    }
    return self;
}

-(void)clearDelegate:(Class)delegateClass
{
    
    if ([self.delegate isKindOfClass:delegateClass]) {
        self.delegate = nil;
    }
    
}

-(EMEURLConnection*)sendHttpRequestWithParameterDic:(NSDictionary*)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag
{
    if ([[parameterDic objectForKey:@"pagenum"] intValue] > 1) {
        _hideLoadingView = YES;
    }else{
        _hideLoadingView = NO;
    }
 return  [self sendHttpRequestWithParameterDic:parameterDic
                                   ServiceType:serviceType
                             WithURLConnection:URLConnection
                                  FunctionName:functionName
                                       WithTag:tag
                               isHiddenLoading:_hideLoadingView];
}

-(EMEURLConnection*)sendHttpRequestWithParameterDic:(NSDictionary*)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag
                                    isHiddenLoading:(BOOL)isHiddenLoading
{
    if (URLConnection == nil) {
        URLConnection = [[EMEURLConnection alloc] initWithDelegate:self connectionTag:tag];
    } else {
        [URLConnection cancel];
        URLConnection.delegate = self;
        URLConnection.connectionTag = tag;
    }
    URLConnection.isHiddenLoadingView = isHiddenLoading;
    urlDic = [NSDictionary dictionaryWithObjectsAndKeys:[self getEMEServiceNameWithServieType:serviceType],@"service",functionName,@"function", parameterDic,@"param",nil];
    [URLConnection connectToURL:EMERequestURL params:urlDic];
    
    return URLConnection;
}

-(EMEURLConnection*)postHttpRequestWithParameterImageArray:(NSArray*)imageArray
                                              ParameterDic:(NSDictionary *)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag{
    if (URLConnection == nil) {
        URLConnection = [[EMEURLConnection alloc] initWithDelegate:self connectionTag:tag];
    } else {
        [URLConnection cancel];
        URLConnection.delegate = self;
        URLConnection.connectionTag = tag;
    }
    urlDic = [NSDictionary dictionaryWithObjectsAndKeys:[self getEMEServiceNameWithServieType:serviceType],@"service",functionName,@"function", parameterDic,@"param",nil];
    [URLConnection postImageArray:imageArray url:EMEURL_UPLOADIMAGE params:urlDic];
    
    return URLConnection;
}

-(EMEURLConnection*)postHttpRequestWithImage:(UIImage*)image
                                ParameterDic:(NSDictionary *)parameterDic
                                 ServiceType:(EMEServiceType)serviceType
                           WithURLConnection:(EMEURLConnection*)URLConnection
                                FunctionName:(NSString*)functionName
                                     WithTag:(int)tag{
    return [self postHttpRequestWithParameterImageArray:[NSArray arrayWithObject:image] ParameterDic:parameterDic ServiceType:serviceType WithURLConnection:URLConnection FunctionName:functionName WithTag:tag];
}


#pragma mark - define
-(NSString*)getEMEServiceNameWithServieType:(EMEServiceType)ServiceType
{
    NSString* ServiceName = nil;
    switch (ServiceType) {
        case EMEServiceTypeForLPFamily:
        {
            ServiceName = @"S_LP";
            break;
        }
        case EMEServiceTypeForTrade:
        {
            ServiceName = @"S_TRADE";
            break;
        }
        case EMEServiceTypeForPersonCenter:
        {
            ServiceName = @"S_PERSON";
            break;
        }
        case EMEServiceTypeForGroupMien:
        {
            ServiceName = @"S_TEAM";
            break;
        }
        case EMEServiceTypeForClinic:
        {
            ServiceName = @"S_COMHELP";
            break;
        }
        case EMEServiceTypeForFiscal:
        {
            ServiceName = @"S_FUND";
            break;
        }
        case EMEServiceTypeForActivity:
        {
            ServiceName = @"S_EVENT_SERVICE";
            break;
        }
        case EMEServiceTypeForTalent:
        {
            ServiceName = @"S_TALENT_SERVICE";
            break;
        }
        case EMEServiceTypeForMap:{
            ServiceName = @"S_MAP";
            break;
        }
        case EMEServiceTypeForNews:
        {
            ServiceName = @"S_NEWS";
            break;
        }
        case EMEServiceTypeForNotice:
        {
            ServiceName = @"S_NOTICE";
            break;
        }
        case EMEServiceTypeForRecommend:{
            ServiceName = @"S_RECOMMEND";
            break;
        }
        case EMEServiceTypeForCases:{
            ServiceName = @"S_CASES";
            break;
        }
        case EMEServiceTypeForCommon:{
            ServiceName = @"S_CHCOMMENT";
            break;
        }
        case EMEServiceTypeForShop:{
            ServiceName = @"S_SHOP";
            break;
        }
        case EMEServiceTypeForRecruit:
        {
            ServiceName = @"S_RECRUIT";
            break;
        }
        case EMEServiceTypeForMerchants:
        {
            ServiceName = @"S_BUSINESS_JOIN";
            break;
        }
        case EMEServiceTypeForAboutUs:
        {
            ServiceName = @"S_COMPANY";
            break;
        }
        default:
            ServiceName = @"";
            break;
    }
    return ServiceName;
}

#pragma mark - EMEURLConnectionDelegate

- (void)dURLConnection:(EMEURLConnection *)connection didFinishLoadingJSONValue:(NSDictionary *)json{
    NSDictionary *dic = [json objectForKey:@"result"];
    NIF_INFO(@"tag:%d 响应的结果 :%@    %@",connection.connectionTag ,dic,_delegate);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLoadingJSONValue:URLConnection:)]) {
        [self.delegate didFinishLoadingJSONValue:dic URLConnection:connection];
    }
}

- (void)dURLConnection:(EMEURLConnection *)connection didFailWithError:(NSError *)error
{
    NIF_INFO(@"EMEURLConnection 响应的结果 :%@  ",error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailWithError:URLConnection:)]) {
        [self.delegate didFailWithError:error URLConnection:connection];
    }
}


@end
