require "./spec_helper"

# CREATE TABLE `author` (
#   `id` bigint(20) NOT NULL AUTO_INCREMENT,
#   `name` varchar(255) DEFAULT NULL,
#   PRIMARY KEY (`id`)
# )
class Author
  CROM.mapping(:mysql, {
    id:   {type: Int64, nilable: true},
    name: String
  })
end

# CREATE TABLE `book` (
#   `id` bigint(20) NOT NULL AUTO_INCREMENT,
#   `name` varchar(255) DEFAULT NULL,
#   `author_id` bigint(20) NOT NULL,
#   PRIMARY KEY (`id`)
# )
class Book
  CROM.mapping(:mysql, {
    id:   {type: Int64, nilable: true},
    name: String,
    author:  {type: Author, key: "author_id", converter: Authors},
  })
end

class Books < CROM::MySQL::Repository(Book)

  def do_insert(model : Book)
    Authors[:authors].not_nil!.insert(model.author)
    super(model)
  end

  def do_update(model : Book)
    Authors[:authors].not_nil!.update(model.author)
    super(model)
  end

  def self.[](name)
    if repo = CROM.repository(name)
      repo.as(self)
    end
  end
end


class Authors < CROM::MySQL::Repository(Author)

  def self.[](name)
    if repo = CROM.repository(name)
      repo.as(self)
    end
  end

  def self.from_rs(rs)
    if repo = self[:authors]
      id = rs.read(Int64)
      repo[id]
    end
  end

end


crom = CROM.container(DB_URI)
CROM.register_repository :books, Books.new crom 
CROM.register_repository :authors, Authors.new crom


describe CROM::MySQL do

  it "should save the attached object" do

    book = Book.new "My Book", Author.new("Anonymous")
    Books[:books].not_nil!.insert(book)

    book.author.id.should_not be_nil
    book.id.should_not be_nil

  end

  it "should get the object with the attached one" do
    book = Book.new "My Book 2", Author.new("Anonymous 2")
    Books[:books].not_nil!.insert(book)

    id = book.id

    if books_repo = Books[:books]
      book2 = books_repo[id]

      book2.should_not be_nil
      if book = book2
        book.name.should eq("My Book 2")
        book.author.name.should eq("Anonymous 2")
      end

    end

  end

  it "should update the attached object" do
    book = Book.new "My Book 3", Author.new("Anonymous 3")
    Books[:books].not_nil!.insert(book)

    book.author.name = "Real Anonymous 3"

    author_id = book.author.id

    Books[:books].not_nil!.update(book)

    author = Authors[:authors].not_nil![author_id]
    author.should_not be_nil

    if a = author
      a.name.should eq("Real Anonymous 3")
    end

  end

end