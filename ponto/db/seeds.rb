User.find_or_create_by(email: 'test@example.com') { |u| u.password = 'secret.123' }
