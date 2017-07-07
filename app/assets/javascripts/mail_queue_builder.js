function MailQueueBuilder(){
  this.feedback = $('#feedback');

  this.upload_count = 0;

  this.files = [];

  this.getImageFiles = function(){
    return $('#mail_queue_images')[0].files;
  };

  this.createMailQueue = function(){
    // Upon submit, create a new MailQueue and return the id
    // After this, each image file will be added to this MailQueue via AJAX
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
        // create a reader for every image file
        var reader = new FileReader();

        // once reader.readAsDataURL() (below) completes,
        // save filename and image data to a hash
        reader.onload = function(e){
          var o = {};
          o.name = file.name;
          o.data = e.target.result;
          t.files.push(o);

          if(t.files.length == image_files.length){
            // Once every file has been added to the this.files array, return promise
            fullfill();
          }
        };

        reader.readAsDataURL(file);
      });
    });
  }

  this.uploadFile = function(image_data){
    var t = this;

    return new Promise(function(fullfill, reject){
      $.ajax({
        url: '/mail_images.json',
        method: 'POST',
        data: {
          mail_image:{
            image: image_data,
          },
            mail_queue: {
              id: t.mail_queue_id
            }
        },
        success: function(data){
          t.upload_count += 1;
          fullfill(data);
        }
      });
    });
  }

  this.uploadFiles = function(){
    var t = this;

    $.each(t.files, function(i, file){
      t.uploadFile(file.data).then(function(data){
        if(t.upload_count === t.files.length){
          t.feedback.html("All Uploads Complete!");
          window.location = "/mail_queues/" + t.mail_queue_id;
        } else {
          t.feedback.html("Uploaded " + t.upload_count + " Images.");
        }
      });
    });
  }

  this.init = function(){
    var t = this;

    $('.mail_queue_form input[type="submit"]').click(function(e){
      e.preventDefault();

      // create a new mail_queue, and save newly formed id
      t.createMailQueue().then(function(ret){
        // Returned mail_queue_id is used to add MailImages to MailQueue
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
