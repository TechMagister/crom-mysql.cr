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

  it "should create the object" do
    tm = User.new(name: "Toto", age: 15)
    user = users.insert(tm)
    user.should_not be_nil
    if u = user
      u.name.should eq("Toto")
      u.id.should_not be_nil
      u.age.should eq(15)
    end
  end

  it "should delete an object" do
    tm = User.new(name: "Toto", age: 15)
    user = users.insert(tm)
    users.delete user.not_nil!
    users.fetch(user.not_nil!.id).should be_nil
  end
end
