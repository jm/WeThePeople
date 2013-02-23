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
    self.textLabel.text = signature_string(signature)

    self.detailTextLabel.text = "Signed at #{Time.at(signature.created).strftime('%D %T')}"
    self.imageView.image = nil
  end

  def self.signature_string(signature)
    "#{signature.name} in ZIP code #{signature.zip}"
  end

  def signature_string(signature)
    self.class.signature_string(signature)
  end

  def self.heightForSignature(signature, width)
    constrain = CGSize.new(width, 1000)

    size = signature_string(signature).sizeWithFont(UIFont.systemFontOfSize(MessageFontSize), constrainedToSize:constrain)
    [57, size.height + 8].max
  end
end