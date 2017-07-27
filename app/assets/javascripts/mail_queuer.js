// This script handles ClientKeywordMatch functionality at /mail_queues
function MailQueuer(){
  // This is rather convoluted as a result of some chances in the project spec.
  // It involves a modal at mail_images/_client_select

  this.modal =  $('#client_select');
  this.modal_header = this.modal.find('.modal-header');
  this.client_table = this.modal.find('#client_table');
  this.client_rows = this.client_table.find('.client');

  this.box = $('#unmatched_images');
  this.select_client_links = $('.select_client_link');
  this.create_match_links = $('.create_match_link');

  //--- Classes -------------------------------------------------
  function MailImage(element){
    this.element = element;
    this.id = $(this.element).data('mail-image-id');
    this.image_url = $(this.element).data('image-url');
    this.client_ids = $(this.element).data('client-ids').split(',');
  }

  function Client(element){
    this.element = element;
    this.id = $(this.element).data('client-id');
  }

  this.activateMailImage = function(element){
    var mi = new MailImage(element);
    this.active_mail_image = mi;
  }

  this.deactivateMailImage = function(){
    this.active_mail_image = null;
  }

  this.activateClient = function(element){
    var c = new Client(element);
    this.active_client = c;
    // c.element.addClass('active');
  }

  this.deactivateClient = function(){
    this.active_client.element.removeClass('active');
    this.active_client = null;
  }

  this.createClientKeywordMatch = function(){
    var t = this;

    $.ajax({
      method: 'POST',
      url: '/client_keyword_matches',
      data: {
        client_keyword_match:{
          client_id: this.active_client.id,
          mail_image_id: this.active_mail_image.id,
          keyword: '**admin_action**'
        }
      },
      dataType: 'script',
      format: 'script',
      complete: function(results){
        t.modal.modal('hide');
        // var client_id = JSON.parse(results.responseText).client_id
        // t.hideClientSearch(client_id);
      }
    });
  }

  this.hideClientSearch = function(client_id){
    var t = this;
    t.modal.modal('hide');
    t.deactivateClient();
    t.deactivateMailImage();
  }

  this.showClientSearch = function(){
    var t = this;
    var header = this.modal_header;
    var banner = $('<img src="' + this.active_mail_image.image_url + '" width="100%" />');
    $('.image_for_client_select').html(banner);

    this.client_rows.each(function(i, row){
      $(row).show();
      var client_id = $(this).data('client-id');

      $.each(t.active_mail_image.client_ids, function(i, id){
        if(client_id === id){
          $(row).hide();
        }
      });
    });

    this.modal.modal('show');
  }

  this.init = function(){
    var t = this;

    this.select_client_links.each(function(i, mi){
      $(this).click(function(e){
        e.preventDefault();
        t.activateMailImage($(this).closest('.text_link').closest('.mail_image'));
        t.showClientSearch();
      });
    });

    this.create_match_links.each(function(i, link){
      $(this).click(function(e){
        e.preventDefault();
        t.activateClient($(this).closest('.client'));
        t.createClientKeywordMatch();
      });
    });
  }
}
