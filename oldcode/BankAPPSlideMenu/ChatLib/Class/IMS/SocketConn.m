
//
//  SocketConn.m
//  ims
//
//  Created by Tony Ju on 10/16/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import "SocketConn.h"
#import "Message.h"
#import "MessageCodec.h"
#import "Constants.h"
#import "MessageDelegate.h"
#import "StringUtils.h"
#import "EMEChatConfManager.h"

@interface SocketConn()

//@property(atomic,strong)NSMutableData *bufferData;
@property (strong, nonatomic) NSData * data;

@end

@implementation SocketConn
@synthesize bankData;

static SocketConn*  s_socketConn = nil;


+(SocketConn*)shareInstanceWithMessageHandlerDelegate:(id<MessageHandlerDelegate>) delegate
{
    @synchronized(self){
        
        if (s_socketConn == nil) {
            s_socketConn = [self.class shareInstance];
        }
        s_socketConn.delegate = delegate;
    }
    return s_socketConn;
    
}

+(SocketConn*)shareInstance
{
    @synchronized(self){
        if (s_socketConn == nil) {
            s_socketConn =  [[self.class alloc] init];
        }
    }
        return  s_socketConn;
}


+(void)destroyInstance
{
    if (nil != s_socketConn) {
        s_socketConn = nil;
    }
}




-(void)dealloc
{
    _socket.delegate = nil;
}

-(id)init
{
    self = [super init];
    if (self) {
//        _bufferData = [[NSMutableData alloc] init];
     }
    
    return self;
}

-(id) initWithMessageHandlerDelegate :(id<MessageHandlerDelegate>) delegate {
    
   self = [self init];
    
    if (self) {
        self.delegate  = delegate;
    }
    
    return self;
}

-(BOOL)connect{
    
    BOOL result = NO;
    // 判断是否连接,如果没有连接
    if (![_socket isConnected]) {
        [self.socket disconnect];
        // 连接服务器
        
        __weak SocketConn* weakSelf = (SocketConn*)self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

          NSError *err = nil;
         [weakSelf.socket connectToHost:ChatServerHost onPort:ChatServerPort error:&err];
        
            if (err) {
//                NIF_ALLINFO(@"connect error %@",err);
            }
            
        });
        
  
        
    }else{
        result = YES;
    }
    
    return result;
    
}

-(BOOL) isConnected {
    return ![self.socket isDisconnected];
}
-(BOOL) disconnect
{
    [self.socket disconnectAfterWriting];
    return YES;
}

-(void) registration {
    Message *message = [[Message alloc] init];
    NSUUID *uuid = [[NSUUID alloc] init];
    message.uid = [uuid UUIDString];
    message.from = [StringUtils getFixedUUId];
    message.commandId =COMMAND_REGISTRATION;
    message.direction = MSG_DIRECTION_CLIENT_TO_SERVER;
//    message.contents = [[NSData alloc] initWithBase64Encoding:@"registration"];
    
    [self sendMessage:[MessageCodec encodeRegister :message:0]];
}

-(void) sendMessage: (NSData *) message{
    
    __weak SocketConn* weakSelf = (SocketConn*)self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // something
    [weakSelf.socket writeData:message withTimeout:-1 tag:0];
        NIF_ALLINFO(@"send message... :%@",message);
    });
//    [self socket:nil didReadData:message withTag:0];//junyi.zhu debug
    
}

#pragma mark - GCDAsyncSocketDelegate 回调函数
// 连接服务器成功回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
//    Message * mess Z= [[ Message alloc]init];
//    _data = mess.contents;
    [self.socket readDataWithTimeout:-1 tag:0];
    
    [self registration];
     NIF_ALLINFO(@"connected to host");
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{// 调用代理
    NIF_ALLINFO(@"IMServer 连接服务端断开 %@",err);
    //发送消息通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatSocketConnectStatusNotice object:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt: SocketStatusForConnectCloseOrFail] forKey:@"SocketStatus"]];
    
}


//向服务器写入数据成功回调
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NIF_ALLINFO(@"writeData Success");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
   
    
    if (data && [data length]>0) {
        
//        [self.bufferData appendData:data];
        
        NIF_ALLINFO(@"..收到数据:%@",data);
               __weak SocketConn* weakSelf = self;
        
        [MessageCodec decodeToArray:data withBolck:^(Message *newMessage) {
            if (weakSelf.delegate) {
                [weakSelf.delegate addReceivedMessage:newMessage];
            }
        }];
        
//        Message* message = [MessageCodec decode:data withBolck:^(Message *newMessage)
//        {
//
//             if (weakSelf.delegate) {
//                 [weakSelf.delegate addReceivedMessage:newMessage];
//             }
//        }];

//        if (!message) {
//            NIF_ALLINFO(@"数据包出错 :%@",data);
//        }

        [self.socket readDataWithTimeout:-1 tag:0];
    }

}

//        服务端接发出的消息：{"content":"fgh","messageStatus":"SEND","mid":"e03b608a37d84070863f46cdd472ddbe","receiveUser":2,"sendTime":1395889199186,"sendUser":9,"type":"MESSAGE"}




///**
// * 注册连接
// */
//public final String TYPE_REGIST = "REGIST";
//
///**
// * 断开连接
// */
//public final String TYPE_DISCONNECT = "DISCONNECT";
//
///**
// * 消息(服务端接收到该类型的信息之后会原样不动的转发给消息的接收着)
// */
//public final String TYPE_MESSAGE = "MESSAGE";
//
///**
// * 确认消息
// */
//public final String TYPE_MESSAGE_CONFIRM = "MESSAGE_CONFIRM";




#pragma mark - getter
-(GCDAsyncSocket*)socket
{
    if (_socket == nil) {
        _socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _socket.delegate = self;
    }
    return _socket;
}



@end