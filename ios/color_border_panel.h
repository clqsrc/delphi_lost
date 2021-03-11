//
//  color_border_panel.h
//
//  Created by clq on 2021/3/10.
//

#import <Foundation/Foundation.h>

//自定义边框的 uiview //不要加别的属性,如果要加另外做个类

NS_ASSUME_NONNULL_BEGIN


@interface ColorBorderPanel : UIView

//IBInspectable 的属性应该会显示在设计器中

//背景色
@property (nonatomic, copy) IBInspectable UIColor * bgColor;
//边框色
@property (nonatomic, copy) IBInspectable UIColor * BorderColor;

@end

NS_ASSUME_NONNULL_END
