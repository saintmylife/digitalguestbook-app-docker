// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// = require rails-ujs
// = require jquery
// = require bootstrap
// = require moment
// = require bootstrap-datetimepicker
// = require moment/id.js
// = require toastr
// = require select2-full
// = require toastr
// require_tree dihapus karena crash
// = require html5-qrcode.min
// = require jquery.longpress
// = require html5shiv.min
// = require respond.min

$(function() {
    $('#date-picker').datetimepicker({
        format: 'DD/MM/YYYY'
    });

    $( ".select2" ).select2({
        theme: "bootstrap"
    });
});

toastr.options = {
    "closeButton": false,
    "debug": false,
    "positionClass": "toast-bottom-right",
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  }