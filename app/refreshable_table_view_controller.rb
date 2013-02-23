#  RefreshableTableViewController
#
#  RubyMotion implementation of https://github.com/enormego/EGOTableViewPullRefresh
#
#  Created By Richard Owens, 2012/05/04
#  Copyright 2012 Richard Owens.  All rights reserved. 
#
#  Updated By Rod Wilhelmy, 2012/09/28
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
class RefreshableTableViewController < UITableViewController

  def viewDidLoad
    super
    @callbacks = {}
    @refreshHeaderView ||= begin
      table_height = tableView.bounds.size.height
      table_width = tableView.bounds.size.width
      table_frame = CGRectMake(0, -table_height, table_width, table_height)
      rhv = RefreshTableHeaderView.alloc.initWithFrame(table_frame)
      rhv.delegate = self
      rhv.refreshLastUpdatedDate
      tableView.addSubview(rhv)
      rhv
    end
  end

  def reloadTableViewDataSource
    @reloading = true
  end

  def doneReloadingTableViewData
    @reloading = false
    @refreshHeaderView.refreshScrollViewDataSourceDidFinishLoading(self.tableView)
  end

  def hit_bottom?(scrollView)
    scrollView.contentOffset.y > (scrollView.contentSize.height - tableView.bounds.size.height)
  end

  def scrollViewDidScroll(scrollView)
    @refreshHeaderView.refreshScrollViewDidScroll(scrollView)

    # Infinite scrolling
    if @reloading == false and hit_bottom?(scrollView) and not @callbacks[:infinite_scroll].nil?
      @reloading = true
      @callbacks[:infinite_scroll].call()
    end
  end

  def scrollViewDidEndDragging(scrollView, willDecelerate:decelerate)
    @refreshHeaderView.refreshScrollViewDidEndDragging(scrollView)
  end

  # Delegate methods

  def refreshTableHeaderDidTriggerRefresh(view)
    self.reloadTableViewDataSource
    self.performSelector('doneReloadingTableViewData', withObject:nil, afterDelay:3)
  end

  def refreshTableHeaderDataSourceIsLoading(view)
    @reloading
  end

  def refreshTableHeaderDataSourceLastUpdated(view)
    Time.now.strftime("%D %T")
  end

end