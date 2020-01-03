require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "lectures.sqlite3"
)

ActiveRecord::Migration.create_table :canceled_lectures do |t|
  t.text :day
  t.text :hour
  t.text :name
  t.text :teacher
  t.text :grade
  t.text :department
  t.text :extra_day
  t.boolean :reminded, default: false
  t.timestamps null: false
end

ActiveRecord::Migration.create_table :extra_lectures do |t|
  t.text :day
  t.text :hour
  t.text :name
  t.text :teacher
  t.text :grade
  t.text :department
  t.text :room
  t.boolean :reminded, default: false
  t.timestamps null: false
end
