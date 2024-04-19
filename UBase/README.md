# UBase

### 注意事项

1. 使用之前需要配置一下内容

```swift
    // 列表空数据全局样式
    var appearance = ListEmptyAppearance()
    appearance.text = "暂无相关结果"
    appearance.image = UIImage(named: "icon_list_empty")
    appearance.emptyViewType = ListEmptyView.self
    UBase.emptyAppearance = appearance

    UHUD.loadViewType = LoadingView.self
    UHUD.errorViewType = ErrorView.self
```

2. `TableView`、`CollectionView`的使用

*继承`BaseTableViewController`的控制器，如果使用xib，需要注意xib中`UITableView`控件设置成`TableView`*

*继承`BaseCollectionViewController`的控制器，如果使用xib，需要注意xib中`UICollectionView`控件设置成`CollectionView`*

`reloadData()`方法自动判断列表是否为空并加载空数据提示view
