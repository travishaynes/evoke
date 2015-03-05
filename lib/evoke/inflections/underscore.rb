module Evoke::Inflections::Underscore
  def underscore
    dup.tap {|s|
      s.gsub!(/::/, '/')
      s.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      s.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      s.tr!("-", "_")
      s.downcase!
    }
  end

  def underscore!
    replace(underscore)
  end
end
