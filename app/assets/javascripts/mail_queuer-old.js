// This script handles ClientKeywordMatch functionality at /mail_queues


function MailQueuer(){
  this.box = $('#mail_image_selection');
  this.mail_images = this.box.find('.mail_image');
  this.clients = this.box.find('.client');

  //--- End Constructor -----------------------------------------------

  //--- Classes -------------------------------------------------
  function MailImage(element){
    this.element = element;
    this.ids = $(this.element).data('client-ids').split(',');
    this.id = $(this.element).data('id');

    this.addClientIdToIds = function(client_id){
      var a = this.ids;
      a.push(client_id);
      this.element.data('client-ids', a.join(','));
    }
  }

  function Client(element){
    this.element = element;
    this.id = $(this.element).data('client-id');
  }

  this.activateMailImage = function(element){
    var mi = new MailImage(element);
    this.active_mail_image = mi;
    this.showAllClients();
    this.hideNonMatchingClients();
  }

  this.deactivateMailImage = function(){
    this.active_mail_image.element.css('top', '0').css('left', '0');
    this.active_mail_image = null;
    this.showAllClients();
  }

  this.activateClient = function(element){
    var c = new Client(element);
    this.active_client = c;
    c.element.addClass('active');
  }

  this.deactivateClient = function(){
    this.active_client.element.removeClass('active');
    this.active_client = null;
  }

  this.createClientKeywordMatch = function(element){
    var t = this;
    if(element[0] == this.active_client.element[0]){
      // If the element dropped on is the same as the activated element.
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
        complete: function(results){
          t.active_mail_image.addClientIdToIds(t.active_client.id);
          t.deactivateClient();
          t.deactivateMailImage();
        }
      });
    }
  }

  //--- Functions ------------------------------------------------
  this.initDragDrop = function(){
    var t = this;

    $.each(t.mail_images, function(i, mi){
      $(mi).draggable({
        start: function(e, ui){
          ui.helper.data('dropped', false);
          t.activateMailImage($(this));
        },
        stop: function(e, ui){
          if(!ui.helper.data('dropped')){
            t.deactivateMailImage();
          }
        },
        drag: function(e, ui){
        }
      });
    });


    $.each(t.clients, function(i, c){
      $(c).droppable({
        over: function(e, ui){
          t.activateClient($(this));
        },
        out: function(e, ui){
          t.deactivateClient();
        },
        drop: function(e, ui){
          ui.helper.data('dropped', true);
          t.createClientKeywordMatch($(e.target));
        }
      });
    });
  };

  this.showAllClients = function(){
    $.each(this.clients, function(i, mi){
      $(mi).show();
    });
  };

  this.hideNonMatchingClients = function(){
    // Hides Clients that do not match MailImage.
    var ids = this.active_mail_image.ids;

    // for(var i = 0; i < this.clients.length; i++){

      for(var i = 0; i < ids.length; i++){
        $('[data-client-id="' + ids[i] + '"]').hide();
      } // each id
    // } // each client
  }

  this.init = function(){
    // this.initDragDrop();
  }
}
