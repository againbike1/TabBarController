//
//  CitySectionsCell.h
//  CityChoose
//
//  Created by imqiuhang on 15/3/18.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+QHUIViewCtg.h"

#define locationBtnTag 9080
#define falidLocationBtntag 9081
#define succeedLocationBtnTag 9082
#define locationCity @"locationCity"
#define otherBtnStartTag 99999
#define hotCities @[@"北京",@"上海",@"杭州",@"广州",@"深圳",@"武汉"]
#define userDidChooseCityInCellNotify @"userDidChooseCityInCellNotify"
typedef enum {
    CitySectionsCellStyleLocation=0,
    CitySectionsCellStyleHistory=1,
    CitySectionsCellStyleHot=2
}CitySectionsCellStyle;

@interface CitySectionsCell : UITableViewCell
- (void)setInfo :(CitySectionsCellStyle)style;

@end
@interface UITableView(CitySectionsCell)

- (CitySectionsCell*)CitySectionsCell;

@end