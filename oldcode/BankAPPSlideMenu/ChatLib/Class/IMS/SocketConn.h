//
//  SocketConn.h
//  ims
//
//  Created by Tony Ju on 10/16/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "MessageDelegate.h"


typedef enum {
    SocketStatusForConnectSuccess =0,//表示socket 连接成功
    SocketStatusForConnectCloseOrFail//表示socket 连接失败
} SocketStatus;

@interface SocketConn : NSObject <GCDAsyncSocketDelegate>
{
    BOOL isRun;
}
@property (nonatomic, strong) NSData * bankData;
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, assign) id<MessageHandlerDelegate> delegate;

+(SocketConn*)shareInstanceWithMessageHandlerDelegate:(id<MessageHandlerDelegate>) delegate;
+(SocketConn*)shareInstance;//共享实例
+(void)destroyInstance;//销毁实例

-(id)initWithMessageHandlerDelegate:(id<MessageHandlerDelegate>) delegate;

-(void) sendMessage: (NSData *) message;
-(void) registration;
-(BOOL) connect;
-(BOOL) isConnected;
-(BOOL) disconnect;
@end