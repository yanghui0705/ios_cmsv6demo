#import "DeviceSearchView.h"
#import "netmediaapi.h"
#import "iToast.h"
#import "DeviceSearch.h"
#import "TTXSubVideo.h"

#define SEARCH_DEFAULT_PORT  6688
@interface DeviceSearchView ()

@property (nonatomic , strong)TTXSubVideo *video1;
@end
@implementation DeviceSearchView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
    self.navigationItem.title = NSLocalizedString(@"devsearch_title", "");
    self.navigationController.navigationBarHidden =NO;
    self.deviceTableView.dataSource = self;
    self.deviceTableView.delegate = self;
    self.deviceTableView.separatorStyle = NO;
    [self.deviceTableView setBackgroundView:nil];

    _video1 = [[TTXSubVideo alloc] init];
    CGFloat wh = (kScreenWidth - 15) / 2;
    _video1.frame = CGRectMake(5, kScreenHeight / 2.0 + 5, wh, wh);
    [self.view addSubview:_video1];
    

    _loadLabel.hidden = YES;
    _loadLabel.textAlignment = NSTextAlignmentCenter;
    _loadLabel.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
    

    _loadLabel.frame = CGRectMake(kScreenWidth /2 - 310/2, kScreenHeight/2 - 30/2, 310, 30);
    deviceList = [[NSMutableArray alloc]init];
    isPresent = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!isPresent) {
        [self startSearchDevice];
    }
    isPresent = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopSearchDevice];
}
- (void)startSearchDevice {
    if (0 == handle) {
        if ([deviceList count] > 0) {
            [deviceList removeAllObjects];
            [self.deviceTableView reloadData];
        }
        _loadLabel.text = NSLocalizedString(@"devsearch_ing", @"");
        _loadLabel.hidden = NO;
        NETMEDIA_SDOpenSearch(&handle);
        NETMEDIA_SDStartSearch(handle, "", SEARCH_DEFAULT_PORT);
        searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(onTimerSearch) userInfo:nil repeats:YES ];
    }
}
- (void)stopSearchDevice {
    if (0 != handle) {
        NETMEDIA_SDStopSearch(handle);
        NETMEDIA_SDCloseSearch(handle);
        handle = 0;
        _loadLabel.text = @"";
        if( searchTimer != nil) {
            [searchTimer invalidate ];
            searchTimer = nil;
        }
    }
}
- (void) onTimerSearch {
    char result[1024] = {0};
    int ret = NETMEDIA_SDGetSearchResult(handle, result, 1024);
    NSLog(@"ret = %d",ret);
    if (ret == NETMEDIA_OK) {
        NSString *str = [NSString stringWithCString:result encoding:NSUTF8StringEncoding];
        if (str == nil) return;
        NSArray *aArray = [str componentsSeparatedByString:@":"];
        DeviceSearch* search = [[DeviceSearch alloc] init];
        int index = 0;
        search.devIdno = aArray[index ++];
        search.netType = [aArray[index ++] intValue];
        search.netName = aArray[index ++];
        search.ipAddr = aArray[index ++];
        search.devType  = [aArray[index ++] intValue];
        search.channel = [aArray[index ++] intValue];
        search.webPort  = [aArray[index ++] intValue];
        if (search.webPort == 0) {
            search.webPort = 80;
        }
        search.webUrl = aArray[index ++];
        [deviceList addObject:search];
    } else if (ret == NETMEDIA_SEARCH_FINISHED) {
        [self stopSearchDevice];
        if ([deviceList count] > 0) {
            [self.deviceTableView reloadData];
        } else {
            _loadLabel.text = NSLocalizedString(@"devsearch_null", @"");
            _loadLabel.hidden = NO;
        }
    }
}
- (void)showToast:(NSString*)key
{
    [[[iToast makeText:NSLocalizedString(key, "")] setGravity:iToastGravityCenter offsetLeft:0 offsetTop:-56] show];
}
- (void)onBack:(UIButton*)btn  {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)onRefresh:(UIButton*)btn {
    [self stopSearchDevice];
    [self startSearchDevice];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (deviceList != nil) {
        return 1;
    } else {
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [deviceList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DSCellIdentifier = @"DSCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DSCellIdentifier];
//    DeviceCell *cell = (DeviceCell *)[tableView dequeueReusableCellWithIdentifier:DSCellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DSCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    unsigned long row = [indexPath row];
    DeviceSearch* search = [deviceList objectAtIndex:row];
    NSString *devIdno = [NSString stringWithFormat:@"IDNO:%@ ", search.devIdno];
    NSString* netInfo;
    if (search.netType == 0) {
        netInfo = [NSString stringWithFormat:@"%@", @"3G"];
    } else if (search.netType == 1) {
        netInfo =  [NSString stringWithFormat:@"Wifi(%@)  %@", search.netName, search.ipAddr ];
    } else {
        netInfo =  [NSString stringWithFormat:@"Net  %@", search.ipAddr ];
    }
    cell.textLabel.text = [devIdno stringByAppendingString:netInfo];
//    cell.mLbStatus.text = netInfo;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceSearch* search = [deviceList objectAtIndex:indexPath.row];
    [_video1 StopAV];
    [_video1 setViewInfo:search.devIdno idno:search.devIdno chn:0 name:@"CH1"];
    [_video1 setLanInfo:search.ipAddr port:6688];
    [_video1 StartAV];
    //        directUrl = [NSString stringWithFormat:@"http://%@:%ld/%@", search.ipAddr, (long)search.webPort, search.webUrl ]
}
#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
@end
