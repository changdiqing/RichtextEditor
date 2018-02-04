var pressed = false,
    isResized = false,
    start = undefined,
    resizeStepWidth = 20,
    startX, startY, startWidth, startHeight, checkpointX, checkpointY;

function method_enterLayoutMode() {
    var touchsurfaceDiv = document.querySelectorAll("div.block");
    for (var i = 0; i < touchsurfaceDiv.length ; i++) {
        touchsurfaceDiv[i].contentEditable = false;
        touchsurfaceDiv[i].addEventListener('touchstart', method_touchStartFunction, false);
        touchsurfaceDiv[i].addEventListener('touchmove', method_touchMoveFunction, false);
        touchsurfaceDiv[i].addEventListener('touchend', method_touchEndFunction, false);
    }
    var touchsurface = document.querySelectorAll("img.block");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].contentEditable = false;
        touchsurface[i].addEventListener('touchstart', method_touchStartFunction, false);
        touchsurface[i].addEventListener('touchmove', method_touchMoveFunction, false);
        touchsurface[i].addEventListener('touchend', method_touchEndFunction, false);
    }
}

function method_enterContentMode() {
    var touchsurfaceDiv = document.querySelectorAll("div.block");
    for (var i = 0; i < touchsurfaceDiv.length ; i++) {
        touchsurfaceDiv[i].contentEditable = true;
        touchsurfaceDiv[i].removeEventListener('touchstart', method_touchStartFunction, false);
        touchsurfaceDiv[i].removeEventListener('touchmove', method_touchMoveFunction, false);
        touchsurfaceDiv[i].removeEventListener('touchend', method_touchEndFunction, false);
    }
    var touchsurface = document.querySelectorAll("img.block");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].contentEditable = true;
        touchsurface[i].removeEventListener('touchstart', method_touchStartFunction, false);
        touchsurface[i].removeEventListener('touchmove', method_touchMoveFunction, false);
        touchsurface[i].removeEventListener('touchend', method_touchEndFunction, false);
    }
}


function method_touchStartFunction(e){
    start = $(this);
    pressed = true;
    startX = e.pageX;
    checkpointX = e.pageX;
    startY = e.pageY;
    checkpointY = e.pageY;
    startWidth = $(this).width();
    startHeight = $(this).height();
    //touchTimer = setTimeout(function() { myFunction(); }, 1000);
    e.preventDefault();
}

function method_touchMoveFunction(e){
    if(pressed) {
        if(Math.abs(e.pageX-checkpointX) > resizeStepWidth) {
            // if exceed Schrittweite limit then resize and update checkpoint
            checkpointX = e.pageX;
            $(start).width(startWidth+(e.pageX-startX));
            if (!isResized){isResized = true}
        }
        if(Math.abs(e.pageY-checkpointY) > resizeStepWidth) {
            // if exceed Schrittweite limit then resize and update checkpoint
            checkpointY = e.pageY;
            $(start).height(startHeight+(e.pageY-startY));
            if (!isResized){isResized = true}
        }
       
    }
    e.preventDefault();
}

function method_touchEndFunction(e){
    if(pressed) {
        pressed = false;
    }
    
    //if (touchTimer!==null) {
    //    clearTimeout(doubletapTimer);
        //start.contentEditable = true;
    //} else {
    //}
    if(!isResized){
        javaScriptCallToSwift.test();
    } else {
        isResized = false;
    }
    
    e.preventDefault();
}

function method_changeStartBackgroundColor(color){
    $(start).css("background-color",color);
}

function method_changeStartBackgroundImage(url, alt) {
    $(start).css("background-image", "url(" + url + ")");
};
