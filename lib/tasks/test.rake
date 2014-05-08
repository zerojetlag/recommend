require 'open-uri'
namespace :v1 do
  desc 'collect data'
  task :test => :environment do

    students = [20101003500]
    20.times do
      students << students.last + 1
    end
    students.each do |id|
      begin
        doc = Nokogiri::HTML(toUtf8(open("http://202.116.197.26/loanhistory.aspx?uid=#{id}").read))
      rescue Exception => e
        next
      end
      user = User.create({name: doc.css('#Label1').first.content, student_number: id, count: doc.css('#Label2').first.content})

      books = doc.css('#GridView1>tr')
      books.delete(books.first)
      books.each do |book|
        values = book.css('td')
          options = {
                     book_number: values[1].content,
                     name: values[2].content,
                     author: values[3].content,
                     publisher: values[4].content,
                     born_year: values[5].content,
                     isbn: values[6].content,
                     shelf: values[7].content,
                     first_category: values[8].content,
                     second_category: values[9].content
                   }
        b = Book.where(isbn: values[6].content).first
        if b.present?
          user.books << b
        else
          user.books << Book.create(options)
        end
        user.save
      end
      puts 'number: ' + id.to_s + ' done...'
      sleep 1.5
    end
  end

  desc "Task description"
  task :users => :environment do
    doc = Nokogiri::HTML(toUtf8(open("http://books.nirvawolf.com/UserInfo").read))
    users = doc.to_s.scan(/\d\d\d\d\d\d\d\d\d\d\d/)

    users.each do |user|
      begin
        doc = Nokogiri::HTML(toUtf8(open("http://books.nirvawolf.com/UserBooks?userid=#{user}").read))
      rescue Timeout::Error
        next
      end
      records = doc.to_s.scan(/\{[^\{\}]+\}/)
      records.each do |record|
        next if record.index(/bookName\"\:/).blank?
        tmp = record[record.index(/bookName\"\:/)..record.length]
        name = tmp[11..tmp.length-3].strip
        url = Url.new(name: name)
        puts name + '  id: ' + user
        if url.save
          puts "#{name}  save!"
        end
      end
    end
    #doc = Nokogiri::HTML(toUtf8(open("http://books.nirvawolf.com/UserBooks?userid=#{users[0]}").read))
    #binding.pry
  end

  desc "Task description"
  task :douban => :environment do
    urls = Url.where('url is null or image is null')
    #binding.pry
    urls.each do |url|
      json = JSON::parse(toUtf8(open("http://api.douban.com/v2/book/search?apikey=09573d68b5b5152d1c05b83a211f3f87&q=#{URI::encode(url.name)}").read))
      next if json['books'].blank?
      url.url=json['books'][0]['alt'] 
      url.image=json['books'][0]['images']['medium']
      url.save
      
      puts url.name
      puts url.image
      puts url.url

      sleep(2)
    end
  end

  desc "Task description"
  task :export_url => :environment do
    file = File.new("url.txt","w")
    start = 1
    file.puts "{'books':["
    Url.all.each do |u|
      if start == 1
        start = 0
      else
        file.puts ","
      end
      file.puts "{"
      file.puts "'name':'#{u.name}',"
      file.puts "'url':'#{u.url}',"
      file.puts "'image':'#{u.image}'"
      file.puts "}"
    end
    file.puts "]}"

    file.close
  end

  def toUtf8(_string)
    cd = CharDet.detect(_string)      #用于检测编码格式  在gem rchardet9里
    if cd.confidence > 0.6
      _string.force_encoding(cd.encoding)
    end
    _string.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
    return _string
  end

  desc "Task description"
  task :tree => :environment do
    labels = ["hunger", "color"]
    training = [
            [8, "red", "angry"],
            [6, "red", "angry"],
            [7, "red", "angry"],
            [7, "blue", "not angry"],
            [2, "red", "not angry"],
            [3, "blue", "not angry"],
            [2, "blue", "not angry"],
            [1, "red", "not angry"]
    ]

    dec_tree = DecisionTree::ID3Tree.new(labels, training, "not angry", color: :discrete, hunger: :continuous)
    dec_tree.train
    test = [7, "red"]
    decision = dec_tree.predict(test)
    puts "Predicted: #{decision} ... True decision: #{test.last}";
    dec_tree.graph("test")
  end

  desc "Task description"
  task :tree1 => :environment do
    #attributes = ['author', 'year', 'publisher']
    attributes = ['author', 'year', 'publisher', 'ss']
    training = Book.limit(1000).map{|b| [b.author, b.born_year, b.publisher, b.second_category, b.shelf[0]]}

    # Instantiate the tree, and train it based on the data (set default to '1')
    dec_tree = DecisionTree::ID3Tree.new(attributes, training, 'H', :discrete)
    dec_tree.train

   # book = Book.find(11000)
    count = 0
    SIZE = 10000
    Book.last(SIZE).each do |book|
      #test = [book.author, book.born_year, book.publisher, book.shelf[0]]
      test = [book.author, book.born_year, book.publisher, book.second_category, book.shelf[0]]
      decision = dec_tree.predict(test)
      puts "Predicted: #{decision} ... True decision: #{test.last}";
      if decision == test.last
        count = count + 1
      end
    end
    puts "#{(count.to_f / SIZE * 100).to_i}%"
    puts count
    
    # Graph the tree, save to 'discrete.png'
    dec_tree.graph("discrete")
  end
end