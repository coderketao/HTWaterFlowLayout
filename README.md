# HTWaterFlowLayout

<img src= "https://github.com/coderketao/HTWaterFlowLayout/blob/master/HTWaterFlowLayoutExample/Sources/1.gif" width="500">

```objc
HTWaterFlowLayout *waterFlow = [[HTWaterFlowLayout alloc] init];
waterFlow.delegate = self;

UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:waterFlow];
collectionView.backgroundColor = [UIColor whiteColor];
collectionView.dataSource = self;
[collectionView registerNib:[UINib nibWithNibName:@"HTShopCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
[self.view addSubview: _collectionView = collectionView];
```
