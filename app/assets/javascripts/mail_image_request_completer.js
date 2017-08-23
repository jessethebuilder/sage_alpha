function MailImageRequestUpdater(mail_image_request){
  this.row = $(mail_image_request);
  this.request_id = this.row.data('mail-image-request-id');
  this.tracking_id_input = this.row.find('input[name="tracking_id"]');
  this.complete_checkbox = this.row.find('.complete_checkbox');
  this.completed_at_cell = this.row.find('.completed_at');

  this.isComplete = function(){
    return this.complete_checkbox.is(':checked');
  }

  this.update = function(element){
    var t = this;
    $.ajax({
      url: '/mail_image_requests/' + t.request_id,
      method: 'PATCH',
      data: {
        mail_image_request: {
          complete: t.isComplete(),
          tracking_id: t.tracking_id_input.val()
        },
      },
      dataType: 'json',
      format: 'json',
      complete: function(data){
        var json = JSON.parse(data.responseText);
        var completed_at = json.completed_at ? json.formatted_completed_at : '';
        var time = $('<span>' + completed_at + '</span>');
        t.completed_at_cell.html(time);
      }
    });
  }

  this.init = function(){
    var t = this;

    this.complete_checkbox.change(function(e){
      t.update($(this));
    });

    this.tracking_id_input.change(function(e){
      t.update($(this));
    });
  }
}
