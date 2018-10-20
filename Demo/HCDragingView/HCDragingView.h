//
//  HCDragingView.h
//  HCAnimaTextBox
//
//  Created by Mac on 2018/7/23.
//

#import <UIKit/UIKit.h>

typedef void(^DragendDidFinishedBlock)(void);

@interface HCDragingView : UIView

/**
 实例化悬浮按钮

 @param frame 按钮frame
 @param view 父控件
 @return 悬浮按钮
 */
- (instancetype)initWithFrame:(CGRect)frame containerView:(UIView *)view;

/** 显示 */
- (void)show;
/** 移除 */
- (void)dismiss;

/** 消息数量 */
@property (nonatomic, assign) NSInteger badge;
/** 悬浮按钮图片 */
@property (nonatomic, copy) NSString *dragImage;
/** 点击悬浮事件 */
@property (nonatomic, copy) DragendDidFinishedBlock didEventBlock;

@end
