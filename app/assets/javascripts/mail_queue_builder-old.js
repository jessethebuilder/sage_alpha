function MailQueueBuilder(){
  this.feedback = $('#feedback');

  this.upload_count = 0;

  this.files = [];

  this.getImageFiles = function(){
    return $('#mail_queue_images')[0].files;
  };

  this.createMailQueue = function(){
    // Upon submit, create a new MailQueue and return the id
    return new Promise(function(fullfill, reject){
      $.ajax({
        url: '/mail_queues.json',
        type: 'POST',
        data: {
          'mail_queue': {
            // This gets ignored, but there needs to be some data available
            some: 'data'
          }
        },
        success: function(val){
          fullfill(val);
        }
      });
    });
  }

  this.buildMailImages = function(){
    var t = this;

    return new Promise(function(fullfill, reject){
      t.feedback.html('Reading image files');

      var image_files = t.getImageFiles();

      $.each(image_files, function(i, file){
        var reader = new FileReader();

        reader.onload = function(e){
          var o = {};
          o.name = file.name;
          o.data = e.target.result;
          t.files.push(o);

          if(t.files.length == image_files.length){
            // This will have to be modified if in-app OCR is used
            fullfill();
          }
        };

        if(file.type === 'text/plain'){
          reader.readAsText(file);
        } else {
          reader.readAsDataURL(file);
        }
      });
    });
  }

  this.uploadFile = function(image_data, text){
    var t = this;

    return new Promise(function(fullfill, reject){
      $.ajax({
        url: '/mail_images.json',
        method: 'POST',
        data: {
          mail_image:{
            image: image_data,
            text: text,
          },
            mail_queue: {
              id: t.mail_queue_id
            }
        },
        success: function(){
          t.upload_count += 1;
          fullfill();
        }
      });
    });
  }

  this.uploadFiles = function(){
    var t = this;

    $.each(t.files, function(i, file){
      var r1 = /(.+)\.txt$/;
      var m1 = r1.exec(file.name);
      if(m1){
        var file_name = m1[1];

        // assumes all files are jpegs
        $.each(t.files, function(j, img){
          // if a text file is found, find corosponding image file
          var r2 = /(.+)\.jpe?g$/;
          var m2 = r2.exec(img.name);

          if(m2){
            var img_name = m2[1];
            if(img_name === file_name){
              t.uploadFile(img.data, file.data).then(function(){
                if(t.upload_count === t.files.length / 2){
                  // change / 2 if OCR is going to be handled client-side
                  t.feedback.html("All Uploads Complete!");
                  window.location = "/mail_queues/" + t.mail_queue_id;
                } else {
                  t.feedback.html("Uploaded " + t.upload_count + " Images.");
                }
              });
            }
          }
        });

      }
    });
  }

  this.init = function(){
    var t = this;

    $('.mail_queue_form input[type="submit"]').click(function(e){
      e.preventDefault();

      // create a new mail_queue, and save newly formed id
      t.createMailQueue().then(function(ret){
        t.mail_queue_id = ret.$oid;
        t.buildMailImages().then(function(){
          // Build image files (which also inlcude text files, at this point)
          // and upload one at a time.
          t.uploadFiles();
        });
      });

    });
  }
}
