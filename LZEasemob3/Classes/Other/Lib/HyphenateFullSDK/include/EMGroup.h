/*!
 *  \~chinese
 *  @header EMGroup.h
 *  @abstract 群组
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMGroup.h
 *  @abstract Group
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMGroupOptions.h"

/*!
 *  \~chinese 
 *  群组
 *
 *  \~english
 *  Group
 */
@interface EMGroup : NSObject

/*!
 *  \~chinese
 *  群组ID
 *
 *  \~english
 *  Group id
 */
@property (nonatomic, copy, readonly) NSString *groupId;

/*!
 *  \~chinese
 *  群组的主题，需要获取群详情
 *
 *  \~english
 *  Subject of the group
 */
@property (nonatomic, copy, readonly) NSString *subject;

/*!
 *  \~chinese
 *  群组的描述，需要获取群详情
 *
 *  \~english
 *  Description of the group
 */
@property (nonatomic, copy, readonly) NSString *description;

/*!
 *  \~chinese
 *  群组当前的成员数量，需要获取群详情
 *
 *  \~english
 *  The total number of group members
 */
@property (nonatomic, readonly) NSInteger occupantsCount __deprecated_msg("Use - membersCount");
@property (nonatomic, readonly) NSInteger membersCount;

/*!
 *  \~chinese
 *  群组属性配置，需要获取群详情
 *
 *  \~english
 *  Setting options of group
 */
@property (nonatomic, strong, readonly) EMGroupOptions *setting;

/*!
 *  \~chinese
 *  群组的所有者，拥有群的最高权限，需要获取群详情
 *
 *  群组的所有者只有一人
 *
 *  \~english
 *  Owner of the group
 *
 *  Each group only has one owner
 */
@property (nonatomic, copy, readonly) NSString *owner;

/*!
 *  \~chinese
 *  群组的成员列表，需要获取群详情
 *
 *  \~english
 *  Member list of the group
 */
@property (nonatomic, copy, readonly) NSArray *members;

/*!
 *  \~chinese
 *  群组的黑名单，需要先调用获取群黑名单方法
 *
 *  需要owner权限才能查看，非owner返回nil
 *
 *  \~english
 *  Group‘s blacklist of blocked users
 *
 *  Need owner's authority to access, return nil if user is not the group owner.
 */
@property (nonatomic, strong, readonly) NSArray *bans __deprecated_msg("Use - blackList");
@property (nonatomic, strong, readonly) NSArray *blackList;

/*!
 *  \~chinese
 *  群组的所有成员(包含owner和members)
 *
 *  \~english
 *  All occupants of the group, includes the group owner and all other group members
 */
@property (nonatomic, strong, readonly) NSArray *occupants;

/*!
 *  \~chinese
 *  此群组是否接收消息推送通知
 *
 *  \~english
 *  Is Apple Push Notification Service enabled for group
 */
@property (nonatomic, readonly) BOOL isPushNotificationEnabled;

/*!
 *  \~chinese
 *  此群是否为公开群，需要获取群详情
 *
 *  \~english
 *  Whether is a public group
 */
@property (nonatomic, readonly) BOOL isPublic;

/*!
 *  \~chinese
 *  是否屏蔽群消息
 *
 *  \~english
 *  Whether block the current group‘s messages
 */
@property (nonatomic, readonly) BOOL isBlocked;

/*!
 *  \~chinese
 *  初始化群组实例
 *  
 *  请使用+groupWithId:方法
 *
 *  @result nil
 *
 *  \~english
 *  Initialize a group instance
 *
 *  Please use [+groupWithId:]
 *
 *  @result nil
 */
- (instancetype)init __deprecated_msg("Use +groupWithId:");

/*!
 *  \~chinese
 *  获取群组实例，如果不存在则创建
 *
 *  @param aGroupId    群组ID
 *
 *  @result 群组实例
 *
 *  \~english
 *  Get group instance, create a instance if it does not exist
 *
 *  @param aGroupId  Group id
 *
 *  @result Group instance
 */
+ (instancetype)groupWithId:(NSString *)aGroupId;

@end
