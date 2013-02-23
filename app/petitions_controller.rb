class PetitionsController < RefreshableTableViewController
  attr_accessor :navController, :filters

  def viewDidLoad
    super

    self.title = "Petitions"

    @petitions = []
    @filters = {}
    @cursor = WeThePeople::Resources::Petition.cursor

    view.dataSource = view.delegate = self

    button = UIBarButtonItem.alloc.init
    button.title = 'Filter'
    button.target = self
    button.action = 'filter'
    button.tintColor = UIColor.blackColor

    self.navigationItem.rightBarButtonItem = button

    getPetitions

    @callbacks[:infinite_scroll] = lambda { getPetitions }
  end

  def filter
  end

  def getPetitions
    Dispatch::Queue.concurrent.async do 
      $stdout.puts @cursor.offset
      @cursor.next_page
      @petitions = @cursor.all

      Dispatch::Queue.main.sync do
        view.reloadData
        doneReloadingTableViewData
      end
    end
  end
 
  def presentError(error)
    # TODO
    $stderr.puts error.description
  end
 
  def tableView(tableView, numberOfRowsInSection:section)
    @petitions.size
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    PetitionCell.heightForPetition(@petitions[indexPath.row], tableView.frame.size.width)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    petition = @petitions[indexPath.row]
    PetitionCell.cellForPetition(petition, inTableView:tableView)
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    viewController = PetitionViewController.alloc.initWithPetition(@petitions[indexPath.row])
    viewController.navController = @navController
    @navController.pushViewController(viewController, animated: true)
  end
  
  def reloadRowForPetition(petition)
    row = @petitions.index(petition)

    if row
      view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end

  def doneReloadingTableViewData
    super
    view.reloadData
  end

  def refreshTableHeaderDidTriggerRefresh(view)
    Dispatch::Queue.concurrent.async do 
      @cursor.get_all(true)
      @petitions = @cursor.all

      Dispatch::Queue.main.sync do
        doneReloadingTableViewData
      end
    end
  end

end
