# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

r1 = Role.create({name: "User", description: "Can read items"})
r2 = Role.create({name: "Stylist", description: "Can read and create items. Cannot update and destroy own items"})
r3 = Role.create({name: "Manager", description: "Can read and create items. Cannot update and destroy own items"})
r4 = Role.create({name: "Admin", description: "Can perform any CRUD operation on any resource"})

u1 = User.create({email: "user@zuplr.com", password: "password", password_confirmation: "password", role_id: r1.id})
u2 = User.create({email: "stylist@zuplr.com", password: "password", password_confirmation: "password", role_id: r2.id})
u3 = User.create({email: "manager@zuplr.com", password: "password", password_confirmation: "password", role_id: r3.id})
u4 = User.create({email: "admin@zuplr.com", password: "password", password_confirmation: "password", role_id: r4.id})
u4 = User.create({email: "kjvenky@gmail.com", password: "password", password_confirmation: "password", role_id: r4.id})

up1 = Userprofile.create({user_id: u1.id, name: 'Sally'})
up2 = Userprofile.create({user_id: u2.id, name: 'Sue'})
up3 = Userprofile.create({user_id: u3.id, name: 'kev'})
up4 = Userprofile.create({user_id: u4.id, name: 'jack'})

u1.userprofile_id = up1.id
u1.save
u2.userprofile_id = up2.id
u2.save
u3.userprofile_id = up3.id
u3.save
u4.userprofile_id = up4.id
u4.save

Order.create!({user_id: u2.id, status: 'REQUESTED'})
Order.create!({user_id: u2.id, status: 'REQUESTED'})
Order.create!({user_id: u2.id, status: 'REQUESTED'})
Order.create!({user_id: u2.id, status: 'REQUESTED'})
Order.create!({user_id: u1.id, status: 'DELIVERED'})

City.create!(name: "Banglore", code: "BAN")
City.create!(name: "Hyderabad", code: "HYD")
City.create!(name: "Gurgaon", code: "GGN")
City.create!(name: "Pune", code: "PUN")
City.create!(name: "Delhi", code: "DEL")

Item.create({name: 'Item 1'})
Item.create({name: 'Item 2'})
Item.create({name: 'Item 3'})
Item.create({name: 'Item 4'})
