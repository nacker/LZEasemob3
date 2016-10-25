/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "EMChooseViewController.h"

@interface EMChooseViewController ()

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *selectedIndexPaths;

@end

@implementation EMChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
        
        _mulChoice = NO;
        _defaultEditing = NO;
        _showAllIndex = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    _indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    if (!self.defaultEditing) {
        UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [chooseButton setTitle:NSLocalizedString(@"choose", @"Choose") forState:UIControlStateNormal];
        [chooseButton setTitle:NSLocalizedString(@"down", @"Down") forState:UIControlStateSelected];
        [chooseButton setBackgroundColor:[UIColor clearColor]];
        [chooseButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:chooseButton]];
    }
    else{
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [doneButton setTitle:NSLocalizedString(@"down", @"Down") forState:UIControlStateNormal];
        [doneButton setBackgroundColor:[UIColor clearColor]];
        [doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    }
    
    [self.view addSubview:self.tableView];
    self.tableView.editing = self.defaultEditing;
    
    if (_viewDidLoadBlock) {
        _viewDidLoadBlock(self);
    }
    
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)sectionTitles
{
    if (_sectionTitles == nil) {
        _sectionTitles = [NSMutableArray array];
    }
    
    return _sectionTitles;
}

- (NSMutableArray *)selectedIndexPaths
{
    if (_selectedIndexPaths == nil) {
        _selectedIndexPaths = [NSMutableArray array];
    }
    
    return _selectedIndexPaths;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.dataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellForRowAtIndexPath) {
        return _cellForRowAtIndexPath(tableView, indexPath);
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_heightForRowAtIndexPathCompletion)
    {
        id object = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return _heightForRowAtIndexPathCompletion(object);
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.showAllIndex && [[self.dataSource objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.showAllIndex && [[self.dataSource objectAtIndex:section] count] == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[self.sectionTitles objectAtIndex:section]];
    [contentView addSubview:label];
    return contentView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.showAllIndex) {
        return self.sectionTitles;
    }
    else{
        NSMutableArray * existTitles = [NSMutableArray array];
        //section数组为空的title过滤掉，不显示
        for (int i = 0; i < [self.sectionTitles count]; i++) {
            if ([[self.dataSource objectAtIndex:i] count] > 0) {
                [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
            }
        }
        return existTitles;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didSelectRowAtIndexPathCompletion) {
        id object = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        _didSelectRowAtIndexPathCompletion(object);
    }
    else{
        if (![self.selectedIndexPaths containsObject:indexPath])
        {
            [self.selectedIndexPaths addObject:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        [self.selectedIndexPaths removeObject:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}

#pragma mark - public

- (NSInteger)sectionForString:(NSString *)string
{
    if (string && string.length > 0) {
        return [_indexCollation sectionForObject:string collationStringSelector:@selector(uppercaseString)];
    }
    else{
        return -1;
    }
}

- (NSArray *)sortRecords:(NSArray *)recordArray
{
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[_indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    if (_objectComparisonStringBlock) {
        for (id object in recordArray) {
            //getUserName是实现中文拼音检索的核心，见NameIndex类
            NSString *objStr = _objectComparisonStringBlock(object);
            NSInteger section = [_indexCollation sectionForObject:objStr collationStringSelector:@selector(uppercaseString)];
            
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:object];
        }
    }
    
    //每个section内的数组排序
    if (_comparisonObjectSelector) {
        __weak typeof(self) weakSelf = self;
        for (int i = 0; i < [sortedArray count]; i++) {
            NSArray *tmpArray = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return weakSelf.comparisonObjectSelector(obj1, obj2);
            }];
            
            [sortedArray replaceObjectAtIndex:i withObject:tmpArray];
        }
    }
    
    return sortedArray;
}

#pragma mark - data

- (void)loadDataSource
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewControllerLoadDataSource:)]) {
        [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
        
        NSArray *array = [_delegate viewControllerLoadDataSource:self];
        [self.dataSource addObjectsFromArray:[self sortRecords:array]];
        
        [self hideHud];
        [self.tableView reloadData];
    }
}

#pragma mark - action

- (void)chooseAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [self.tableView setEditing:YES animated:YES];
    }
    else{
        [self.tableView setEditing:NO animated:YES];
        [self doneAction:nil];
    }
}

- (void)doneAction:(id)sender
{
    BOOL isPop = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:didFinishSelectedSources:)]) {
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in self.selectedIndexPaths) {
            [resultArray addObject:[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        }
        
        isPop = [_delegate viewController:self didFinishSelectedSources:resultArray];
    }
    
    if (isPop) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
