var pressed = false,
    start = undefined,
    startX, startY, startWidth, startHeight;

function method_enterLayoutMode() {
    var touchsurface = document.getElementsByTagName("td");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].addEventListener('touchstart', method_touchStartFunction, false)
        touchsurface[i].addEventListener('touchmove', method_touchMoveFunction, false)
        touchsurface[i].addEventListener('touchend', method_touchEndFunction, false)
    }
}


function method_touchStartFunction(e){
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

function method_touchMoveFunction(e){
    if(pressed) {
        $(start).width(startWidth+(e.pageX-startX));
        $(start).height(startHeight+(e.pageY-startY));
    }
    e.preventDefault();
}

function method_touchEndFunction(e){
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
