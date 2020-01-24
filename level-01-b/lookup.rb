def get_command_line_argument
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

domain = get_command_line_argument

dns_raw = File.readlines("zone.txt")

def parse_dns(dns_raw)
  split_input_array = []
  dns_raw.each { |line| split_input_array.push(line.split(",").map(&:strip)) }

  hash = {}
  split_input_array.each do |dns_value|
    cname_var = dns_value[0]
    domain_var = dns_value[1]
    ip_address_or_alias = dns_value[2]

    if cname_var == "A"
      hash1 = { domain_var => { :type => "", :ip_address => "" } }
      hash1[domain_var][:type] = cname_var
      hash1[domain_var][:ip_address] = ip_address_or_alias
      hash = hash1.merge(hash)
    else
      hash1 = { domain_var => { :type => "", :alias => "" } }
      hash1[domain_var][:type] = cname_var
      hash1[domain_var][:alias] = ip_address_or_alias
      hash = hash1.merge(hash)
    end
  end
  return hash
end

def resolve(dns_records, lookup_chain, domain)
  domain_check = dns_records[domain]
  if domain_check
    domain_type = dns_records[domain][:type]
    ip_address = dns_records[domain][:ip_address]
    cname_alias = dns_records[domain][:alias]
    if ip_address
      lookup_chain.push(ip_address)
    elsif cname_alias
      lookup_chain.push(cname_alias)
      resolve(dns_records, lookup_chain, cname_alias)
    end
  else
    lookup_chain = []
    lookup_chain.push("Error: record not found for #{domain}")
  end
  return lookup_chain
end

dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
