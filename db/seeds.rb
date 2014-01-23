# Аккаунт администатора
admin_account = User.new({
  login: 'rubytester',
  password: 'rubytester',
  permissions: User::PERMISSIONS
})
admin_account.save