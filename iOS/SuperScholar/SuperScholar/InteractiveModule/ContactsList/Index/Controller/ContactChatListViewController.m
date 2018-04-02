//
//  ContactChatListViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ContactChatListViewController.h"
#import "IMManager.h"
#import "ContactChatListTableViewCell.h"
#import "SPUtil.h"
#import <SVProgressHUD.h>

@interface ContactChatListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YWFetchedResultsController *fetchedResultsController;
@end

@implementation ContactChatListViewController

#pragma mark - <************************** 页面生命周期 **************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    // 获取数据
    [self getDataFormServer];
    
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactChatListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"ContactChatListTableViewCell"];
    self.tableView.separatorColor =[UIColor colorWithWhite:1.f*0xdf/0xff alpha:1.f];
}

- (void)configNavigationBar{
}

#pragma mark - <*********************** 初始化控件/数据 **********************>




#pragma mark - <************************** 代理方法 **************************>

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactChatListTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ContactChatListTableViewCell"
                                                         forIndexPath:indexPath];
    
    YWPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.identifier = person.personId;
    
    __block NSString *displayName = nil;
    __block UIImage *avatar = nil;
    //  SPUtil中包含的功能都是Demo中需要的辅助代码，在你的真实APP中一般都需要替换为你真实的实现。
    [[SPUtil sharedInstance] syncGetCachedProfileIfExists:person completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
        displayName = aDisplayName;
        avatar = aAvatarImage;
    }];
    
    if (!displayName || avatar == nil ) {
        displayName = person.personId;
        
        __weak __typeof(self) weakSelf = self;
        __weak __typeof(cell) weakCell = cell;
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:person
                                                  progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndexPath = [weakSelf.tableView indexPathForCell:weakCell];
                                                          if (!aIndexPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.tableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  } completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndexPath = [weakSelf.tableView indexPathForCell:weakCell];
                                                          if (!aIndexPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.tableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  }];
    }
    
    if (!avatar) {
        avatar = kPlaceholderHeadImage;
    }
    
    [cell configureWithAvatar:avatar title:displayName subtitle:nil];
    
    return cell;
}

#pragma mark UITableDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section >= [[self.fetchedResultsController sectionIndexTitles] count]) {
        return nil;
    }
    return [self.fetchedResultsController sectionIndexTitles][(NSUInteger)section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [self.fetchedResultsController sectionIndexTitles];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.mode == ContactChatListModeMultipleSelection) {
//        return;
//    }
//    else if (self.mode == ContactChatListModeSingleSelection) {
//        // 取消选中之前已选中的 cell
//        NSMutableArray *selectedRows = [[tableView indexPathsForSelectedRows] mutableCopy];
//        [selectedRows removeObject:indexPath];
//        for (NSIndexPath *indexPath in selectedRows) {
//            [tableView deselectRowAtIndexPath:indexPath animated:NO];
//        }
//    }
//    else {
        YWPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setTextColor:[UIColor lightGrayColor]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.mode == ContactChatListModeMultipleSelection || self.mode == ContactChatListModeSingleSelection) {
//        return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
//    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mode == ContactChatListModeNormal) {
        YWPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        __weak typeof(self) weakSelf = self;
        [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] removeContact:person withResultBlock:^(NSError *error, NSArray *personArray) {
            if (error == nil) {
                [SVProgressHUD showSuccessWithStatus:@"删除好友成功"];
                [weakSelf.tableView reloadData];
            } else {
                [SVProgressHUD showErrorWithStatus:@"删除好友失败"];
            }
        }];
    }
}


#pragma mark - <************************** 点击事件 **************************>




#pragma mark - <************************** 其他方法 **************************>

#pragma mark - FRC
- (YWFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController == nil) {
        YWIMCore *imcore = [SPKitExample sharedInstance].ywIMKit.IMCore;
        _fetchedResultsController = [[imcore getContactService] fetchedResultsControllerWithListMode:YWContactListModeAlphabetic imCore:imcore];
        
        __weak typeof(self) weakSelf = self;
        [_fetchedResultsController setDidChangeContentBlock:^{
            [weakSelf.tableView reloadData];
        }];
        
        [_fetchedResultsController setDidResetContentBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }
    return _fetchedResultsController;
}


#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}


@end
