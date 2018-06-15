class CreateAraskJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :arask_jobs do |t|
      t.string :job
      t.datetime :execute_at
      t.string :interval
    end
    add_index :arask_jobs, :execute_at
  end
end
