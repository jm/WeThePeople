class SignatureCell < UITableViewCell
  CellID = 'SignatureCellIdentifier'

  def self.cellForSignature(signature, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(SignatureCell::CellID) || SignatureCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    cell.fillWithSignature(signature, inTableView:tableView)

    cell
  end
 
  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.textLabel.font = UIFont.boldSystemFontOfSize(14)
      self.detailTextLabel.font = UIFont.systemFontOfSize(12)
    end

    self
  end
 
  def fillWithSignature(signature, inTableView:tableView)
    self.textLabel.text = signatureString(signature)

    self.detailTextLabel.text = "Signed at #{Time.at(signature.created).strftime('%D %T')}"
    self.imageView.image = nil
  end

  def self.signatureString(signature)
    "#{signature.name} in ZIP code #{signature.zip}"
  end

  def signatureString(signature)
    self.class.signatureString(signature)
  end

  def self.heightForSignature(signature, width)
    constrain = CGSize.new(width, 1000)

    size = signatureString(signature).sizeWithFont(UIFont.systemFontOfSize(14), constrainedToSize:constrain)
    [57, size.height + 8].max
  end
end