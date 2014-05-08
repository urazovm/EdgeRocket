class UserHomeController < ApplicationController
  before_filter :authenticate_user!

  # GET
  def index


    u = current_user

    # --- Company section
    @account = u.account

    # --- Playlists section
    @playlists = @account ? @account.playlists : nil

    @subscribed_playlists = Hash.new()

    if @playlists
      # find out if each playlist is subscribed by this user, and store that
      # inside a hash
      @playlists.each { |pl|
        if pl.subscribed?(u.id)
          @subscribed_playlists[pl.id] = true
        end
      }
    end

    #TODO make it async
    if !Rails.env.test? && request.format.symbol == :html
      Keen.publish(:ui_actions, {
        :user_email => u.email,
        :action => controller_path,
        :method => action_name,
        :request_format => request.format.symbol
      })
    end

    respond_to do |format|
      format.html
      format.json {
        # combine all aobject into one JSON result
        json_result = Hash.new()
        json_result['account'] = @account.as_json(methods: :options)
        json_result['playlists'] = @playlists
        json_result['subscribed_playlists'] = @subscribed_playlists
        json_result['sign_in_count'] = u.sign_in_count #ugly but works
        json_result['user_preferences'] = u.preferences #ugly but works
        render json: json_result.as_json
      }
    end
  end

  # POST
  # subscribe currently authenitcated user to the playlist
  # JSON: {"playlist_id":"1003"}
  def subscribe
    u = current_user
    pl = Playlist.find(params[:playlist_id])
    # TODO handle exceptions
    u.playlists << pl

    # subscribe for all courses in this playlists
    for product in pl.products
      MyCourses.subscribe(u.id, product.id, 'reg', 'Self')
    end

    result = { 'user_ud' => u.id, 'playlist_id' => params[:playlist_id] }

    respond_to do |format|
        format.json { render json: result.as_json }
    end

  end

  # DELETE :id
  # unsubscribe currently authenitcated user from the playlist
  # JSON: empty
  def unsubscribe
    u = current_user
    pl = Playlist.find(params[:id])

    # unsubscribe for all courses in this playlists
    for product in pl.products
      # TODO
      #MyCourses.unsubscribe(u.id, product.id)
    end

    # TODO handle exceptions
    u.playlists.delete(pl)
    result = { 'user_ud' => u.id, 'playlist_id' => pl.id }

    respond_to do |format|
        format.json { render json: result.as_json }
    end

  end

  # POST
  # create new set of user preferences
  # JSON: {anything}
  def create_preferences
    u = current_user.email
    #debugger
    u.preferences = params[:education].to_json # TODO make it real
    u.save

    result = { 'user_ud' => u.id }

    respond_to do |format|
        format.json { render json: result.as_json }
    end
  end

end
