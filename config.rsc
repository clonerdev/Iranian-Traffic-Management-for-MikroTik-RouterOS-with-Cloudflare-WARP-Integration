# Definition of a function to retrieve and update the list of Iranian IP addresses
:local update_iran_ip_list do={
  :local github_url "https://raw.githubusercontent.com/arastu/iran_ip_ranges/master/iran_ip_range.txt"
  :local temp_file "iran_ip_range.txt"
  
  # Fetching the list of Iranian IP addresses from GitHub
  /tool fetch url=$github_url dst-path=$temp_file
  
  # Removing all previous records of Iranian IP addresses
  /ip firewall address-list remove [find list=Iran_IPs]
  
  # Creating new records for the list of Iranian IP addresses
  :foreach i in=[/file find where name=$temp_file] do={
    /ip firewall address-list add address=[/file get $i contents] list=Iran_IPs
  }
  
  # Removing the temporary file
  /file remove $temp_file
}

# Executing the function to update the list of Iranian IP addresses
$update_iran_ip_list

# Routing settings and other configurations

# Adding a button to the system tray menu to display the status of enabling or disabling Cloudflare WARP configuration
:if ([/interface warp-client get [find] disabled]) do={
    /system tray add name="Cloudflare WARP (Disabled) v1.0" image=5 menu=/menu find where name="Cloudflare WARP"
} else={
    /system tray add name="Cloudflare WARP (Enabled) v1.0" image=6 menu=/menu find where name="Cloudflare WARP"
}