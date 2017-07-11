function MailQueuePopovers(){
  this.image_links = $('.image_popover_control');
  this.text_links = $('.text_popover_control');

  this.init = function(){
    const t = this;

    this.text_links.click(function(e){
      e.preventDefault();
    });

    this.image_links.click(function(e){
      e.preventDefault();
    });

    $.each(t.image_links, function(i, link){
      link = $(link);
      var img_src = link.data('image-url');

      var doc_w = $(document).width();
      var link_w = link.width();
      var pos = link.offset();
      var w = doc_w - pos['left'] - link_w - 50;

      $(link).popover({
        html: true,
        trigger: 'focus',
        // placement: 'auto left',
        // container: true,
        content: function(){
          return '<img src="' + img_src + '" width="' + w + 'px" />';
        }
      });
    }); // each image_link

    $.each(t.text_links, function(i, link){
      link = $(link);
      var text = link.data('text');
      $(link).popover({
        html: true,
        trigger: 'focus',
        content: function(){
          return text;
        },
      });
    }); // each text_link
  }
}
