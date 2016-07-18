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
 *  Group's subject, need to fetch group's specification
 */
@property (nonatomic, copy, readonly) NSString *subject;

/*!
 *  \~chinese
 *  群组的描述，需要获取群详情
 *
 *  \~english
 *  Group's description, need to fetch group's specification
 */
@property (nonatomic, copy, readonly) NSString *description;

/*!
 *  \~chinese
 *  群组当前的成员数量，需要获取群详情
 *
 *  \~english
 *  The number of members, need to fetch group's specification
 */
@property (nonatomic, readonly) NSInteger occupantsCount;

/*!
 *  \~chinese
 *  群组属性配置，需要获取群详情
 *
 *  \~english
 *  Group's setting options, need to fetch group's specification
 */
@property (nonatomic, strong, readonly) EMGroupOptions *setting;

/*!
 *  \~chinese
 *  群组的所有者，拥有群的最高权限，需要获取群详情
 *
 *  群组的所有者只有一人
 *
 *  \~english
 *  Group‘s owner, has the highest authority, need to fetch group's specification
 *
 *  A group only has one owner
 */
@property (nonatomic, copy, readonly) NSString *owner;

/*!
 *  \~chinese
 *  群组的成员列表，需要获取群详情
 *
 *  \~english
 *  Member list of group, need to fetch group's specification
 */
@property (nonatomic, copy, readonly) NSArray *members;

/*!
 *  \~chinese
 *  群组的黑名单，需要先调用获取群黑名单方法
 *
 *  需要owner权限才能查看，非owner返回nil
 *
 *  \~english
 *  Group‘s blacklist, need to call fetching group's blacklist method first
 *
 *  Need owner's authority, will return nil if user is not the owner of the group
 */
@property (nonatomic, strong, readonly) NSArray *bans;

/*!
 *  \~chinese
 *  群组的所有成员(包含owner和members)
 *
 *  \~english
 *  All occupants of the group, include both the owner and all members
 */
@property (nonatomic, strong, readonly) NSArray *occupants;

/*!
 *  \~chinese
 *  此群组是否接收消息推送通知
 *
 *  \~english
 *  Whether this group receive push notifications
 */
@property (nonatomic, readonly) BOOL isPushNotificationEnabled;

/*!
 *  \~chinese
 *  此群是否为公开群，需要获取群详情
 *
 *  \~english
 *  Whether is public group, need to fetch group's specification
 */
@property (nonatomic, readonly) BOOL isPublic;

/*!
 *  \~chinese
 *  是否屏蔽群消息
 *
 *  \~english
 *  Whether block this group‘s message
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
 *  Initialize group instance
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
 *  Get group instance, create a instance if do not exist
 *
 *  @param aGroupId    Group id
 *
 *  @result Group instance
 */
+ (instancetype)groupWithId:(NSString *)aGroupId;

@end
