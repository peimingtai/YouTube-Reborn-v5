#import "PictureInPictureOptionsController.h"
#import "Localization.h"

@interface PictureInPictureOptionsController ()
- (void)coloursView;
@end

@implementation PictureInPictureOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self coloursView];

    self.title = LOC(@"PICTURE_IN_PICTURE_OPTIONS");

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = doneButton;

    UITableViewStyle style;
        if (@available(iOS 13, *)) {
            style = UITableViewStyleInsetGrouped;
        } else {
            style = UITableViewStyleGrouped;
        }

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.tableView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.tableView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.tableView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor]
    ]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PictureInPictureTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
	    cell.textLabel.shadowColor = [UIColor blackColor];
            cell.textLabel.shadowOffset = CGSizeMake(1.0, 1.0);
            cell.detailTextLabel.textColor = [UIColor whiteColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = LOC(@"ENABLE_PICTURE_IN_PICTURE");
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kRebornIHaveYouTubePremium"] == YES) {
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
            } else {
                UISwitch *enablePictureInPicture = [[UISwitch alloc] initWithFrame:CGRectZero];
                [enablePictureInPicture addTarget:self action:@selector(toggleEnablePictureInPicture:) forControlEvents:UIControlEventValueChanged];
                enablePictureInPicture.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnablePictureInPictureVTwo"];
                cell.accessoryView = enablePictureInPicture;
            }
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = LOC(@"HIDE_PIP_ADS_BADGE");
            UISwitch *hidePictureInPictureAdsBadge = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hidePictureInPictureAdsBadge addTarget:self action:@selector(toggleHidePictureInPictureAdsBadge:) forControlEvents:UIControlEventValueChanged];
            hidePictureInPictureAdsBadge.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHidePictureInPictureAdsBadge"];
            cell.accessoryView = hidePictureInPictureAdsBadge;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = LOC(@"HIDE_PIP_SPONSOR_BADGE");
            UISwitch *hidePictureInPictureSponsorBadge = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hidePictureInPictureSponsorBadge addTarget:self action:@selector(toggleHidePictureInPictureSponsorBadge:) forControlEvents:UIControlEventValueChanged];
            hidePictureInPictureSponsorBadge.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHidePictureInPictureSponsorBadge"];
            cell.accessoryView = hidePictureInPictureSponsorBadge;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIAlertController *alertError = [UIAlertController alertControllerWithTitle:LOC(@"NOTICE_TEXT") message:LOC(@"DISABLE_PREMIUM_TEXT") preferredStyle:UIAlertControllerStyleAlert];

        [alertError addAction:[UIAlertAction actionWithTitle:LOC(@"OKAY_TEXT") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];

        [self presentViewController:alertError animated:YES completion:nil];
    }
}

- (void)coloursView {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self coloursView];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.layer.cornerRadius = 10.0;
    self.view.layer.masksToBounds = YES;
}

@end

@implementation PictureInPictureOptionsController (Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleEnablePictureInPicture:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnablePictureInPictureVTwo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kEnablePictureInPictureVTwo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHidePictureInPictureAdsBadge:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHidePictureInPictureAdsBadge"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHidePictureInPictureAdsBadge"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHidePictureInPictureSponsorBadge:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHidePictureInPictureSponsorBadge"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHidePictureInPictureSponsorBadge"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
