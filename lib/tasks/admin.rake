namespace :admin do
  desc "Creates an AdminUser"
  task create: :environment do
    puts "You will be prompted to enter a name, email address and password for the new admin"

    puts "Enter an email address:"
    email = STDIN.gets

    system "stty -echo"
    puts "Enter a password:"
    password = STDIN.gets

    puts "Password confirmation:"
    password_confirmation = STDIN.gets
    system "stty echo"

    if password == password_confirmation
      unless email.strip!.blank? || password.strip!.blank?
        admin = AdminUser.create!(email: email, password: password, password_confirmation: password)

        puts "The admin was created successfully."
      end
    else
      STDERR.puts "Passwords do not match!"
    end
  end
end
