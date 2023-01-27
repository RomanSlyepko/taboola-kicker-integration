//
//  WidgetViewController.m
//  KickerClassicIntegration
//
//  Created by Roman Slyepko on 27.01.2023.
//

#import "WidgetViewController.h"
// Taboola
#import <TaboolaSDK/TaboolaSDK.h>
// helpers
#import "Constants.h"
#import "UIView+Helper.h"
#import "UIColor+Helper.h"

@interface WidgetViewController () <TBLClassicPageDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
// taboola
@property (nonatomic, strong) TBLClassicPage *classicPage;
@property (nonatomic, strong) TBLClassicUnit *taboolaWidgetUnit1;
@property (nonatomic, strong) TBLClassicUnit *taboolaWidgetUnit2;
@property (nonatomic, strong) TBLClassicUnit *taboolaWidgetUnit3;

@end

@implementation WidgetViewController

- (void)viewDidLoad {
    self.title = @"Widget 3x";
    [super viewDidLoad];
    [self initTaboola];
}

- (void)initTaboola {
    self.classicPage = [[TBLClassicPage alloc]initWithPageType:TBPageType
                                                       pageUrl:TBPageUrl
                                                      delegate:self
                                                    scrollView:self.collectionView];

    self.taboolaWidgetUnit1 = [self.classicPage createUnitWithPlacementName:@"Kicker Testing" mode:TBWidgetMode];
    self.taboolaWidgetUnit2 = [self.classicPage createUnitWithPlacementName:@"Kicker Testing" mode:TBWidgetMode];
    self.taboolaWidgetUnit3 = [self.classicPage createUnitWithPlacementName:@"Kicker Testing" mode:TBWidgetMode];

    [self.taboolaWidgetUnit1 fetchContent];
    [self.taboolaWidgetUnit2 fetchContent];
    [self.taboolaWidgetUnit3 fetchContent];
}

#pragma mark - UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self isTaboolaSection:section] ? 1 : 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isTaboolaSection:indexPath.section]){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaboolaCollectionViewCell" forIndexPath:indexPath];
        [cell.contentView removeAllSubviews];

        TBLClassicUnit *unit = [self unitForSection:indexPath.section];
        [cell.contentView addSubview:unit];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RandomCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor randomColor];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isTaboolaSection:indexPath.section]) {
        TBLClassicUnit *unit = [self unitForSection:indexPath.section];
        return CGSizeMake(self.view.frame.size.width, unit.placementHeight);
    }
    return CGSizeMake(self.view.frame.size.width, 200);
}

#pragma mark - Helper methods

- (BOOL)isTaboolaSection:(NSUInteger)section {
    return section != 0;
}

- (TBLClassicUnit *)unitForSection:(NSUInteger)section {
    switch (section) {
        case 1:
            return self.taboolaWidgetUnit1;
        case 2:
            return self.taboolaWidgetUnit2;
        case 3:
            return self.taboolaWidgetUnit3;
    }
    return nil;
}

#pragma mark - TBLClassicPageDelegate

- (void)classicUnit:(UIView *)classicUnit didLoadOrResizePlacementName:(NSString *)placementName height:(CGFloat)height placementType:(PlacementType)placementType {
    NSLog(@"TaboolaSDK: didLoadOrResize %@ height: %.2f", placementName, height);

    TBLClassicUnit *unit = (TBLClassicUnit *)classicUnit;
    [unit setFrame:CGRectMake(unit.frame.origin.x, unit.frame.origin.y, self.view.frame.size.width,unit.placementHeight)];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)classicUnit:(UIView *)classicUnit didFailToLoadPlacementName:(NSString *)placementName errorMessage:(NSString *)error {
    NSLog(@"TaboolaSDK: didFailToLoad %@", error);
}

- (BOOL)classicUnit:(UIView *)classicUnit didClickPlacementName:(NSString *)placementName itemId:(NSString *)itemId clickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic customData: (NSDictionary *)customData {
    return YES;
}

@end
