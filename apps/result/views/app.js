/**
 * Results App
 * This app shows the results of the voting
 * in real-time using web sockets.
 */
var app = angular.module('catsvsdogs', []);
var socket = io.connect();

// Background elements for the stats bars
var bg1 = document.getElementById('background-stats-1');
var bg2 = document.getElementById('background-stats-2');

// Controller for the stats view
app.controller('statsCtrl', function($scope){
  $scope.aPercent = 50;
  $scope.bPercent = 50;

  /**
   * Update scores in real-time
   * Listens for 'scores' events from the server
   * and updates the UI accordingly.
   */
  var updateScores = function(){
    socket.on('scores', function (json) {
       data = JSON.parse(json);
       var a = parseInt(data.a || 0);
       var b = parseInt(data.b || 0);

       var percentages = getPercentages(a, b);

       bg1.style.width = percentages.a + "%";
       bg2.style.width = percentages.b + "%";

       $scope.$apply(function () {
         $scope.aPercent = percentages.a;
         $scope.bPercent = percentages.b;
         $scope.total = a + b;
       });
    });
  };

  // Initialize the app
  var init = function(){
    document.body.style.opacity=1;
    updateScores();
  };
  socket.on('message',function(data){
    init();
  });
});

/**
 * calculate percentages for two values 
 * @param {*} a 
 * @param {*} b 
 * @returns {a: int, b: int} percentages
 */
function getPercentages(a, b) {
  var result = {};

  if (a + b > 0) {
    result.a = Math.round(a / (a + b) * 100);
    result.b = 100 - result.a;
  } else {
    result.a = result.b = 50;
  }

  return result;
}