//
//  ViewController.m
//  SpringCollectionView_Oc
//
//  Created by mac on 2018/1/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"
#import "SpringCollectionLayout.h"
@interface ViewController ()<UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

static NSString *reuseId = @"collectionViewCellReuseId";

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    SpringCollectionLayout * flowLayout = [[SpringCollectionLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, 44);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewID"];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
