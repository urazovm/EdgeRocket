class Playlist < ActiveRecord::Base
  has_many :playlist_items
  has_many :products, through: :playlist_items
  has_and_belongs_to_many :users
  belongs_to :account

  def percent_complete
    # TODO do we need to sanitize SQL here?
    sql = "select avg(mc.percent_complete) percent_avg from playlist_items pp inner join my_courses mc on pp.product_id=mc.product_id where playlist_id=" + id.to_s
    pc = ActiveRecord::Base.connection.execute(sql)
    pc[0]['percent_avg']
  end

  # figure out if this playlist is sibscibed by a given user
  def subscribed?(user_id)
    subscribed = false
    if self.users
      for u in self.users
        if u.id == user_id
          subscribed = true
          break
        end
      end
    end
    subscribed
  end

  def self.all_for_company(company_id)
    self.where("account_id=?", company_id).order('title')
  end

  # clone a given playlist with all items that belong to it for the new account_id
  def self.clone_with_items(account_id, playlist_id)
    original_pl = Playlist.find(playlist_id)
    if !original_pl.nil?
      original_pl.account_id = account_id
      new_pl = original_pl.dup
      if new_pl.save
        original_pl.playlist_items.each { |pi|
          new_pi = pi.dup
          new_pl.playlist_items << new_pi
        }
      end
    end
  end

end
