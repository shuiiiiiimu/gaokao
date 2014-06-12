class CreateInfo < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :title
      t.string :source
      t.text :body

      t.timestamps
    end
  end
end
