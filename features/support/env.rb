require 'simplecov'
SimpleCov.start # must be before other requires

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'gtfs_reader.rb')

class String
  def constantize
    return nil if strip.empty?

    strip.split( '::' ).inject( Object ) {|o,c| o.const_get c }
  end
end

def raise_an_exception(type)
  if type.nil? or type.strip.empty?
    raise_exception
  else
    raise_exception type.constantize
  end
end
