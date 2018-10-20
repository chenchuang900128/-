//
//  HCDragingView.m
//  HCAnimaTextBox
//
//  Created by Mac on 2018/7/23.
//

#import "HCDragingView.h"

#define kScreenW    [UIScreen mainScreen].bounds.size.width
#define kScreenH    [UIScreen mainScreen].bounds.size.height

#define kNavigaMargin   64
#define kTabBarMargin   49

@interface HCDragingView()

@property (nonatomic, strong) UIView *containerView;
/** 拖动手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
/** 悬浮按钮 */
@property (nonatomic, strong) UIButton *dragButton;
/** 消息数量角标 */
@property (nonatomic, strong) UILabel *badegLabel;
/** 悬浮按钮宽高(默认宽高相等) */
@property (nonatomic, assign) CGFloat dragWidthHeight;

@end

@implementation HCDragingView

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame containerView:(UIView *)view {
    
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.0;
        self.backgroundColor = [UIColor clearColor];
        if (view) {
            // 获取悬浮尺寸
            _dragWidthHeight = frame.size.width;
            // 获取父视图
            self.containerView = view;
            // 初始化子类
            [self initSubview];
        }
    }
    return self;
}


- (void)initSubview
{
    
    // 添加悬浮窗按钮事件
    self.dragButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dragButton.frame = self.bounds;
    [self.dragButton addTarget:self action:@selector(dragDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.dragButton];
    
    // 获取消息通知
    CGFloat w = self.frame.size.width * 0.3;
    CGFloat x = (self.frame.size.width - w) - w * 0.39;
    CGFloat y = w  - w * 0.4;
    self.badegLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, w)];
    self.badegLabel.textAlignment = NSTextAlignmentCenter;
    self.badegLabel.font = [UIFont systemFontOfSize:9];
    self.badegLabel.layer.cornerRadius = w * 0.5;
    self.badegLabel.layer.masksToBounds = YES;
    self.badegLabel.backgroundColor = [UIColor redColor];
    self.badegLabel.textColor = [UIColor whiteColor];
    self.badegLabel.hidden = YES;
    [self addSubview:self.badegLabel];
    
    // 添加平滑手势
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidEvent:)];
    // 单手操作
    [self.pan setMinimumNumberOfTouches:1];
    /* 来设置手势被识别时触摸事件是否被传送到视图。
     当值为YES的时候，系统会识别手势，并取消触摸事件；
     为NO的时候，手势识别之后，系统将触发触摸事件。*/
    [self.pan cancelsTouchesInView];
    /*
     默认为YES。这种情况下发生一个touch时，在手势识别成功后,发送给touchesCancelled消息给hit-testview，手势识别失败时，会延迟大概0.15ms,期间没有接收到别的touch才会发送touchesEnded。如果设置为NO，则不会延迟，即会立即发送touchesEnded以结束当前触摸。
     */
    [self.pan delaysTouchesEnded];
    [self.pan setEnabled:YES];
    [self addGestureRecognizer:self.pan];
}


// 点击事件
- (void)dragDidEvent:(UIButton *)button
{
    if (self.didEventBlock) {
        self.didEventBlock();
    }
}

#pragma mark - Setter && Getter

- (void)show {
    
    self.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.containerView addSubview:self];
        [self.containerView bringSubviewToFront:self];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.dragButton.alpha = 0.0;
        [self.dragButton removeFromSuperview];
        [self removeFromSuperview];
    }];
}

// 设置背景图片
- (void)setDragImage:(NSString *)dragImage {
    
    _dragImage = dragImage;
    
    [self.dragButton setBackgroundImage:[UIImage imageNamed:dragImage] forState:UIControlStateNormal];
}

// 设置徽章
- (void)setBadge:(NSInteger)badge {
    
    _badge = badge;
    
    if (badge <= 0) {
        self.badegLabel.hidden = YES;
        return;
    }
    self.badegLabel.hidden = NO;
    self.badegLabel.text = [NSString stringWithFormat:@"%ld", badge];
}

#pragma mark - UIPanGestureRecognizer Handel

- (void)panGestureDidEvent:(UIPanGestureRecognizer *)pan {
    // 移动状态
    UIGestureRecognizerState state =  pan.state;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            // 改变状态
            CGPoint translation = [pan translationInView:self.containerView];
            pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint stopPoint = CGPointMake(0, kScreenH / 2.0);
            
            if (pan.view.center.x < kScreenW / 2.0) {
                if (pan.view.center.y <= kScreenH/2.0) {
                    //左上
                    if (pan.view.center.x  >= pan.view.center.y) {
                        stopPoint = CGPointMake(pan.view.center.x, (_dragWidthHeight/2.0) + kNavigaMargin);
                    }else{
                        stopPoint = CGPointMake(_dragWidthHeight/2.0, pan.view.center.y + kNavigaMargin);
                    }
                }else{
                    //左下
                    if (pan.view.center.x  >= kScreenH - pan.view.center.y) {
                        stopPoint = CGPointMake(pan.view.center.x, (kScreenH - _dragWidthHeight/2.0) - kTabBarMargin);
                    }else{
                        stopPoint = CGPointMake(_dragWidthHeight/2.0, pan.view.center.y - kTabBarMargin);
                    }
                }
            }else{
                if (pan.view.center.y <= kScreenH/2.0) {
                    //右上
                    if (kScreenW - pan.view.center.x  >= pan.view.center.y) {
                        stopPoint = CGPointMake(pan.view.center.x, (_dragWidthHeight/2.0) + kNavigaMargin);
                    }else{
                        stopPoint = CGPointMake(kScreenW - _dragWidthHeight/2.0, pan.view.center.y + kNavigaMargin);
                    }
                }else{
                    //右下
                    if (kScreenW - pan.view.center.x  >= kScreenH - pan.view.center.y) {
                        stopPoint = CGPointMake(pan.view.center.x, (kScreenH - _dragWidthHeight/2.0) - kTabBarMargin);
                    }else{
                        stopPoint = CGPointMake(kScreenW - _dragWidthHeight/2.0, pan.view.center.y - kTabBarMargin);
                    }
                }
            }
            
            if (stopPoint.x - _dragWidthHeight/2.0 <= 0) {
                stopPoint = CGPointMake(_dragWidthHeight/2.0, stopPoint.y);
            }
            
            if (stopPoint.x + _dragWidthHeight/2.0 >= kScreenW) {
                stopPoint = CGPointMake(kScreenW - _dragWidthHeight/2.0, stopPoint.y);
            }
            
            if (stopPoint.y - _dragWidthHeight/2.0 <= 0) {
                stopPoint = CGPointMake(stopPoint.x, _dragWidthHeight/2.0);
            }
            
            if (stopPoint.y + _dragWidthHeight/2.0 >= kScreenH) {
                stopPoint = CGPointMake(stopPoint.x, kScreenH - _dragWidthHeight/2.0);
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                pan.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    
    [pan setTranslation:CGPointMake(0, 0) inView:self];
}


@end
