class AdminUser < User
  authenticates_with_sorcery!

  def is_admin?
    true
  end

  def as_user
    u = User.new(self.attributes, :without_protection => true)
    u.define_singleton_method(:persisted?) do true end
    u
  end

end
