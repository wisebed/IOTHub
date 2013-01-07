class AdminUser < User
  authenticates_with_sorcery!

  def is_admin?
    true
  end

end
