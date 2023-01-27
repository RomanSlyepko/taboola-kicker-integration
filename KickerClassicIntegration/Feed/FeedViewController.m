//
//  FeedViewController.m
//  KickerClassicIntegration
//
//  Created by Roman Slyepko on 27.01.2023.
//

#import "FeedViewController.h"
// Taboola
#import <TaboolaSDK/TaboolaSDK.h>
// helpers
#import "Constants.h"
#import "UIView+Helper.h"
#import "UIColor+Helper.h"

@interface FeedViewController () <TBLClassicPageDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
// taboola
@property (nonatomic, strong) TBLClassicPage *classicPage;
@property (nonatomic, strong) TBLClassicUnit *taboolaFeedUnit;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Feed";
    [self initTaboola];
}

- (void)initTaboola {
    self.classicPage = [[TBLClassicPage alloc]initWithPageType:TBPageType
                                                       pageUrl:TBPageUrl
                                                      delegate:self
                                                    scrollView:self.collectionView];

    self.taboolaFeedUnit = [self.classicPage createUnitWithPlacementName:TBFeedPlacement mode:TBFeedMode];
    [self.taboolaFeedUnit fetchContent];
}

#pragma mark - UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self isTaboolaSection:section] ? 1 : 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isTaboolaSection:indexPath.section]){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaboolaCollectionViewCell" forIndexPath:indexPath];
        // clean the cell
        [cell.contentView removeAllSubviews];
        // add taboola unit
        [cell.contentView addSubview:self.taboolaFeedUnit];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RandomCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor randomColor];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isTaboolaSection:indexPath.section]) {
        return CGSizeMake(self.view.frame.size.width, self.taboolaFeedUnit.placementHeight);
    }
    return CGSizeMake(self.view.frame.size.width, 200);
}

#pragma mark - Helper methods

- (BOOL)isTaboolaSection:(NSUInteger)section {
    return section == 1;
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
