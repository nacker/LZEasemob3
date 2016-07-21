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
 *  Chatroom
 */
@interface EMChatroom : NSObject

/*!
 *  \~chinese 
 *  聊天室ID
 *
 *  \~english 
 *  Chatroom id
 */
@property (nonatomic, copy, readonly) NSString *chatroomId;

/*!
 *  \~chinese
 *  聊天室的主题
 *
 *  \~english 
 *  Subject of chatroom
 */
@property (nonatomic, copy, readonly) NSString *subject;

/*!
 *  \~chinese 
 *  聊天室的描述
 *
 *  \~english 
 *  Description of chatroom
 */
@property (nonatomic, copy, readonly) NSString *description;

/*!
 *  \~chinese
 *  聊天室的所有者，需要获取聊天室详情
 *
 *  聊天室的所有者只有一人
 *
 *  \~english
 *  Chatroom‘s owner, need to fetch chatroom's specification
 *
 *  A chatroom only has one owner
 */
@property (nonatomic, copy, readonly) NSString *owner;

/*!
 *  \~chinese 
 *  聊天室的当前人数，如果没有获取聊天室详情将返回0
 *
 *  \~english
 *  The current number of members, will return 0 if have not ever fetched chatroom's specification
 */
@property (nonatomic, readonly) NSInteger occupantsCount;

/*!
 *  \~chinese 
 *  聊天室的最大人数，如果没有获取聊天室详情将返回0
 *
 *  \~english
 *  The maximum number of members, will return 0 if have not ever fetched chatroom's specification
 */
@property (nonatomic, readonly) NSInteger maxOccupantsCount;

/*!
 *  \~chinese
 *  聊天室的成员列表，需要获取聊天室详情
 *
 *  \~english
 *  Member list of chatroom, need to fetch chatroom's specification
 */
@property (nonatomic, copy, readonly) NSArray *occupants;

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
 *  Create chatroom instance
 *
 *  @param aChatroomId   Chatroom id
 *
 *  @result Chatroom instance
 */
+ (instancetype)chatroomWithId:(NSString *)aChatroomId;

@end
