(function() {
  'use strict';

  angular
    .module('app.home')
    .controller('Home', Home);

  Home.$inject = ['$q', 'dataservice', 'logger'];

  function Home($q, dataservice, logger) {

    var vm = this;

    vm.backdrop_url = '';
    vm.title = '';
    vm.release_year = '';
    vm.imdb_id = '';
    vm.show = false;

    activate();

    function activate() {
      // var promises = [getRandomMovie()];
      // return $q.all(promises).then(function() {
      // });

      $q.when(getRandomMovie()).then(function(){
        $q.when(preloadBackdrop()).then(function(){
          vm.show = true;
        });
      });
    }

    function getRandomMovie() {
      return dataservice.getRandomMovie().then(function(data) {
          vm.backdrop_url = data.backdrop_url;
          vm.title = data.title;
          vm.release_year = data.release_year;
          vm.imdb_id = data.imdb_id;
          return data;
      });
    }

    function preloadBackdrop(){
      var defer = $q.defer(),
          $img = angular.element(new Image())

      $img.bind('load', function(){
        defer.resolve($img);
      });

      $img.attr('src', vm.backdrop_url);

      return defer.promise;
    }
  }
})();
