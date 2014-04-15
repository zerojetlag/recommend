require 'open-uri'
namespace :v1 do
  desc 'collect data'
  task :test => :environment do
  
    doc = Nokogiri::HTML(toUtf8(open('http://202.116.197.26/loanhistory.aspx?uid=20101003713').read))
    ####
    # Search for nodes by css
    doc.css('td').each do |link|
      puts link.content
    end
  end

  def toUtf8(_string)
    cd = CharDet.detect(_string)      #用于检测编码格式  在gem rchardet9里
    if cd.confidence > 0.6
      _string.force_encoding(cd.encoding)
    end
    _string.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
    return _string
  end
end