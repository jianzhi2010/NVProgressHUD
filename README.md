# NVProgressHUD
A simple progress HUD using [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) 

![image](https://github.com/jianzhi2010/NVProgressHUD/blob/master/NVProgressHUDDemo/image/demo01.png)
![image](https://github.com/jianzhi2010/NVProgressHUD/blob/master/NVProgressHUDDemo/image/demo02.png)
![image](https://github.com/jianzhi2010/NVProgressHUD/blob/master/NVProgressHUDDemo/image/demo03.png)

# Installation
Just drag the NVProgressHUD.swift file into your project, and install [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) 

# Usage
Firstly,import NVActivityIndicatorView

Then,you can use NVProgressHUD as simple as this:
```
self.navigationController?.view.showHUD(true)
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
    // time-consuming task...
    self.navigationController?.view.hideHUD(true)
}
```

If you need to configure the HUD, you can do this:
```
 hud = NVProgressHUD(frame: self.navigationController!.view.frame)
 self.navigationController!.view.addSubview(hud)
 
 hud.labelText = "Loading"
 hud.show(true) 
 hud.hide(true, afterDelay: 2.0) // hide the HUD 
```

For more details, take a look at the demo project.

