window.addEventListener('load', function(){
                        
 
    var touchsurface = document.getElementsByTagName("td"),
        //var touchsurface = $("#touchsurface"),
        pressed = false,
        start = undefined,
        startX, startY, startWidth, startHeight,
        dist,
        threshold = 150, //required min distance traveled to be considered swipe
        allowedTime = 200, // maximum time allowed to travel that distance
        elapsedTime,
        startTime;
 
    function handleswipe(isrightswipe){
        if (isrightswipe)
            touchsurface.innerHTML = 'Congrats, you\'ve made a <span style="color:red">right swipe!</span>'
        else{
            touchsurface.innerHTML = 'Condition for right swipe not met yet'
        }
    }
                        
for (var i = 0; i < touchsurface.length ; i++) {
    touchsurface[i].addEventListener('touchstart', function(e){
                                     start = $(this);
                                     pressed = true;
                                     startX = e.pageX;
                                     startY = e.pageY;
                                     startWidth = $(this).width();
                                     startHeight = $(this).height();
                                     
                                     touchsurface.innerHTML = startWidth
                                     e.preventDefault()
                                         }, false)
                        
    touchsurface[i].addEventListener('touchmove', function(e){
                                  if(pressed) {
                                  $(start).width(startWidth+(e.pageX-startX));
                                  $(start).height(startHeight+(e.pageY-startY));
                                  }
                                  e.preventDefault() // prevent scrolling when inside DIV
                                      }, false)
     
    touchsurface[i].addEventListener('touchend', function(e){
                                  if(pressed) {
                                  pressed = false;
                                  }
                                  e.preventDefault()
                                      }, false)
}
    
/*
touchsurface.addEventListener('touchstart', function(e){
                              start = $(this);
                              pressed = true;
                              startX = e.pageX;
                              startY = e.pageY;
                              startWidth = $(this).width();
                              startHeight = $(this).height();
                              
                              touchsurface.innerHTML = startWidth
                              e.preventDefault()
                                  }, false)

touchsurface.addEventListener('touchmove', function(e){
                              if(pressed) {
                              $(start).width(startWidth+(e.pageX-startX));
                              $(start).height(startHeight+(e.pageY-startY));
                              }
                              e.preventDefault() // prevent scrolling when inside DIV
                                      }, false)
 
touchsurface.addEventListener('touchend', function(e){
                              if(pressed) {
                              pressed = false;
                              }
                              e.preventDefault()
                                      }, false)*/
    /*
    touchsurface.addEventListener('touchstart', function(e){
                                  
        touchsurface.innerHTML = ''
        e = e || window.event;
        var target = e.target || e.srcElement,
        text = target.textContent || text.innerText;
                                  
        touchsurface.innerHTML = $(this).width();
        var touchobj = e.changedTouches[0]
        dist = 0
        startX = touchobj.pageX
        startY = touchobj.pageY
        startTime = new Date().getTime() // record time when finger first makes contact with surface
        e.preventDefault()
    }, false)
 
    touchsurface.addEventListener('touchmove', function(e){
        e.preventDefault() // prevent scrolling when inside DIV
    }, false)
 
    touchsurface.addEventListener('touchend', function(e){
        var touchobj = e.changedTouches[0]
        dist = touchobj.pageX - startX // get total dist traveled by finger while in contact with surface
        elapsedTime = new Date().getTime() - startTime // get time elapsed
        // check that elapsed time is within specified, horizontal dist traveled >= threshold, and vertical dist traveled <= 100
        var swiperightBol = (elapsedTime <= allowedTime && dist >= threshold && Math.abs(touchobj.pageY - startY) <= 100)
        handleswipe(swiperightBol)
        e.preventDefault()
    }, false)
    */
}, false) // end window.onload
