class SignatureCell < CustomTableCell
  def fill(signature, inTableView:tableView)
    self.textLabel.text = SignatureCell.signatureString(signature)

    self.detailTextLabel.text = "Signed at #{Time.at(signature.created).strftime('%D %T')}"
    self.imageView.image = nil
  end

  def self.signatureString(signature)
    "#{signature.name} in ZIP code #{signature.zip}"
  end
end