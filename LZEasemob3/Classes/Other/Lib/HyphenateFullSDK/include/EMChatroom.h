/*!
 *  \~chinese
 *  @header EMChatroom.h
 *  @abstract 聊天室
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMChatroom.h
 *  @abstract Chatroom
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  \~chinese 
 *  聊天室
 *
 *  \~english 
 *  Chat room object
 */
@interface EMChatroom : NSObject

/*!
 *  \~chinese 
 *  聊天室ID
 *
 *  \~english 
 *  Chat room id
 */
@property (nonatomic, copy, readonly) NSString *chatroomId;

/*!
 *  \~chinese
 *  聊天室的主题
 *
 *  \~english 
 *  Subject of chat room
 */
@property (nonatomic, copy, readonly) NSString *subject;

/*!
 *  \~chinese 
 *  聊天室的描述
 *
 *  \~english 
 *  Description of chat room
 */
@property (nonatomic, copy, readonly) NSString *description;

/*!
 *  \~chinese
 *  聊天室的所有者，需要获取聊天室详情
 *
 *  聊天室的所有者只有一人
 *
 *  \~english
 *  Owner of the chat room. Only one owner per chat room. 
 */
@property (nonatomic, copy, readonly) NSString *owner;

/*!
 *  \~chinese 
 *  聊天室的当前人数，如果没有获取聊天室详情将返回0
 *
 *  \~english
 *  The total number of members in the chat room
 */
@property (nonatomic, readonly) NSInteger occupantsCount __deprecated_msg("Use - membersCount");
@property (nonatomic, readonly) NSInteger membersCount;

/*!
 *  \~chinese 
 *  聊天室的最大人数，如果没有获取聊天室详情将返回0
 *
 *  \~english
 *  The capacity of the chat room
 */
@property (nonatomic, readonly) NSInteger maxOccupantsCount __deprecated_msg("Use - maxMembersCount");
@property (nonatomic, readonly) NSInteger maxMembersCount;

/*!
 *  \~chinese
 *  聊天室的成员列表，需要获取聊天室详情
 *
 *  \~english
 *  List of members in the chat room
 */
@property (nonatomic, copy, readonly) NSArray *occupants __deprecated_msg("Use - members");
@property (nonatomic, copy, readonly) NSArray *members;

/*!
 *  \~chinese
 *  初始化聊天室实例
 *  
 *  请使用[+chatroomWithId:]方法
 *
 *  @result nil
 *
 *  \~english
 *  Initialize chatroom instance
 *
 *  Please use [+chatroomWithId:]
 *
 *  @result nil
 */
- (instancetype)init __deprecated_msg("Use +chatroomWithId:");

/*!
 *  \~chinese
 *  获取聊天室实例
 *
 *  @param aChatroomId   聊天室ID
 *
 *  @result 聊天室实例
 *
 *  \~english
 *  Construct a chatroom instance with chatroom id
 *
 *  @param aChatroomId   Chatroom id
 *
 *  @result Chatroom instance
 */
+ (instancetype)chatroomWithId:(NSString *)aChatroomId;

@end
