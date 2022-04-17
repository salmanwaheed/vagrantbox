require 'yaml'

yaml_config_file = "#{Dir.pwd}/config.yml"

if !File.exists?(yaml_config_file)
  puts "The #{yaml_config_file} file is missing"
  abort
end

yaml_config = YAML.load_file(yaml_config_file)
$machines = yaml_config['machines']
project_name = yaml_config['project_name'] || 'deletify'

if !project_name || project_name.empty?
  puts "No project_name defined in #{yaml_config_file}"
  abort
end

if !$machines || $machines.empty?
  puts "No machines defined in #{yaml_config_file}"
  abort
end

$vagrantbox_conf_file = "#{Dir.pwd}/.vagrantbox.conf"
if !File.exists?($vagrantbox_conf_file)
  puts "The #{$vagrantbox_conf_file} file is missing"
  abort
end

$vagrantbox_conf_obj = {}
File.readlines($vagrantbox_conf_file).each do |line|
  item = line.split('=')
  if item.length() == 2
    $vagrantbox_conf_obj[item[0]] = "#{item[1]}".gsub("\n", '')
  end
end

$machines.each do |value|

  required_fields = ['user', 'pass', 'port', 'private_ip']
  required_fields.each do |item|
    if not value.include? item
      puts "'#{item}' is required. Please add it to 'config.yml' file"
      abort
    end

    if value[item].nil?
      puts "'#{item}' must have a 'value'. Please add it to 'config.yml' file"
      abort
    end
  end

  value['user']         = value['user']
  value['pass']         = value['pass']
  value['port']         = value['port']
  value['private_ip']   = value['private_ip']
  value['root_pass']    = value['root_pass']          || 'root'
  value['passwd_auth']  = value['passwd_auth']        || 'no'
  value['ram']          = value['ram']                || 1024
  value['cpus']         = value['cpus']               || 1
  value['disk_size']    = value['disk_size']          || '10GB'
  value['box']          = value['box']                || 'ubuntu/focal64'
end

$hosts_file = "#{Dir.pwd}/hosts"
