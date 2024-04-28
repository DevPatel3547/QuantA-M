current_time = Time.now

# create users (email, officer)
User.create(email: 'john.doe@tamu.edu', first_name: 'John', last_name: 'Doe', officer: true)
User.create(email: 'jane.doe@tamu.edu', first_name: 'Jane', last_name: 'Doe', officer: false)
