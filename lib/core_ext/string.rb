class String
  def ucfirst
    str = self.clone
    str[0] = str[0, 1].upcase
    str
  end

  def |(what)
    self.strip.blank? ? what : self
  end
end