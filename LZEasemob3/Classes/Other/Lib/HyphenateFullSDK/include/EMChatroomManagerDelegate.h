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
 *  The casuse for kicking a user out of a chatroom
 */
typedef enum{
    EMChatroomBeKickedReasonBeRemoved = 0,  /*! \~chinese 被管理员移出聊天室 \~english Removed by chatroom owner  */
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
 *  Delegate method will be invoked when a user joins a chatroom.
 *
 *  @param aChatroom    Joined chatroom
 *  @param aUsername    The user who joined chatroom
 */
- (void)userDidJoinChatroom:(EMChatroom *)aChatroom
                       user:(NSString *)aUsername;

/*!
 *  \~chinese
 *  有用户离开聊天室
 *
 *  @param aChatroom    离开的聊天室
 *  @param aUsername    离开者
 *
 *  \~english
 *  Delegate method will be invoked when a user leaves a chatroom.
 *
 *  @param aChatroom    Left chatroom
 *  @param aUsername    The user who leaved chatroom
 */
- (void)userDidLeaveChatroom:(EMChatroom *)aChatroom
                        user:(NSString *)aUsername;

/*!
 *  \~chinese
 *  被踢出聊天室
 *
 *  @param aChatroom    被踢出的聊天室
 *  @param aReason      被踢出聊天室的原因
 *
 *  \~english
 *  Delegate method will be invoked when a user is dismissed from a chat room
 *
 *  @param aChatroom    aChatroom
 *  @param aReason      The reason of dismissing user from the chat room
 */
- (void)didDismissFromChatroom:(EMChatroom *)aChatroom
                        reason:(EMChatroomBeKickedReason)aReason;

#pragma mark - Deprecated methods

/*!
 *  \~chinese
 *  有用户加入聊天室
 *
 *  @param aChatroom    加入的聊天室
 *  @param aUsername    加入者
 *
 *  \~english
 *  Delegate method will be invoked when a user joins a chat room
 *
 *  @param aChatroom    Joined chatroom
 *  @param aUsername    The user who joined chatroom
 */
- (void)didReceiveUserJoinedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername __deprecated_msg("Use -userDidJoinChatroom:user:");

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
                            username:(NSString *)aUsername __deprecated_msg("Use -userDidLeaveChatroom:reason:");

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
                              reason:(EMChatroomBeKickedReason)aReason __deprecated_msg("Use -didDismissFromChatroom:reason:");
@end
