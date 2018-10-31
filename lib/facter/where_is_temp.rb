require 'tmpdir'

Facter.add(:where_is_temp) do
  setcode {
    (ENV['TEMP'] || Dir.tmpdir)
  }
end
