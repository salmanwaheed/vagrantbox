require_relative 'base.rb'

if File.exists?($hosts_file)
  system "rm -rf #{$hosts_file}"
  puts "Old hosts file has removed!"
end

if !File.exists?($hosts_file)
  $machines.each do |m|
    File.open($hosts_file, 'a') { |file| file.write("#{m['private_ip']} #{m['user']}\n") }
  end
  puts "New hosts file has created!"
end

$machines.each do |m|
  system "vagrant upload #{$hosts_file} /home/#{m['user']}/hosts.txt #{m['user']} 2>&1 >/dev/null"
  system "vagrant ssh #{m['user']} -- -t 'cat /home/#{m['user']}/hosts.txt | sudo tee -a /etc/hosts 2>&1 >/dev/null && rm -rf #{$hosts_file}' 2>/dev/null"
  puts "#{m['user']} has completed successfully!"
end
