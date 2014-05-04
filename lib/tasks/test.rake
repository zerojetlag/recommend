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
      sleep 2
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

  desc "Task description"
  task :tree => :environment do
    attributes = ['Age', 'Education', 'Income', 'Marital Status']
    training = [
      ['36-55', 'Masters', 'High', 'Single', 1],
      ['18-35', 'High School', 'Low', 'Single', 0],
      ['< 18', 'High School', 'Low', 'Married', 1]
      # ... more training examples
    ]

    # Instantiate the tree, and train it based on the data (set default to '1')
    dec_tree = DecisionTree::ID3Tree.new(attributes, training, 1, :discrete)
    dec_tree.train

    test = ['< 18', 'High School', 'Low', 'Single', 0]

    decision = dec_tree.predict(test)
    puts "Predicted: #{decision} ... True decision: #{test.last}";

    # Graph the tree, save to 'discrete.png'
    dec_tree.graph("zaqqaz")
  end

  desc "Task description"
  task :tree1 => :environment do
    attributes = ['code1', 'code2', 'category']
    training = Book.limit(5000).map{|b| [b.shelf.split('/')[0], b.shelf.split('/')[1], b.second_category]}

    # Instantiate the tree, and train it based on the data (set default to '1')
    dec_tree = DecisionTree::ID3Tree.new(attributes, training, 1, :discrete)
    dec_tree.train

   # book = Book.find(11000)
    
    Book.last(50).each do |book|
      test = [book.shelf.split('/')[0], book.shelf.split('/')[1], book.second_category]
      decision = dec_tree.predict(test)
      puts "Predicted: #{decision} ... True decision: #{test.last}";
    end
    
    # Graph the tree, save to 'discrete.png'
    dec_tree.graph("discrete")
  end
end