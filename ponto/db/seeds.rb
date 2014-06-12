department = Department.find_or_create_by(name: 'Administrativo')
employee = Employee.find_or_create_by(name: 'Administrador') { |e|
  e.department = department
}
user = User.find_or_create_by(email: 'admin@example.com') { |u|
  u.password = u.password_confirmation = 'secret.123'
  u.employee = employee
  u.role = 'admin'
}
