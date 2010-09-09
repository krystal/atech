## Extensions the standard String ruby class to provide additional functionality.
## Enable this in your application using:
##
##    require 'atech/extensions/string'

require 'digest'

class String
  
  class << self
    ## Returns a psuedo-random UUID which sepearated by hyphens in standard UUID
    ## format. It's worth noting this doesn't actually follow the specification
    ## for Version 4 UUIDs.
    def generate_token(options = {})
      values = [rand(0x0010000), rand(0x0010000), rand(0x0010000), rand(0x0010000), rand(0x0010000), rand(0x1000000), rand(0x1000000)]
      "%04x%04x-%04x-%04x-%04x-%06x%06x" % values
    end
  
    ## Returns a random string of the size specified. This can be used for salts
    ## or generated passwords. The generated string will only include lower case
    ## characters and numbers 0 though 9.
    def random(size = 25)
      array = ('a'..'z').to_a + (0..9).to_a
      (0...size).map{ array[rand(array.size)] }.join
    end
  end
  
  ## Returns the hex-encoded SHA1 hash value of the current string. Optionally, pass
  ## a value to limit the length of the returned SHA.
  def to_sha1(length = 40)
    Digest::SHA1.hexdigest(self)[0,length]
  end
  
  ## Returns the hex-encoded MD5 hash value of the current string. Optionally, pass
  ## a value to limit the length of the returned SHA.
  def to_md5(length = 32)
    Digest::MD5.hexdigest(self)[0,length]
  end
  
  ## Returns the first character of a string.
  def first_character
    case self[0]
    when 194..223
      return self[0,2]
    when 224..239
      return self[0,3]
    when 240..244
      return self[0,4]
    else
      return self[0,1]
    end
  end
  
end
