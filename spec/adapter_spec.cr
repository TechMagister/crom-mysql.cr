require "./spec_helper"

class User
  CROM.mapping(:mysql, {
    id:   {type: Int64, nilable: true},
    name: String,
    age:  Int32,
  })
end

class Users < CROM::MySQL::Repository(User)
end

crom = CROM.container("mysql://root@localhost/crom_spec")

users = Users.new crom

describe CROM::MySQL::Gateway do
  it "should create mapping" do
    tm = User.new(name: "Toto", age: 10)
    tm.name.should eq("Toto")
    tm.age.should eq(10)
  end

  it "should create an object" do
    user = User.new(name: "Toto", age: 15)
    users.insert(user)

    user.id.should_not be_nil
  end

  it "should update an object" do
    user = User.new(name: "Toto", age: 15)
    users.insert(user)
    user.name = "Toto2"
    users.update user

    updated_user = users[user.id]
    updated_user.should_not be_nil

    if uu = updated_user
      uu.name.should eq("Toto2")
      uu.id.should eq(user.id)
      uu.age.should eq(user.age)
    end
  end

  it "should delete an object" do
    user = User.new(name: "Toto", age: 15)
    users.insert(user)
    old_id = user.id
    users.delete user
    user.id.should be_nil
    users[old_id].should be_nil
  end
end
