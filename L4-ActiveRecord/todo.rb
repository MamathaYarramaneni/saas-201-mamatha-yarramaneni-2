require "active_record"
require "date"
connect_db!

class Todo < ActiveRecord::Base
  def overdue?
    Date.today > due_date
  end

  def due_today?
    Date.today == due_date
  end

  def due_later?
    Date.today < due_date
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date

    if display_status
      return "#{id} #{display_status} #{todo_text} #{display_date}"
    else
      return nil
    end
  end

  def self.to_displayable_string
    all.map { |todo|
      todo.to_displayable_string
    }
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "\nOverdue\n"
    (all.where("due_date < ?", Date.today).map { |todo|
      puts todo.to_displayable_string
    })
    puts "\n\n"

    puts "Due Today\n"
    (all.where("due_date = ?", Date.today).map { |todo|
      puts todo.to_displayable_string
    })
    puts "\n\n"

    puts "Due Later\n"
    (all.where("due_date > ?", Date.today).map { |todo|
      puts todo.to_displayable_string
    })
    puts "\n\n"
  end

  def self.add_task(hash)
    dueindaysvar = hash[:due_in_days].to_i
    completedvar = (dueindaysvar > 0) ? false : true

    Todo.create!(todo_text: hash[:todo_text], due_date: Date.today + dueindaysvar, completed: completedvar)
  end

  def self.mark_as_complete!(todo_id)
    todo = Todo.find(todo_id)
    todo.completed = true
    todo.save
    todo
  end
end
