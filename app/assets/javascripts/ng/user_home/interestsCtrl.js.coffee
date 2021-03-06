@InterestsCtrl = ($scope, $http, $modal, $sce, $window) ->

  $scope.selectCount = 0

  $scope.interests = []
  ### SAMPLE 
  { name : 'Communication Skills', img_url : '/assets/ic_forum_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'Data Science', img_url : '/assets/ic_storage_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'Effective Presentations', img_url : '/assets/ic_camera_roll_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'Finance', img_url : '/assets/ic_account_balance_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'Leadership & Management', img_url : '/assets/ic_people_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'Digital Marketing', img_url : '/assets/ic_play_shopping_bag_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'Operations', img_url : '/assets/ic_people_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'Project Management', img_url : '/assets/ic_people_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'Sales', img_url : '/assets/ic_people_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'Software Engineering', img_url : '/assets/ic_people_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'UX/UI & Design', img_url : '/assets/ic_people_grey600_48dp.png', num_items : 2, cb : false }
  { name : 'Web Development', img_url : '/assets/ic_people_grey600_48dp.png', num_items : 2, cb : false }
  ###

  loadSkills = ->
    $http.get('/surveys/skills.json').success( (data) ->
      $scope.interests = data.skills
      for skill in $scope.interests
        skill.cb = skill.preselected
        if skill.cb == true 
          $scope.selectCount += 1
      console.log('Successfully loaded skills')
    ).error( ->
      console.log('Error loading skills')
    )

  loadSkills()

  $scope.clickInterest = (interest) ->
    if interest.cb == true
      $scope.selectCount = if $scope.selectCount > 0 then $scope.selectCount-1 else $scope.selectCount=0
      interest.cb = false
    else
      $scope.selectCount = $scope.selectCount+1
      interest.cb = true

  $scope.done = ->
    data = { skills: [] }
    for skill in $scope.interests
      if skill.cb == true
        #console.log('skill ' + skill.id )
        data.skills.push( { id: skill.key_name } )
    # save right here
    # Create data object to POST and send a request
    $http.post('/users/preferences.json', data).success( (data) ->
      console.log('Successfully set preferences')
      $scope.surveySaved = true
      $window.location.href = "/user_home"
    ).error( ->
      console.error('Failed to set preferences')
      # even if there is an error, users can proceed and not get stuck on the screen
      # TODO consider error reporting to the user
      $window.location.href = "/user_home"
    )

@InterestsCtrl.$inject = ['$scope', '$http', '$modal', '$sce', '$window']
