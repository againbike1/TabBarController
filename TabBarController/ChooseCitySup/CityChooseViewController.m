//
//  CityChooseViewController.m
//  CityChoose
//
//  Created by imqiuhang on 15/3/18.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "CityChooseViewController.h"
#import "UIView+QHUIViewCtg.h"
#import "CitySectionsCell.h"


@interface CityChooseViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CityChooseWayDelegate>

@end

@implementation CityChooseViewController
{
    NSMutableArray *searchResults;//搜索结果源
    NSMutableArray *keys;         //城市首字母
    NSMutableDictionary *cities;  //城市数据字典
    NSMutableArray *arrayHotCity;
    NSMutableArray *CitySearchArr;//城市搜索数组
    
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    UITableView *dataTableView;
    CityChooseWay *cityChooseWay;
    
    


}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidChooseCityInCellEvent:) name:userDidChooseCityInCellNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLocation) name:@"reloadLocationNotify" object:nil];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initData];
    [self initView];
    cityChooseWay=[[CityChooseWay  alloc] init];
    cityChooseWay.delegate = self;
    [cityChooseWay beginSearch];


    UIBarButtonItem *cancel=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(CanCelAction)];

    self.navigationItem.leftBarButtonItem=cancel;

}
- (void)CanCelAction{
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark -
#pragma mark tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }
    return 36.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, msScreenWidth, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel        = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250,40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor       = [UIColor blackColor];
    titleLabel.font            = [UIFont systemFontOfSize:14];
    titleLabel.centerY         = bgView.height/2;
    NSString *key              = [keys objectAtIndex:section];
    titleLabel.text            = key;
    [bgView addSubview:titleLabel];
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    NSMutableArray *titleKey =[[NSMutableArray alloc] initWithArray:[keys copy]];
    titleKey[0]=@"定位";
    titleKey[1]=@"历史";
    titleKey[2]=@"热门";
    return titleKey;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }else {
       return [keys count]; 
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 44;
    }
    if (indexPath.section<3) {
        if (indexPath.section==2) {
            return 120;
        }else {
            return 70;
        }
    }
    return 40;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }else {
        if (section<3) {
            return 1;
        }
        NSString *key = [keys objectAtIndex:section];
        NSArray *citySection = [cities objectForKey:key];
        
        
        return [citySection count];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if  (tableView == self.searchDisplayController.searchResultsTableView) {
        if (searchResults[indexPath.row]) {
            [self chooseCity:searchResults[indexPath.row]];

        }
    } else {
        if (indexPath.section>=3) {
            
            if ([[cities objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]) {
                [self chooseCity:[[cities objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] ];

            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = searchResults[indexPath.row];
        
        
    } else {
        if (indexPath.section<3) {
            CitySectionsCell *sectionCell=[tableView CitySectionsCell];
            [sectionCell setInfo:indexPath.section];

            sectionCell.width=msScreenWidth;
                if (indexPath.section==2) {
                    cell.height= 120;
                }else {
                    cell.height= 70;
                }
            return sectionCell;
        } else {
            
            cell.textLabel.text = [[cities objectForKey:key] objectAtIndex:indexPath.row];
            return cell;
            
        }
        
    }
    
    return cell;
}


#pragma mark -
#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchResults = [[NSMutableArray alloc]init];
    if (mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i<CitySearchArr.count; i++) {
            if ([ChineseInclude isIncludeChineseInString:CitySearchArr[i]]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:CitySearchArr[i]];
                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:CitySearchArr[i]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:CitySearchArr[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:CitySearchArr[i]];
                }
            }
            else {
                NSRange titleResult=[CitySearchArr[i] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:CitySearchArr[i]];
                }
            }
        }
    } else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (NSString *tempStr in CitySearchArr) {
            NSRange titleResult=[tempStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tempStr];
            }
        }
    }
}




#pragma mark -
#pragma mark CityChooseWayDelegate

- (void)didSearchCitySucceed:(CityChooseResult *)result {
    [[NSUserDefaults standardUserDefaults] setObject:@(succeedLocationBtnTag) forKey:@"cityChooseStatus"];
    [[NSUserDefaults standardUserDefaults] setObject:result.cityName forKey:locationCity];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocationCellNotify" object:nil];
}


- (void)didSearchCityFaild {
    [[NSUserDefaults standardUserDefaults] setObject:@(falidLocationBtntag) forKey:@"cityChooseStatus"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocationCellNotify" object:nil];
    
}



#pragma mark -
#pragma  mark init


- (void)initView {
    self.title = @"选择城市";
    [[NSUserDefaults standardUserDefaults] setObject:@(locationBtnTag) forKey:@"cityChooseStatus"];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"输入城市名称或拼音"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    
    dataTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, msScreenWidth, msScreenHeight+20)];
    
    dataTableView.delegate=self;
    dataTableView.dataSource=self;
    dataTableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    dataTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    dataTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:dataTableView];
    
    dataTableView.tableHeaderView = mySearchBar;
    
}

- (void)initData {
    keys = [[NSMutableArray alloc] initWithObjects:@"定位",@"最近访问城市",@"热门城市" ,nil];
    
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    
    cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [keys addObjectsFromArray:[[cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    CitySearchArr = [[NSMutableArray alloc] init];
    for(id curkey in keys) {
        if (cities[curkey]) {
            for(id curdata in cities[curkey])
            [CitySearchArr addObject:curdata];
        }
    }
}



- (void)chooseCity:(NSString *)aResultOfCityName {
    
    CLLocationCoordinate2D location;
   CityChooseResult *result=[CityChooseResult cityChooseResultMakeWithName:aResultOfCityName andPingYingName:[CityChooseWay getCityPingYing:aResultOfCityName ] andLocation:location];
    
    
    NSMutableArray * cityChooseHistory = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cityChooseHistory"] mutableCopy];
    if (!cityChooseHistory||cityChooseHistory.count==0) {
        cityChooseHistory=[[NSMutableArray alloc] init];
    }
    
    if ([cityChooseHistory indexOfObject:result.cityName]!=NSNotFound) {
        [cityChooseHistory exchangeObjectAtIndex:0 withObjectAtIndex:[cityChooseHistory indexOfObject:result.cityName]];
    }else {
         [cityChooseHistory insertObject:result.cityName atIndex:0];
    }
   
    
    [[NSUserDefaults standardUserDefaults] setObject:[cityChooseHistory copy] forKey:@"cityChooseHistory"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:userDidChooseCityNotify object:result];
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [cityChooseWay stopLocating];
}
- (void) reloadLocation {
    [[NSUserDefaults standardUserDefaults] setObject:@(locationBtnTag) forKey:@"cityChooseStatus"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocationCellNotify" object:nil];
    [cityChooseWay beginSearch];
}

- (void)userDidChooseCityInCellEvent :(NSNotification *)aNotification {
    if (aNotification.object) {
        [self chooseCity:aNotification.object];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
