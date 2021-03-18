//
//  TableDemoViewController.m
//  Example
//
//  Created by Yanni Wang on 18/3/21.
//

#import "TableDemoViewController.h"
@import EmbeddedScrollView;

@interface EmbeddedTableViewCell : UITableViewCell<UITableViewDataSource>
@property (nonatomic, strong) UITableView *embeddedTableView;
@end

@implementation EmbeddedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UITableView *embeddedTableView = [[UITableView alloc] init];
        embeddedTableView.dataSource = self;
        [embeddedTableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [self.contentView addSubview:embeddedTableView];
        self.embeddedTableView = embeddedTableView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.embeddedTableView.frame = self.contentView.bounds;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    cell.contentView.backgroundColor = UIColor.orangeColor;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

@end

static NSUInteger embeddedTableViewIndex = 20;

@interface TableDemoViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation TableDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat offsetY = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    UITableView *outerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - offsetY)];
    outerTableView.dataSource = self;
    outerTableView.delegate = self;
    [outerTableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [outerTableView registerClass:EmbeddedTableViewCell.class forCellReuseIdentifier:NSStringFromClass(EmbeddedTableViewCell.class)];
    [self.view addSubview:outerTableView];

}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == embeddedTableViewIndex) {
        EmbeddedTableViewCell *embeddedCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(EmbeddedTableViewCell.class) forIndexPath:indexPath];
        tableView.embeddedScrollView = embeddedCell.embeddedTableView;
        cell = embeddedCell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40 + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == embeddedTableViewIndex ? tableView.frame.size.height : 44;
}

@end


