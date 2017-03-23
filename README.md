# GZQRCodeScanDemo

这是一个原生的二维码、条形码扫描控件

QRCodeScanView 扫描视图

QRCodeCreateTools  二维码、条形码生成工具，你还可以生成中间带小图标的二维码

创建扫面视图你只需要：

- (void)viewDidLoad {
[super viewDidLoad];
// Do any additional setup after loading the view.
self.view.backgroundColor = [UIColor whiteColor];

self.scanView = [[QRCodeScanView alloc] initWithFrame:[UIScreen mainScreen].bounds minX:0.2 minY:0.2];
[self.view insertSubview:self.scanView atIndex:0];
}

生成一个二维码
UIImage *qrcode = [QRCodeCreateTools creatQRCodeWithUrlstring:@"这是一个二维码" imageWidth:200];

生成一个中间带小图标的二维码
    UIImage *iconQrcode = [QRCodeCreateTools creatQRCodeWithUrlstring:@"这是一个带头像的二维码" imageWidth:200 withIcon:icon withScale:0.2];

生成一个条形码
UIImage *qrcode = [QRCodeCreateTools creatBarCode:@"11234598765" width:300 height:100];


如在使用中有任何问题，欢迎交流！  QQ:  1141189194


