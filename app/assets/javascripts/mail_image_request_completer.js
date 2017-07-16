function MailImageRequestCompleter(){
  this.init = function(){
    var checkboxes = $('.complete_checkbox');
    checkboxes.change(function(e){
      var cb = $(this);
      var complete = cb.is(':checked');
      var cell = cb.closest('td');
      var row = cb.closest('tr');
      var cells = row.find('td');

      var row = cb.closest('.mail_image_request_row');
      var id = row.data('mail-image-request-id');

      var tracking_id = row.find('input[name="tracking_id"]').val();

      $.ajax({
        url: '/mail_image_requests/' + id,
        method: 'PATCH',
        data: {
          mail_image_request: {
            complete: complete,
            tracking_id: tracking_id
          },
        },
        dataType: 'json',
        format: 'json',
        complete: function(data){
          var json = JSON.parse(data.responseText);
          // var id = json.id.$oid;
          var cell_index;
          $.each(cells, function(i, c){
            if(c == cell[0]){ cell_index = i; }
          });

          var time_cell = $(cells[cell_index + 1]);
          var time = json.completed_at;
          if(time == null){
            time_cell.text('');
          } else {
            time_cell.text(json.formatted_completed_at);
          }
        }
      });
    });
  }
}
