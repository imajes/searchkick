require "bundler/setup"
Bundler.require(:default)
require "active_record"
require "benchmark/ips"

ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "/tmp/searchkick"

class Product < ActiveRecord::Base
  searchkick batch_size: 1000

  def search_data
    {
      name: name,
      color: color,
      store_id: store_id
    }
  end
end

# total_docs = 1000000

# ActiveRecord::Migration.create_table :products, force: :cascade do |t|
#   t.string :name
#   t.string :color
#   t.integer :store_id
# end

# Product.import ["name", "color", "store_id"], total_docs.times.map { |i| ["Product #{i}", ["red", "blue"].sample, rand(10)] }

# puts "Imported"

# Product.reindex

Benchmark.ips do |x|
  x.report { Product.search("product", fields: [:name], where: {color: "red", store_id: 5}, load: false) }
end