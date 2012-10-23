class AdminUser < User
  authenticates_with_sorcery!

  def isAdmin?
    return true
  end

end
