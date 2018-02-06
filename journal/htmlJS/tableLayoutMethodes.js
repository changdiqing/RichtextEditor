var pressed = false,
    isResized = false,
    start = undefined,
    resizeStepWidth = 15,
    startX, startY, startWidth, startHeight, offsetX, offsetY, newWidth, newHeight;

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
    startY = e.pageY;
    startWidth = $(this).width();
    startHeight = $(this).height();
    startRight = $(this).position().left+startWidth;
    startBottom = $(this).position().top+startHeight;
    e.preventDefault();
}

function method_touchMoveFunction(e){
    offsetX = e.pageX-startX;
    offsetY = e.pageY-startY;
    
    if (!isResized) {
        if ((Math.abs(offsetX) > resizeStepWidth) || (Math.abs(offsetY) > resizeStepWidth)) {isResized = true;}
    }
    
    if(pressed && isResized) {
        $(start).width(startWidth+offsetX);
        $(start).height(startHeight+offsetY);
    }
    e.preventDefault();
}

function method_touchEndFunction(e){
    if(pressed) {
        pressed = false;
    }
    
    if(isResized){
        isResized = false;
        
        newWidth = round($(start).width(), resizeStepWidth)
        newHeight = round($(start).height(), resizeStepWidth)
        
        $(start).width(newWidth);
        $(start).height(newHeight);
    } else {
        javaScriptCallToSwift.test();
    }
    
    e.preventDefault();
}

function method_changeStartBackgroundColor(color){
    $(start).css("background-color",color);
}

function method_changeStartBackgroundImage(url, alt) {
    $(start).css("background-image", "url(" + url + ")");
};

var round = function (x, to) {
    return Math.round(x / to) * to;
};
