class SignaturesController < RefreshableTableViewController
  def initWithPetition(petition)
    @petition = petition
    initWithNibName(nil, bundle: nil)
  end

  def viewDidLoad
    super

    self.title = "Signatures"

    @signatures = []
    @cursor = @petition.signatures.cursor

    view.dataSource = view.delegate = self

    getSignatures

    @callbacks[:infinite_scroll] = lambda { get_signatures }
  end

  def getSignatures
    Dispatch::Queue.concurrent.async do 
      @cursor.next_page
      @signatures = @cursor.all

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
    @signatures.size
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    SignatureCell.heightForContent(SignatureCell.signatureString(@signatures[indexPath.row]), tableView.frame.size.width)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    signature = @signatures[indexPath.row]
    SignatureCell.cellFor(signature, inTableView:tableView)
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end
  
  def reloadRowForSignature(signature)
    row = @signatures.index(signature)

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
      @signatures = @cursor.all

      Dispatch::Queue.main.sync do
        doneReloadingTableViewData
      end
    end
  end

end
