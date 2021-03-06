//
//  CCMessageTableViewController.h
//  CCFramework
//
// Copyright (c) 2015 CC ( http://www.ccskill.com )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import <UIKit/UIKit.h>
#import "CCMessage.h"
#import "CCMessageTableViewCell.h"

#import "CCMessageInputView.h"
#import "CCShareMenuView.h"
#import "CCEmotionManagerView.h"
#import "CCMessageTableView.h"

/**
 *  @author C C, 15-08-18
 *
 *  @brief  输入VIew类型
 */
typedef NS_ENUM(NSUInteger, CCInputViewType) {
    /** 默认 **/
    CCInputViewTypeNormal = 0,
    /** 文本 **/
    CCInputViewTypeText,
    /** 表情 **/
    CCInputViewTypeEmotion,
    /** 共享菜单 **/
    CCInputViewTypeShareMenu,
};

//文本中的表情
static NSString *const OBJECT_REPLACEMENT_CHARACTER = @"\uFFFC";

@protocol CCMessageTableViewControllerDelegate <NSObject>

@optional
/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text
         fromSender:(NSString *)sender
             onDate:(NSDate *)date;
/**
 *  @author CC, 2015-12-25
 *
 *  @brief  发送图文消息的回调方法
 *
 *  @param text         目标文本字符串
 *  @param teletextPath 目标图案路径
 *  @param sender       发送者的名字
 *  @param date         发送时间
 */
- (void)didSendTeletext:(NSString *)text
           TeletextPath:(NSArray *)teletextPath
             fromSender:(NSString *)sender
                 onDate:(NSDate *)date;

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(NSDictionary *)photo
          fromSender:(NSString *)sender
              onDate:(NSDate *)date;

/**
 *  发送视频消息的回调方法
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频本地路径
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto
                      videoPath:(NSString *)videoPath
                     fromSender:(NSString *)sender
                         onDate:(NSDate *)date;

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath
       voiceDuration:(NSString *)voiceDuration
          fromSender:(NSString *)sender
              onDate:(NSDate *)date;

/**
 *  发送第三方表情消息的回调方法
 *
 *  @param emotionPath 目标第三方表情的本地路径
 *  @param emotionUrl  目标第三方表情的网络路径
 *  @param sender      目标第三方表情的本地路径
 *  @param date        发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath
            EmotionUrl:(NSString *)emotionUrl
            fromSender:(NSString *)sender
                onDate:(NSDate *)date;

/**
 *  发送GIF图片
 *
 *  @param gifPath 目标第三方表情的本地路径
 *  @param gifUrl  目标第三方表情的网络路径
 *  @param sender  目标第三方表情的本地路径
 *  @param date     发送时间
 */
- (void)didSendGIF:(NSString *)gifPath
            GIFUrl:(NSString *)gifUrl
        fromSender:(NSString *)sender
            onDate:(NSDate *)date;

/**
 *  @author CC, 2015-12-03
 *
 *  @brief  表情包商店
 */
- (void)didEmotionStore;

/**
 *  发送地理位置的回调方法
 *
 *  @param geoLocationsPhoto 目标显示默认图
 *  @param geolocations      目标地理信息
 *  @param location          目标地理经纬度
 *  @param sender            发送者
 *  @param date              发送时间
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto
                    geolocations:(NSString *)geolocations
                        location:(CLLocation *)location
                      fromSender:(NSString *)sender
                          onDate:(NSDate *)date;

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
                                  targetMessage:(id<CCMessageModel>)message;
;

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(CCMessageTableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath;

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling;

/**
 *  判断是否支持下拉加载更多消息
 *
 *  @return 返回BOOL值，判定是否拥有这个功能
 */
- (BOOL)shouldLoadMoreMessagesScrollToTop;

/**
 *  下拉加载更多消息，只有在支持下拉加载更多消息的情况下才会调用。
 */
- (void)loadMoreMessagesScrollTotop;

/**
 *  配置TableViewCell高度的方法，如果你想定制自己的Cell样式，那么你必须要实现DataSource中的方法
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<XHMessageModel>)message;
 *
 *  @param tableView 目标TableView
 *  @param indexPath 目标IndexPath
 *  @param message   目标消息Model
 *
 *  @return 返回计算好的Cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
	      targetMessage:(id<CCMessageModel>)message;

@end

@protocol CCMessageTableViewControllerDataSource <NSObject>

@required
- (id<CCMessageModel>)messageForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
/**
 *  配置TableViewCell的方法，如果你想定制自己的Cell样式，那么你必须要实现Delegate中的方法
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<CCMessageModel>)message;
 *
 *  @param tableView 目标TableView
 *  @param indexPath 目标IndexPath
 *  @param message   目标消息Model
 *
 *  @return 返回UITableViewCell或者继承于UITableViewCell的实例化对象
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                 targetMessage:(id<CCMessageModel>)message;

@end

@interface CCMessageTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CCMessageTableViewControllerDelegate, CCMessageTableViewControllerDataSource, CCMessageInputViewDelegate, CCMessageTableviewCellDelegate, CCShareMenuViewDelegate, CCEmotionManagerViewDelegate, CCEmotionManagerViewDataSource>

@property(nonatomic, weak) id<CCMessageTableViewControllerDelegate> delegate;

@property(nonatomic, weak) id<CCMessageTableViewControllerDataSource> dataSource;

@property(nonatomic, assign, readonly) CCInputViewType textViewInputViewType;

@property(nonatomic, assign) UIActivityIndicatorViewStyle loadMoreActivityIndicatorViewStyle;

/**
 *  @author CC, 2015-12-05
 *
 *  @brief  记录上次显示时间
 */
@property(nonatomic, strong) NSDate *currentCreateTime;

/**
 *  数据源，显示多少消息
 */
@property(nonatomic, strong) NSMutableArray *messages;

/**
 *  第三方接入的功能，也包括系统自身的功能，比如拍照、发送地理位置
 */
@property(nonatomic, strong) NSArray *shareMenuItems;

/**
 *  消息的主体，默认为nil
 */
@property(nonatomic, copy) NSString *messageSender;

/**
 *  用于显示消息的TableView
 */
@property(nonatomic, weak, readonly) CCMessageTableView *messageTableView;

/**
 *  用于显示发送消息类型控制的工具条，在底部
 */
@property(nonatomic, weak, readonly) CCMessageInputView *messageInputView;

/**
 *  替换键盘的位置的第三方功能控件
 */
@property(nonatomic, weak, readonly) CCShareMenuView *shareMenuView;


/**
 *  管理第三方gif表情的控件
 */
@property(nonatomic, weak, readonly) CCEmotionManagerView *emotionManagerView;

/**
 *  是否正在加载更多旧的消息数据
 */
@property(nonatomic, assign) BOOL loadingMoreMessage;

#pragma mark - Message View Controller Default stup
/**
 *  是否允许手势关闭键盘，默认是允许
 */
@property(nonatomic, assign) BOOL allowsPanToDismissKeyboard; // default is YES

/**
 *  是否允许发送语音
 */
@property(nonatomic, assign) BOOL allowsSendVoice; // default is YES

/**
 *  是否允许发送多媒体
 */
@property(nonatomic, assign) BOOL allowsSendMultiMedia; // default is YES

/**
 *  是否支持发送表情
 */
@property(nonatomic, assign) BOOL allowsSendFace; // default is YES

/**
 *  输入框的样式，默认为扁平化
 */
@property(nonatomic, assign) CCMessageInputViewStyle inputViewStyle;

/**
 *  @author CC, 2015-11-16
 *
 *  @brief  底部工具条
 */
@property(nonatomic, copy) UIView *bottomToolbarView;

#pragma mark - RecorderPath Helper Method
/**
 *  获取录音的路径
 *
 *  @return 返回录音的路径
 */
- (NSString *)obtainRecorderPath;

#pragma mark - DataSource Change
/**
 *  添加一条新的消息
 *
 *  @param addedMessage 添加的目标消息对象
 */
- (void)addMessage:(CCMessage *)addedMessage;

/**
 *  @author C C, 2016-10-06
 *  
 *  @brief  添加多条新的消息
 *
 *  @param objects 添加多条目标消息对象
 */
- (void)addMessages:(NSArray *)objects;

/**
 *  @author CC, 15-09-16
 *
 *  @brief  修改发送消息状态
 *
 *  @param messageData 消息体
 *  @param sendType    消息状态
 *
 *  @since 1.0
 */
- (void)updateMessageData:(CCMessage *)messageData
          MessageSendType:(CCMessageSendType)sendType;

/**
 *  @author CC, 2016-01-23
 *
 *  @brief 替换对象
 *
 *  @param messageData 消息实体
 *                     根据消息对象唯一ID替换
 */
- (void)replaceMessages:(CCMessage *)messageData;

/**
 *  删除一条已存在的消息
 *
 *  @param reomvedMessage 删除的目标消息对象
 */
- (void)removeMessageAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  插入旧消息数据到头部，仿微信的做法
 *
 *  @param oldMessages 目标的旧消息数据
 */
- (void)insertOldMessages:(NSArray *)oldMessages;

/**
 *  同上，增加了 completion 来通知消息插入完毕
 *
 *  @param oldMessages 目标的旧消息数据
 *  @param completion  insert 完成回调
 */
- (void)insertOldMessages:(NSArray *)oldMessages
               completion:(void (^)())completion;

/**
 *  @author C C, 2016-09-28
 *  
 *  @brief  插入旧消息数据到头部去除重复数据，仿微信的做法
 *
 *  @param oldMessages 目标的旧消息数据
 *  @param keyName     去除重复key
 */
- (void)insertOldMessages:(NSArray *)oldMessages
            deduplication:(NSString *)keyName;

#pragma mark - Messages view controller
/**
 *  完成发送消息的函数
 */
- (void)finishSendMessageWithBubbleMessageType:(CCBubbleMessageMediaType)mediaType;

/**
 *  设置View、tableView的背景颜色
 *
 *  @param color 背景颜色
 */
- (void)setBackgroundColor:(UIColor *)color;

/**
 *  设置消息列表的背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (void)setBackgroundImage:(UIImage *)backgroundImage;

/**
 *  是否滚动到底部
 *
 *  @param animated YES Or NO
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 *  滚动到哪一行
 *
 *  @param indexPath 目标行数变量
 *  @param position  UITableViewScrollPosition 整形常亮
 *  @param animated  是否滚动动画，YES or NO
 */
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
              atScrollPosition:(UITableViewScrollPosition)position
                      animated:(BOOL)animated;

#pragma mark - Other Menu View Frame Helper Mehtod
/**
 *  根据显示或隐藏的需求对所有第三方Menu进行管理
 *
 *  @param hide 需求条件
 */
- (void)layoutOtherMenuViewHiden:(BOOL)hide;


#pragma mark - CCShareMenuView Delegate

/**
 *  @author CC, 15-08-18
 *
 *  @brief  自定义功能回调
 *
 *  @param shareMenuItem 选中控件
 *  @param index         选中下标
 *
 *  @since 1.0
 */
- (void)didSelecteShareMenuItem: (CCShareMenuItem *)shareMenuItem
                        atIndex: (NSInteger)index;

@end
