require 'tmpdir'

Facter.add(:where_is_temp) do
  setcode do
    (ENV['TEMP'] || Dir.tmpdir)
  end
end
