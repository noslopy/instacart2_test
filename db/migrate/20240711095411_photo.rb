class Photo < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :caption
      t.timestamps
    end
  end
end
