require "date"

class Todo
  def initialize(text, due_date, completed)
    @text = text
    @due_date = due_date
    @completed = completed
  end

  def overdue?
    Date.today > @due_date
  end

  def due_today?
    Date.today == @due_date
  end

  def due_later?
    Date.today < @due_date
  end

  def text
    @text
  end

  def due_date
    @due_date
  end

  def completed
    @completed
  end
end

class TodosList
  def initialize(todos)
    @todos = todos
  end

  def overdue
    todo_objects = TodosList.new(@todos.filter { |todo| todo.overdue? })
    display_todos(todo_objects.todos_values)
  end

  def due_today
    todo_objects = TodosList.new(@todos.filter { |todo| todo.due_today? })
    display_today_todos(todo_objects.todos_values)
  end

  def due_later
    todo_objects = TodosList.new(@todos.filter { |todo| todo.due_later? })
    display_todos(todo_objects.todos_values)
  end

  def todos_values
    @todos
  end

  def display_todos(todo)
    display_string = ""
    todo.each { |each_todo| display_string.concat("[ ] #{(each_todo.text)} #{(each_todo.due_date)} \n") }
    display_string
  end

  def display_today_todos(todo)
    display_string = ""
    todo.each { |each_todo|
      if each_todo == todo[0]
        display_string.concat("[X] #{(each_todo.text)} \n")
      else
        display_string.concat("[ ] #{(each_todo.text)} \n")
      end
    }
    display_string
  end

  def add(todo)
    @todos.push(todo)
  end
end

date = Date.today
todos = [
  { text: "Submit assignment", due_date: date - 1, completed: false },
  { text: "Pay rent", due_date: date, completed: true },
  { text: "File taxes", due_date: date + 1, completed: false },
  { text: "Call Acme Corp.", due_date: date + 1, completed: false },
]

todos = todos.map { |todo|
  Todo.new(todo[:text], todo[:due_date], todo[:completed])
}

todos_list = TodosList.new(todos)

todos_list.add(Todo.new("Service vehicle", date, false))

puts "My Todo-list\n\n"

puts "Overdue\n"
puts todos_list.overdue.to_s
puts "\n\n"

puts "Due Today\n"
puts todos_list.due_today.to_s
puts "\n\n"

puts "Due Later\n"
puts todos_list.due_later.to_s
puts "\n\n"
