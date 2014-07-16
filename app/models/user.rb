class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :roles
  has_many :my_courses
  has_and_belongs_to_many :playlists
  has_one :budget
  belongs_to :account
  has_many :discussions
  has_one :profile 

  # returns the role with the highest level of access
  def best_role
    current_role = :user
    # not the best implementation, but okay for now assuming that roles table does not have explicit user roles
    roles.each { |r|
      if r.name == 'SA'
	       current_role = :SA
      elsif r.name == 'Admin' && current_role != :SA
	       current_role = :admin
     end
    }
    current_role
  end

end
