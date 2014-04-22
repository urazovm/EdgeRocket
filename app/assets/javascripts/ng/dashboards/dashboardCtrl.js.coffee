EdgeRocket = angular.module('EdgeRocket', ['angularCharts'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@DashboardCtrl = ($scope, $http) ->

  # CHARTS - activity

  $scope.activityChartData = {
    series: ['Completed', 'In Progress'],
    data : [{
      x : "Jan",
      y: [3, 5],
      tooltip:"this is tooltip"
    },
    {
      x : "Feb",
      y: [4, 10]
    },
    {
      x : "Mar",
      y: [2, 11]
    },
    {
      x : "Apr",
      y: [2, 1]
    }]     
  }

  $scope.activityChartType = 'bar'

  $scope.activityConfig = {
    labels: false,
    title : "",
    legend : {
      display:true,
      position:'left'
    }
  }

  # CHARTS - topics

  $scope.topicsChartData = {
    series: ['Completed', 'In Progress'],
    data : [{
      x : "Marketing",
      y: [3, 2],
      tooltip:"this is tooltip"
    },
    {
      x : "Coding",
      y: [4, 10]
    },
    {
      x : "Business",
      y: [4, 3]
    },
    {
      x : "Design",
      y: [1, 5]
    },
    {
      x : "Finance",
      y: [2, 1]
    },
    {
      x : "Technical",
      y: [2, 3]
    },
    {
      x : "Other",
      y: [7, 11]
    }] 

  }

  $scope.topicsChartType = 'bar'

  $scope.topicsConfig = {
    labels: false,
    title : "",
    legend : {
      display:true,
      position:'left'
    }
  }

  # CHARTS - dept

  $scope.deptChartData = {
    series: ['Completed', 'In Progress'],
    data : [{
      x : "Marketing",
      y: [3, 5],
      tooltip:"this is tooltip"
    },
    {
      x : "Engineering",
      y: [4, 10]
    },
    {
      x : "Support",
      y: [1, 4]
    },
    {
      x : "Sales",
      y: [3, 12]
    },
    {
      x : "Other",
      y: [2, 1]
    }]     
  }

  $scope.deptChartType = 'bar'

  $scope.deptConfig = {
    labels: false,
    title : "",
    legend : {
      display:true,
      position:'left'
    }
  }

  # CHARTS - users

  $scope.usersChartData = {
    series: ['Number of Users'],
    data : [{
      x : "0",
      y: [4],
      tooltip:"this is tooltip"
    },
    {
      x : "1-3",
      y: [2]
    },
    {
      x : "4-6",
      y: [2]
    },
    {
      x : "7+",
      y: [1]
    }]     
  }

  $scope.usersChartType = 'pie'

  $scope.usersConfig = {
    labels: false,
    title : "",
    legend : {
      display:true,
      position:'left'
    }
  }

@DashboardCtrl.$inject = ['$scope', '$http']