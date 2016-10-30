# DSLTransition
自定义UIViewController的present转场

使用：
```
#import "UIViewController+DSLTransition.h"

//开启自定义转场
self.dsl_transitionEnabled = YES;
//关闭
//self.dsl_transitionEnabled = NO;

//设置转场类型
self.dsl_transitionType = 1;
//present
[self presentViewController:vc animated:YES completion:nil];
//dismiss
[self dismissViewControllerAnimated:YES completion:nil];
```
其他参数设置详见Demo
