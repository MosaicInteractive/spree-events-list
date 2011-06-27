class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.string :title
      t.text :venue
      t.string :sponsor
      t.string :further_information
      t.text :summary
      t.text :full_description
      t.integer :is_active, :default => 0
      t.datetime :published_at
      t.boolean :visible
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
    add_index :events, :published_at, :name => 'events_published_at_ix'
    add_index :events, [:is_active, :published_at], :name => 'events_is_active_published_at_ix'
  end

  def self.down
    drop_table :events
  end
end
