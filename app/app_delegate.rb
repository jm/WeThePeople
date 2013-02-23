class AppDelegate
  attr_reader :nav_controller

  def application(application, didFinishLaunchingWithOptions:launchOptions)    
    WeThePeople::Config.api_key = ""

    # Nav controllers are dumb.
    @window = UIWindow.alloc.initWithFrame(CGRectOffset(UIScreen.mainScreen.applicationFrame, 0.0, -20.0))
    petitions_controller = PetitionsController.alloc.initWithStyle(UITableViewStylePlain)

    @nav_controller = UINavigationController.alloc.initWithRootViewController(petitions_controller)
    @nav_controller.navigationBar.tintColor = UIColor.colorWithRed(0.1, green:0.2, blue:0.6, alpha:0.3)
    petitions_controller.nav_controller = @nav_controller

    @window.rootViewController = nav_controller
    @window.makeKeyAndVisible

    true
  end
end
