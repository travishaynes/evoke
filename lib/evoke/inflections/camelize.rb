module Evoke::Inflections::Camelize
  def camelize
    dup.tap {|s|
      s.capitalize!
      s.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
      s.gsub!("/", "::")
    }
  end

  def camelize!
    replace(camelize)
  end
end
