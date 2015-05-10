// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery

//= require angular
//= require angular-animate
//= require angular-route
//= require angular-sanitize
//= require toastr
//= require moment

//= require app/app.module

//= require app/blocks/exception/exception.module
//= require app/blocks/exception/exception-handler.provider
//= require app/blocks/exception/exception
//= require app/blocks/logger/logger.module
//= require app/blocks/logger/logger
//= require app/blocks/router/router.module
//= require app/blocks/router/routehelper

//= require app/core/core.module
//= require app/core/constants
//= require app/core/config
//= require app/core/dataservice

//= require app/widgets/widgets.module
//= require app/widgets/search.directive

//= require app/home/home.module
//= require app/home/config.route
//= require app/home/home