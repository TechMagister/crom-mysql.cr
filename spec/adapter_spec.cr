require "./spec_helper"

class User
  CROM.mapping(:mysql, {
    id:   {type: Int64, nilable: true},
    name: String,
    age:  Int32,
  })
end

class Users < CROM::Repository(User)
end

crom = CROM.container("mysql://root@localhost/crom_spec")

users = Users.new crom

describe CROM::MySQL::Adapter do
  it "should create mapping" do
    tm = User.new(name: "Toto", age: 10)
    tm.name.should eq("Toto")
    tm.age.should eq(10)
  end

  it "should create user" do
    tm = User.new(name: "Toto", age: 15)
    user = users.insert(tm)
    user.should_not be_nil
    if u = user
      u.name.should eq("Toto")
      u.id.should_not be_nil
      u.age.should eq(15)
    end
  end
end
