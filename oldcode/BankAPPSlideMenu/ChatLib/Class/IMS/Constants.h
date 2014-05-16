//
//  MyConstants.h
//  ims
//
//  Created by Tony Ju on 10/18/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark  --------------message type--------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////
typedef enum {
    /**未知类型*/
    MSG_TYPE_UNKNOWN = 0x0000,
    /**文本*/
    MSG_TYPE_TEXT = 0x1000,
    /**表情*/
    MSG_TYPE_EMOTICON = 0x2000,
    /**语音*/
    MSG_TYPE_VOICE = 0x3000,
    /*语音二进制**/
    MSG_TYPE_AUDIO_STREAM = 0x4000
} MSG_TYPE;


/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark  --------------error type--------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum {
    /**未知错误*/
    ERROR_UNKNOWN = 0x0000,
    /**成功*/
    ERROR_SUCCESS = 0x0001,
    /**用户不在线*/
    ERROR_USER_NOT_ONLINE = 0x0002,
    /**当前连接不可用*/
    ERROR_NOT_CONNECTED = 0x0003,
    
} ERROR_TYPE;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark  --------------message status--------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////



typedef enum {
    MSG_STATUS_UNKNOWN = 0x0000,
    /**发送中*/
    MSG_STATUS_SENDING = 0x0001,
    /**已发送*/
    MSG_STATUS_DELIVERED = 0x0002,
    /**已读*/
    MSG_STATUS_READ = 0x0003,
    MSG_STATUS_FAILED = 0x0004
} MSG_STATUS;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark  --------------message direction--------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////


typedef enum {
    MSG_DIRECTION_UNKNOWN =  0x0000,
    //收到服务端转发消息
    MSG_DIRECTION_CLIENT_TO_SERVER = 0x1000,
    //收到服务端响应
    MSG_DIRECTION_SERVER_TO_CLIENT = 0x2000,
}   MSG_DIRECTION;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark  --------------command lines--------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum {
    
    
    COMMAND_UNKNOWN = 0x0000,
    
    /**创建连接*/
    COMMAND_REGISTRATION = 0x0001,
    /**断开连接*/
    COMMAND_DISCONNECT = 0x0002,
    /**重复登录*/
    COMMAND_DUPLICATE_REGISTRATION = 0x0003,
    /** 心跳*/
    COMMAND_HEART_BEAT = 0x0004,
    
    /**.发送点对点消息*/
    COMMAND_SEND_P2P_MESSAGE = 0x1001,
//    COMMAND_SEND_P2P_MESSAGE_RESPONSE = 0x1002,
//    COMMAND_ON_RECEIVED_P2P_MESSAGE = 0x1003,
    
    /**群组消息*/
    COMMAND_SEND_P2G_MESSAGE = 0x1004,
//    COMMAND_SEND_P2G_MESSAGE_RESPONSE = 0x1005,
//    COMMAND_ON_RECEIVED_GROUP_MESSAGE = 0x1006,
    
    
    
    
    
    
    /******************************************
     ＝＝＝＝＝ 注意这组接口中，只有添加好友是需要主动
     请求发送给socket服务端的，其他的接口均属于被动响
     应处理（即服务端发送给客户端）
    ******************************************/
    /**获取群组列表*/
    COMMAND_GET_GROUP_LIST = 0x2000,
    
    /**邀请加入群组*/
    COMMAND_SEND_GROUP_INVITATION = 0x2001,
    
    /**接受群组邀请*/
    COMMAND_ACCEPT_GROUP_INVITATION = 0x2002,
    
    /**退出群组*/
    COMMAND_QUIT_GROUP = 0x2003,
    
    /**获取好友列表*/
    COMMAND_GET_FIENDS_LIST = 0x3000,
    
    /**加好友请求*/
    COMMAND_SEND_ADD_FRIEND_REQUEST = 0x3001,
    
    /**同总加好友请求*/
    COMMAND_HANDLE_ADD_FRIEND_REQUEST = 0x3002,
    
    /**删除好友*/
    COMMAND_DELETE_FRIEND = 0x3003,
    
    /**加为黑名单好友*/
    COMMAND_BLOCK_FRIEND = 0x3004,
    
    
    /**********
     ==实时对讲==
     **********/
    //实时对讲邀请
    COMMAND_INVITE_TALK = 0x4001,
    //实时对讲同意
    COMMAND_ACCEPT_TALK = 0x4002,
    //实时对讲开始  -----  备注： 被合并到同意accept talk 命令中
//    COMMAND_TALK_START = 0x4003,
    //实时对讲结束
    COMMAND_TALK_END = 0x4004,
    //实时对讲异常终止
    COMMAND_TALK_EXCEPTION = 0x4005,
    //拒绝实时对讲
    COMMAND_REJECT_TALK = 0x4007,
    //正在实时对讲
    COMMAND_TALK_BUSY = 0x4008,

} COMMAND_TYPE;

 

