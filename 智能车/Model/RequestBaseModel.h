

//  RequestModel.h
//  智能车
//
//  Created by user on 15/11/3.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBaseModel : NSObject 
@property (strong, nonatomic) NSArray *returnCodeInfo;//接口返回的编码含义
/** 开发者
    0	OK	调用成功，该值为null	无需处理
    1	请求参数缺失	补充必须传入的参数	
    2	请求参数格式错误	按提示修改参数值的格式	
    3	账户余额不足	账户需要充值，请充值后重试	
    4	关键词屏蔽	关键词屏蔽，修改关键词后重试	
    5	未找到对应id的模板	模板id不存在或者已经删除	
    6	添加模板失败	模板有一定的规范，按失败提示修改
    7	模板不可用	审核状态的模板和审核未通过的模板不可用	
    8	同一手机号30秒内重复提交相同的内容	请检查是否同一手机号在30秒内重复提交相同的内容	
    9	同一手机号5分钟内重复提交相同的内容超过3次	为避免重复发送骚扰用户，同一手机号5分钟内相同内容最多允许发3次	
    10	手机号黑名单过滤	手机号在黑名单列表中（你可以把不想发送的手机号添加到黑名单列表）	
    11	接口不支持GET方式调用	接口不支持GET方式调用，请按提示或者文档说明的方法调用，一般为POST	
    12	接口不支持POST方式调用	接口不支持POST方式调用，请按提示或者文档说明的方法调用，一般为GET	
    13	营销短信暂停发送	由于运营商管制，营销短信暂时不能发送	
    14	解码失败	请确认内容编码是否设置正确	
    15	签名不匹配	短信签名与预设的固定签名不匹配	
    16	签名格式不正确	短信内容不能包含多个签名【 】符号	
    17	24小时内同一手机号发送次数超过限制	请检查程序是否有异常或者系统是否被恶意攻击	
    -1	非法的apikey	apikey不正确或没有授权	
    -2	API没有权限	用户没有对应的API权限	
    -3	IP没有权限	访问IP不在白名单之内，可在后台"账户设置->IP白名单设置"里添加该IP	
    -4	访问次数超限	调整访问频率或者申请更高的调用量	
    -5	访问频率超限	短期内访问过于频繁，请降低访问频率
 
    客服	 *********************************************
    -50	未知异常	系统出现未知的异常情况	技术支持
    -51	系统繁忙	系统繁忙，请稍后重试	技术支持
    -52	充值失败	充值时系统出错	技术支持
    -53	提交短信失败	提交短信时系统出错	技术支持
    -54	记录已存在	常见于插入键值已存在的记录	技术支持
    -55	记录不存在	没有找到预期中的数据	技术支持
    -57	用户开通过固定签名功能，但签名未设置	联系客服或技术支持设置固定签名	技术支持
 
    自定义 *********************************************
    1001 匹配码不合法
**/

/**
 *  @author Orange-W, 15-11-04 20:11:09
 *
 *  @brief  发送编码函数
 *  @param phoneNumber 电话号码
 *  @param content     编码内容
 */
- (void)sendMessageWithPhone:(NSString *)phoneNumber
                     content:(NSString *) content;

/**
 *  @author Orange-W, 15-11-04 20:11:39
 *
 *  @brief  获得一段时间所有回复短信
 *  @param phoneNumber 电话号码
 *  @param startTime   时间段开始
 *  @param endTime     时间段结束
 */
- (void)getReplyMessagesWithPhone:(NSString *) phoneNumber
                        startTime:(NSDate *) startTime
                          endTime:(NSDate *) endTime;

- (void) sucessToDo:(NSDictionary *)returnValue;
- (void) failureTodo:(NSInteger)returnCode;


@end
