var img_dimensions = function(klass) {
  var image_url = $('.' + klass).css('background-image'),
      image,
      width,
      height,
      res;
      
  // Remove url() or in case of Chrome url("")
  image_url = image_url.match(/^url\("?(.+?)"?\)$/);

  if (image_url[1]) {
      image = new Image();
      image_url = image_url[1];
      // just in case it is not already loaded
      image.src = image_url;
      // res = $(image).load(function() {
      width = image.width
      height = image.height
      return([width, height]);
      // });
      // alert("res is " + res)
      // return res
  };
};

$( document ).ready(function() {
  var bckgrd_options = ['bckgrd-1', 'bckgrd-2', 'bckgrd-3', 'bckgrd-4',
                        'bckgrd-5'];
  var bckgrd_number = Math.floor(Math.random() * bckgrd_options.length);
  var bckgrd_class;
	var splash = $(".splash");
  bckgrd_class = bckgrd_options[bckgrd_number];
  splash.toggleClass(bckgrd_class);
  
  // var image_url = $('.' + bckgrd_class).css('background-image'),
  //     image,
  //     width,
  //     height,
      
  // Remove url() or in case of Chrome url("")
  // image_url = image_url.match(/^url\("?(.+?)"?\)$/);
  // if (image_url[1]) {
  //   var speed = 2.0;
  //
  //   image = new Image();
  //   image_url = image_url[1];
    
    // just in case it is not already loaded
    // image.src = image_url;
    //
    // $(image).load(function() {
    //   width = image.width
    //   height = image.height
    //   $(window).scroll(function () {
        // alert("background_width = " + width)
        // var aspect_ratio = splash.width() / width;
        // var scaled_height = aspect_ratio * height;
        // var yPos = -$(window).scrollTop() / speed;
        // var pos = "50% " + yPos + "px";
        // alert("scaled height = " + scaled_height);
        // if (yPos * speed + scaled_height > splash.height()) {
          // alert(yPos + scaled_height + " > " + splash.height())
  //         splash.css('background-position', pos);
  //       };
  //     });
  //
  //   });
  // };
    
  // var dimensions = img_dimensions(bckgrd_class);
  // var background_width = dimensions[0];
  // var background_height = dimensions[1];
  // alert("width = " + background_width + "; height = " + background_height)
}); 

