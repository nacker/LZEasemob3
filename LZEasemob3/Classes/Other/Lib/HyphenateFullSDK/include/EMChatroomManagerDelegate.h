/*!
 *  \~chinese 
 *  @header EMChatroomManagerDelegate.h
 *  @abstract 此协议定义了聊天室相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMChatroomManagerDelegate.h
 *  @abstract This protocol defined the callbacks of chatroom
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  \~chinese
 *  被踢出聊天室的原因
 *
 *  \~english
 *  The reason of be kicked out from chatroom
 */
typedef enum{
    EMChatroomBeKickedReasonBeRemoved = 0,  /*! \~chinese 被管理员移出聊天室 \~english Removed by owner  */
    EMChatroomBeKickedReasonDestroyed,      /*! \~chinese 聊天室被销毁 \~english Chatroom has been destroyed */
}EMChatroomBeKickedReason;

@class EMChatroom;

/*!
 *  \~chinese
 *  聊天室相关的回调
 *
 *  \~english
 *  Callbacks of chatroom
 */
@protocol EMChatroomManagerDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  有用户加入聊天室
 *
 *  @param aChatroom    加入的聊天室
 *  @param aUsername    加入者
 *
 *  \~english
 *  A user joined chatroom
 *
 *  @param aChatroom    Joined chatroom
 *  @param aUsername    The user who joined chatroom
 */
- (void)didReceiveUserJoinedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername;

/*!
 *  \~chinese
 *  有用户离开聊天室
 *
 *  @param aChatroom    离开的聊天室
 *  @param aUsername    离开者
 *
 *  \~english
 *  A user leaved chatroom
 *
 *  @param aChatroom    Leaved chatroom
 *  @param aUsername    The user who leaved chatroom
 */
- (void)didReceiveUserLeavedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername;

/*!
 *  \~chinese
 *  被踢出聊天室
 *
 *  @param aChatroom    被踢出的聊天室
 *  @param aReason      被踢出聊天室的原因
 *
 *  \~english
 *  User was kicked out from a chatroom
 *
 *  @param aChatroom    The chatroom which user was kicked out from
 *  @param aReason      The reason of user was kicked out
 */
- (void)didReceiveKickedFromChatroom:(EMChatroom *)aChatroom
                              reason:(EMChatroomBeKickedReason)aReason;


@end
