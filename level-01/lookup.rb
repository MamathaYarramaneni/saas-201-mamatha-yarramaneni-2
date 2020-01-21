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
  dns_raw.each { |dns_value| split_input_array.push(dns_value.split(",").map(&:strip)) }
  hash = { "A" => {}, "CNAME" => {} }
  split_input_array.each do |dns_value|
    cname_var = dns_value[0]
    domain_var = dns_value[1]
    ip_address_or_alias = dns_value[2]

    if cname_var == "A"
      hash["A"][domain_var] = ip_address_or_alias
    else
      hash["CNAME"][domain_var] = ip_address_or_alias
    end
  end
  return hash
end

def resolve(dns_records, lookup_chain, domain)
  ip_address = dns_records["A"][domain]
  cname_alias = dns_records["CNAME"][domain]
  if ip_address
    lookup_chain.push(ip_address)
  elsif cname_alias
    lookup_chain.push(cname_alias)
    resolve(dns_records, lookup_chain, cname_alias)
  end
  if lookup_chain.length == 1
    lookup_chain = []
    lookup_chain.push("Error: record not found for #{domain}")
  end
  return lookup_chain
end

dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")