//
//  CitySectionsCell.m
//  CityChoose
//
//  Created by imqiuhang on 15/3/18.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "CitySectionsCell.h"


@implementation UITableView(CitySectionsCell)

-(CitySectionsCell*)CitySectionsCell{
    
    static NSString *CellIdentifier = @"CitySectionsCell";
    CitySectionsCell *cell = (CitySectionsCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[CitySectionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
    }
    
    return cell;
}
@end


@implementation CitySectionsCell
{
    CitySectionsCellStyle citySectionsCellStyle;
    UIButton *locationBtn;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadLocation) name:@"reloadLocationCellNotify" object:nil];
    }
    return self;
}

- (void)setInfo:(CitySectionsCellStyle)style {
    [self removeAllSubviews];
    citySectionsCellStyle=style;
    if (style == CitySectionsCellStyleLocation) {
        locationBtn =[[UIButton alloc] initWithFrame:CGRectMake(20, 15, 130, 40)];
        locationBtn.backgroundColor=[UIColor whiteColor];
        [locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self reloadLocation];
        locationBtn.layer.cornerRadius=5;
        [self addSubview:locationBtn];
        locationBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [locationBtn addTarget:self action:@selector(didChooseCity:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if(style == CitySectionsCellStyleHot) {
        for (int i=0; i<6; i++) {
            float btnWidth =80;
            float btnHeigh =40;
            UIButton *hotCityBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeigh)];
            hotCityBtn.tag=otherBtnStartTag+i;
            hotCityBtn.backgroundColor=[UIColor whiteColor];
            [hotCityBtn setTitle:hotCities[i] forState:UIControlStateNormal];
            [hotCityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            hotCityBtn.layer.cornerRadius=5;
            hotCityBtn.left=20+i%3*((self.width-btnWidth-2*20)/2.f);
            hotCityBtn.top=15+((i-2)>0?(10+hotCityBtn.height):0);
            [hotCityBtn addTarget:self action:@selector(didChooseCity:) forControlEvents:UIControlEventTouchUpInside];
            hotCityBtn.titleLabel.font=[UIFont systemFontOfSize:14];
            [self addSubview:hotCityBtn];
        }
    }else {
        //
        NSMutableArray * cityChooseHistory = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cityChooseHistory"] mutableCopy];


                if (!cityChooseHistory||cityChooseHistory.count<=0) {
                    cityChooseHistory=[[NSMutableArray alloc] initWithObjects:@"北京市", nil];
                }

                for (int i=0; i<cityChooseHistory.count; i++) {
                    if (i<3) {
                        float btnWidth =80;
                        float btnHeigh =40;
                        UIButton *historyCityBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeigh)];
                        historyCityBtn.tag=otherBtnStartTag+i;
                        historyCityBtn.backgroundColor=[UIColor whiteColor];
                        [historyCityBtn setTitle:cityChooseHistory[i] forState:UIControlStateNormal];
                        [historyCityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        historyCityBtn.layer.cornerRadius=5;
                        historyCityBtn.left=20+i%3*((self.width-btnWidth-2*20)/2.f);
                        historyCityBtn.top=15;
                        historyCityBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                        historyCityBtn.titleLabel.minimumScaleFactor        = 0.7f;
                        historyCityBtn.titleLabel.font=[UIFont systemFontOfSize:14];
                        [historyCityBtn addTarget:self action:@selector(didChooseCity:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:historyCityBtn];
                    }
                }
//            [[NSUserDefaults standardUserDefaults] objectForKey:[cityChooseHistory mutableCopy]];
    }
}

- (void)reloadLocation {
    if (citySectionsCellStyle==CitySectionsCellStyleLocation) {
        int cityChooseStatus =[[[NSUserDefaults standardUserDefaults] objectForKey:@"cityChooseStatus"] intValue];
        locationBtn.tag=cityChooseStatus;
        if (cityChooseStatus==succeedLocationBtnTag) {
            NSString *cityName =[[NSUserDefaults standardUserDefaults] objectForKey:locationCity];
            [locationBtn setTitle:cityName forState:UIControlStateNormal];
            locationBtn.width=80;
        }else if (cityChooseStatus == falidLocationBtntag) {
            [locationBtn setTitle:@"定位失败,请点击重试" forState:UIControlStateNormal];
            locationBtn.width=160;
        }else {
            locationBtn.width=80;
            [locationBtn setTitle:@"正在定位.." forState:UIControlStateNormal];
        }
        
    }
}


- (void)didChooseCity:(UIButton *)sender {
    if (sender.tag<otherBtnStartTag) {
        if (sender.tag==locationBtnTag) {
            
        }else if(sender.tag==falidLocationBtntag) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocationNotify" object:nil];
        }else if(sender.tag==succeedLocationBtnTag) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:userDidChooseCityInCellNotify object:sender.titleLabel.text];
        }
        
    }else {
        if (sender.titleLabel.text) {
            [[NSNotificationCenter defaultCenter] postNotificationName:userDidChooseCityInCellNotify object:sender.titleLabel.text];
            
        }else {
            
        }
    }
}


@end
