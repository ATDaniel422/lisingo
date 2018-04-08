class Job < ActiveRecord::Migration[5.1]
  def change
  	create_table :jobs do |t|
  		t.string	:state
  		t.text		:text_to_process
  		t.string	:bucket_url
  		t.belongs_to	:user

  		t.timestamps null: false
  	end
  end
end
