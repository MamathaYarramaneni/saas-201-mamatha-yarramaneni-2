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

  def idfind
    id
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date

    if display_status
      return "#{idfind} #{display_status} #{todo_text} #{display_date}"
    else
      return nil
    end
  end

  def self.to_displayable_string
    (all.map { |todo|
      if (todo.findid)
        puts todo.to_displayable_string
      else
        puts "no row found with id #{findid}"
      end
    })
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "\nOverdue\n"
    (all.map { |todo|
      if (todo.overdue?)
        puts todo.to_displayable_string
      end
    })
    puts "\n\n"

    puts "Due Today\n"
    (all.map { |todo|
      if (todo.due_today?)
        puts todo.to_displayable_string
      end
    })
    puts "\n\n"

    puts "Due Later\n"
    (all.map { |todo|
      if (todo.due_later?)
        puts todo.to_displayable_string
      end
    })
    puts "\n\n"
  end

  def self.add_task(hash)
    todotextvariable = hash[:todo_text]
    dueindaysvariable = hash[:due_in_days]
    completedvariable = (dueindaysvariable > 0) ? false : true

    Todo.create!(todo_text: todotextvariable.to_s, due_date: Date.today + dueindaysvariable.to_i, completed: completedvariable)
  end

  def self.mark_as_complete!(todo_id)
    idvariable = Todo.find(todo_id)
    idvariable.save
    idvariable
  end
end
