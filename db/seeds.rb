# encoding: utf-8

# Аккаунт администатора
admin_account = User.new({
  login: 'rubytester',
  password: 'rubytester',
  permissions: User::PERMISSIONS,
  fullname: 'Администратор системы'
})
admin_account.save