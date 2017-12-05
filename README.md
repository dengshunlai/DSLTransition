# DSLTransition
自定义UIViewController的present转场

使用：
```
#import "UIViewController+DSLTransition.h"

NextViewController *vc = [[NextViewController alloc] init];
//设置转场类型,0是系统默认的转场
vc.dsl_transitionType = 1;
//present方法不变
[self presentViewController:vc animated:YES completion:nil];
//dismiss方法不变
[self dismissViewControllerAnimated:YES completion:nil];
```
其他参数设置详见Demo


## 支持cocoapods
pod 'DSLTransition'
