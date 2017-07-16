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
      var link = $(link);
      var img_src = link.data('image-url');

      var doc_w = $(document).width();
      var link_offset_x = link.offset().left;

      var left = (doc_w / 2) < link_offset_x ? true : false;

      var w = doc_w * .75;

      $(link).popover({
        html: true,
        trigger: 'focus',
        placement: function(){
          return left ? 'left' : 'right';
        },
        // container: '#test',
        content: function(){
          return '<img src="' + img_src + '" width="' + w + 'px" />';
          // return '<img src="' + img_src + '" />';
        }
      });
    }); // each image_link

    $.each(t.text_links, function(i, link){
      link = $(link);
      var text = link.data('text');
      $(link).popover({
        html: true,
        trigger: 'focus',
        placement: 'right',
        content: function(){
          return text;
        },
      });
    }); // each text_link

    $.each(t.image_links, function(i, link){
      $(link).on('show.bs.popover', function(e){
        // console.log($(this));
        // $('#popover_anchor').append(this);
      });
    });
  }
}
