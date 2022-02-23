$(document).ready(function() {
  $("#Alamat").hide();
  $("#Kategori").hide();
  $("#wedding_search option[value=default]").attr('selected','selected');
  $("#wedding_search").on("change",function(event) {
    var value_selected = $(this).find(":selected").text();
    if(value_selected == "Alamat"){
      $("#Alamat").show();
      $("#check_alamat").prop('checked', true);
    }
    if(value_selected == "Kategori"){
      $("#Kategori").show();
      $("#check_kategori").prop('checked', true);
    }
  });
  $("#check_alamat").on("change",function(){
    if(this.checked == false){
      $("#Alamat").hide();
      $('#alamat_search').val('');
      $("#wedding_search option[value=default]").prop('selected',true);
    }
  });
  $("#check_kategori").on("change",function(){
    if(this.checked == false){
      $("#Kategori").hide();
      $('#kategori_search').val('');
      $("#wedding_search option[value=default]").prop('selected',true);
    }
  });
  $('#search_master_wedding').on('click',function(event){
    var val_alamat = $('#alamat_search').val(), val_name = $('#name_search').val(), val_kategori = $('#kategori_search').val();
    var data = '{'
      +'"data_search" :'+'{'
        +'"name" :'+'"'+val_name+'"'+','
        +'"alamat" :'+'"'+val_alamat+'"'+','
        +'"kategori" :'+'"'+val_kategori+'"'
      +'}'
    +'}'
    var all_data = '{'
      +'"data_search" :'+'{'
        +'"data" :'+'"all"'
      +'}'
    +'}'
    if(val_alamat == '' && val_name == '' && val_kategori == ''){
      $.get('/weddings/new',{ search: all_data  }).done(function(){
        $('#alamat_search').val('');
        $('#name_search').val('');
        $('#kategori_search').val('');
      });
    }else{
      $.get('/weddings/new',{ search: data }).done(function(){
        $('#alamat_search').val('');
        $('#name_search').val('');
        $('#kategori_search').val('');
      });
    }
  });

});
