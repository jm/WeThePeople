class PetitionCell < UITableViewCell
  CellID = 'PetitionCellIdentifier'

  def self.cellForPetition(petition, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(PetitionCell::CellID) || PetitionCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    cell.fillWithPetition(petition, inTableView:tableView)

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
 
  def fillWithPetition(petition, inTableView:tableView)
    self.textLabel.text = petition.title
    self.textLabel.font = UIFont.boldSystemFontOfSize(14)

    self.detailTextLabel.text = "#{petition.signature_count} signatures — #{petition.body.slice(0, 100)}"

    if petition.failed?
      self.textLabel.font = UIFont.systemFontOfSize(14)
      self.textLabel.textColor = UIColor.colorWithRed(0.8, green:0.2, blue:0.1, alpha:1)
    elsif petition.successful?
      self.textLabel.font = UIFont.boldSystemFontOfSize(14)
      self.textLabel.textColor = UIColor.colorWithRed(0.1, green:0.5, blue:0.1, alpha:1)
    else
      self.textLabel.font = UIFont.boldSystemFontOfSize(14)
      self.textLabel.textColor = UIColor.blackColor
    end
    self.imageView.image = nil
  end

  def self.heightForPetition(petition, width)
    constrain = CGSize.new(width, 1000)
    size = petition.title.sizeWithFont(UIFont.systemFontOfSize(14), constrainedToSize:constrain)
    [57, size.height + 8].max
  end
end