# Аккаунт администатора
admin_account = User.new({
  login: 'rubytester',
  password: 'rubytester',
  permissions: %w[ canAdmin canLogin ]
})
admin_account.save