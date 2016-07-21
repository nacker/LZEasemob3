/*!
 *  \~chinese
 *  @header EMCmdMessageBody.h
 *  @abstract 命令消息体
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCmdMessageBody.h
 *  @abstract Command message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMMessageBody.h"

/*!
 *  \~chinese 
 *  命令消息体
 *
 *  \~english
 *  Command message body
 */
@interface EMCmdMessageBody : EMMessageBody

/*!
 *  \~chinese
 *  命令内容
 *
 *  \~english
 *  Command content
 */
@property (nonatomic, copy) NSString *action;

/*!
 *  \~chinese
 *  命令参数，只是为了兼容老版本，应该使用EMMessage的扩展属性来代替
 *
 *  \~english
 *  Command parameters, only for compatable with old version, use EMMessage's extend attribute instead
 */
@property (nonatomic, copy) NSArray *params;

/*!
 *  \~chinese
 *  初始化命令消息体
 *
 *  @param aAction  命令内容
 *  
 *  @result 命令消息体实例
 *
 *  \~english
 *  Initialize command message body
 *
 *  @param aAction  Action content
 *
 *  @result Instance of command message body
 */
- (instancetype)initWithAction:(NSString *)aAction;

@end
