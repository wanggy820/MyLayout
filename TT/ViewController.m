//
//  ViewController.m
//  TT
//
//  Created by wangchunxiang on 2016/11/28.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import "ViewController.h"

#import "MyLayout.h"



#define kDegreesToRadian(x) (M_PI * (x) / 180.0 )
#define kRadianToDegrees(radian) (radian* 180.0 )/(M_PI)


#import "JRBubbleView.h"


@interface ViewController ()<CAAnimationDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    
    void (^_handlerBlock)();
}
- (IBAction)stop:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textFied;


@end

@implementation ViewController
{
    UICollectionView * collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 

    
    MyLayout * layout = [[MyLayout alloc] init];
    collectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 400) collectionViewLayout:layout];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.view addSubview:collectionView];

    collectionView.backgroundColor = [UIColor whiteColor];
//    collectionView.decelerationRate = 0.8;
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 25;
    cell.clipsToBounds = YES;
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return cell;
}







- (IBAction)stop:(id)sender {
    [collectionView reloadData];
    

}




@end

