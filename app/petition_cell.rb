class PetitionCell < CustomTableCell
  def fill(petition, inTableView:tableView)
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
    
    super
  end
end