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
    arr1=[]
    dns_raw.each{|x|  arr1.push(x.split(",").map(&:strip))}
    hash={"A"=>{},"CNAME"=>{}}
    arr1.each do |x|
        if x[0]=="A"
            hash["A"][x[1]]= x[2]
        else
            hash["CNAME"][x[1]] = x[2]
        end
    end
    return hash
end

def resolve(dns_records, lookup_chain, domain)
    dns_records.each do |key, value|
        if key=="A"
            value.each do |k,v|
                if k==domain
                    lookup_chain.push(v.to_s)
                end
            end
        end
        if key=="CNAME"
            value.each do |k,v|
                if k==domain
                    lookup_chain.push(v.to_s)
                    resolve(dns_records, lookup_chain,v)
                end
            end
        end
    end
    if lookup_chain.length==1
        lookup_chain=[]
        lookup_chain.push("Error: record not found for #{domain}")
    end
    return lookup_chain

end

dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
