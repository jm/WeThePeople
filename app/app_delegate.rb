class AppDelegate
  attr_reader :nav_controller

  def application(application, didFinishLaunchingWithOptions:launchOptions)    
    WeThePeople::Config.api_key = ""

    # Nav controllers are dumb.
    @window = UIWindow.alloc.initWithFrame(CGRectOffset(UIScreen.mainScreen.applicationFrame, 0.0, -20.0))
    petitionsController = PetitionsController.alloc.initWithStyle(UITableViewStylePlain)

    @navController = UINavigationController.alloc.initWithRootViewController(petitionsController)
    @navController.navigationBar.tintColor = UIColor.colorWithRed(0.1, green:0.2, blue:0.6, alpha:0.3)
    petitionsController.navController = @navController

    @window.rootViewController = navController
    @window.makeKeyAndVisible

    true
  end
end
