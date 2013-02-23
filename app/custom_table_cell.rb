class CustomTableCell < UITableViewCell
  def self.cellFor(obj, inTableView:tableView)
    cellID = "#{self.class.name}ID"
    cell = tableView.dequeueReusableCellWithIdentifier(cellID) || self.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:cellID)
    cell.fill(obj, inTableView:tableView)

    cell
  end
 
  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.textLabel.font = UIFont.boldSystemFontOfSize(14)
      self.detailTextLabel.font = UIFont.systemFontOfSize(12)
      self.textLabel.textColor = UIColor.blackColor
    end

    self
  end
 
  def fill(obj, inTableView:tableView)
    self.imageView.image = nil
  end

  def self.heightForContent(content, width)
    constrain = CGSize.new(width, 1000)
    size = content.sizeWithFont(UIFont.systemFontOfSize(14), constrainedToSize:constrain)
    [57, size.height + 8].max
  end
end