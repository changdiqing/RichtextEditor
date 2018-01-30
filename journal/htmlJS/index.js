window.addEventListener('load', function(){
                        
 
    var touchsurface = document.getElementsByTagName("td"),
        demo = document.getElementById("demo"),
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
    var doubletapDeltaTime_ = 700;
    var doubletap1Function_ = null;
    var doubletap2Function_ = null;
    var doubletapTimer = null;
    var touchTimer = null;
    
    function tap(singleTapFunc, doubleTapFunc) {
        if (doubletapTimer==null) {
            // First tap, we wait X ms to the second tap
            doubletapTimer_ = setTimeout(doubletapTimeout_, doubletapDeltaTime_);
            doubletap1Function_ = singleTapFunc;
            doubletap2Function_ = doubleTapFunc;
        } else {
            // Second tap
            clearTimeout(doubletapTimer);
            doubletapTimer_ = null;
            doubletap2Function_();
        }
    }
    //demo.addEventListener('click', enterContentMode, false);
    

                        
    function enterLayoutMode() {
        var touchsurface = document.getElementsByTagName("td");
        for (var i = 0; i < touchsurface.length ; i++) {
            touchsurface[i].addEventListener('touchstart', touchStartFunction, false)
            touchsurface[i].addEventListener('touchmove', touchMoveFunction, false)
            touchsurface[i].addEventListener('touchend', touchEndFunction, false)
        }
    }
                        
    function enterContentMode() {
        
        document.getElementById("demo").innerHTML = "enter content mode!";
        for (var i = 0; i < touchsurface.length ; i++) {
            touchsurface[i].removeEventListener('touchstart', touchStartFunction, false)
            touchsurface[i].removeEventListener('touchmove', touchMoveFunction, false)
            touchsurface[i].removeEventListener('touchend', touchEndFunction, false)
        }
    }
    
    for (var i = 0; i < touchsurface.length ; i++) {
        //touchsurface[i].addEventListener('click', function() { demo.innerHTML = "tapOnce"; }, false);  commented by Diqing Chang this can not be used together with touchstart at the same time
        touchsurface[i].addEventListener('touchstart', touchStartFunction, false)
        touchsurface[i].addEventListener('touchmove', touchMoveFunction, false)
        touchsurface[i].addEventListener('touchend', touchEndFunction, false)
    }
    
                        
                        
                        
                        
    function myFunction() {
        document.getElementById("demo").innerHTML = "Hello World";
    }
                        
    function touchStartFunction(e){
    start = $(this);
    pressed = true;
    startX = e.pageX;
    startY = e.pageY;
    startWidth = $(this).width();
    startHeight = $(this).height();
    touchTimer = setTimeout(function() { myFunction(); }, 1000);
    start.innerHTML = startWidth;
    e.preventDefault();
    }
                        
    function touchMoveFunction(e){
        if(pressed) {
        $(start).width(startWidth+(e.pageX-startX));
        $(start).height(startHeight+(e.pageY-startY));
        }
        e.preventDefault();
    }
                        
    function touchEndFunction(e){
    if(pressed) {
    pressed = false;
    }
    
    if (touchTimer!==null) {
    clearTimeout(doubletapTimer);
    document.getElementById("demo").innerHTML = "within 1000!";
    //start.contentEditable = true;
    } else {
    document.getElementById("demo").innerHTML = "1000 exceeded!";
    }
    
    e.preventDefault();
    }
}, false) // end window.onload
