
  //--- Get #shipping_company for MailImageRequest --------------------------------------------
  function completeForwardRequest(url, shipping_company, box){
    $.ajax({
      url: url.replace('slug_for_shipping_company', shipping_company),
      method: 'POST',
      dataType: 'script',
      format: 'script',
      complete: function(){
        box.closest('.controls').detach();
      }
    });
  }

  function getOtherShippingCompanyToCompleteForwardRequest(url, box){
    var input = $('<input name="other_shipping_company" class="form-control" placeholder="Name of other Company" />');
    box.html(input);
    input.change(function(e){
      completeForwardRequest(url, $(this).val(), box);
    });
    input.select();
  }

  function initForwardRequests(){
    var forward_requests = $('.forward_request_link');
    forward_requests.each(function(i, req){
      $(this).on('click', function(e){
        e.preventDefault();
        e.stopImmediatePropagation();

        // Get relevant data from the link
        var link = $(this);
        var url = link.attr('href');
        var box = link.closest('.form-group');

        // Create a Select for possible mailing options
        var select = $('<select name="shipping_company" class="form-control"></select>');
        select.append('<option>Select a Shipping Option</option>')
        var options = ['USPS', 'UPS', 'FedEx', 'Other'];
        $.each(options, function(i, opt){
          select.append('<option name="' + opt + '">' + opt + '</option>');
        });

        box.html(select);

        select.change(function(e){
          // On change, either send the request, or get the name of the 'Other' shipping co
          var co = $(this).val();
          if(co == 'Other'){
            getOtherShippingCompanyToCompleteForwardRequest(url, box);
          } else {
            completeForwardRequest(url, co, box);
          }

        });
      });
    });    
  }
