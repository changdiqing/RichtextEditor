var pressed = false,
    isResized = false,
    start = undefined,
    resizeStepWidth = 15,
    startX, startY, startWidth, startHeight, offsetX, offsetY, newWidth, newHeight;

function method_enterLayoutMode() {
    var touchsurface = document.querySelectorAll("img.block");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].contentEditable = false;
        touchsurface[i].style.border = "thin solid #000000";
        touchsurface[i].addEventListener('touchstart', method_touchStartFunction, false);
        touchsurface[i].addEventListener('touchmove', method_touchMoveFunction, false);
        touchsurface[i].addEventListener('touchend', method_touchEndFunction, false);
    }
    var touchsurfaceDiv = document.querySelectorAll("div.block");
    for (var i = 0; i < touchsurfaceDiv.length ; i++) {
        touchsurfaceDiv[i].contentEditable = false;
        touchsurfaceDiv[i].style.border = "thin solid #000000";
        touchsurfaceDiv[i].addEventListener('touchstart', method_touchStartFunction, false);
        touchsurfaceDiv[i].addEventListener('touchmove', method_touchMoveFunction, false);
        touchsurfaceDiv[i].addEventListener('touchend', method_touchEndFunction, false);
    }
}

            
function method_noEnterDivOld(e) {
    // trap the return key being pressed
    e.preventDefault();
    if (e.keyCode == 13) {
    // insert 2 br tags (if only one br tag is inserted the cursor won't go to the second line)
    document.execCommand('insertHTML', false, '<br><br>');
    // prevent the default behaviour of return key pressed
    return false;
    }
}

function method_noEnterDiv(e){
    if (e.keyCode === 13) {
        e.preventDefault();
        // insert 2 br tags (if only one br tag is inserted the             cursor won't go to the next line)
        document.execCommand('insertHTML', false, '<br><br>');
        // prevent the default behaviour of return key pressed
        
        return false;
    }
    document.getElementById("demo").innerHTML = "Hello World";
}

function method_enterContentMode() {
    var touchsurfaceDiv = document.querySelectorAll("div.block");
    for (var i = 0; i < touchsurfaceDiv.length ; i++) {
        touchsurfaceDiv[i].contentEditable = true;
        touchsurfaceDiv[i].style.border = "none";
        touchsurfaceDiv[i].removeEventListener('touchstart', method_touchStartFunction, false);
        touchsurfaceDiv[i].removeEventListener('touchmove', method_touchMoveFunction, false);
        touchsurfaceDiv[i].removeEventListener('touchend', method_touchEndFunction, false);
    }
    /*touchsurfaceDiv[i].addEventListener('touchstart', function(e){
                                        if (e.keyCode === 13) {
                                        e.preventDefault();
                                        // insert 2 br tags (if only one br tag is inserted the             cursor won't go to the next line)
                                        document.execCommand('insertHTML', false, '<br><br>');
                                        // prevent the default behaviour of return key pressed
                                        //document.getElementById("demo").innerHTML = "Hello World";
                                        return false;
                                        }
                                        
                                        });*/
    var touchsurface = document.querySelectorAll("img.block");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].contentEditable = true;
        touchsurface[i].style.border = "none";
        touchsurface[i].removeEventListener('touchstart', method_touchStartFunction, false);
        touchsurface[i].removeEventListener('touchmove', method_touchMoveFunction, false);
        touchsurface[i].removeEventListener('touchend', method_touchEndFunction, false);
    }
    var touchsurfaceDiv = document.querySelectorAll("div.flex-row");
    for (var i = 0; i < touchsurfaceDiv.length ; i++) {
        touchsurfaceDiv[i].contentEditable = false;
    }
}


function method_touchStartFunction(e){
    e.stopPropagation();
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

function method_cloneTouchblock() {
    var $clone = $(start).clone();
    $(start).parent().append($clone);
}

function method_setTouchblockFilter(filterType){
    $(start).css("filter",filterType);
}

function method_changeStartBackgroundColor(color){
    $(start).css("background-color",color);
}

function method_changeStartBackgroundImage(url, alt) {
    $(start).css("background-image", "url(" + url + ")");
};

function mehtod_setStartTextOrientationVertical() {
    $(start).css("writing-mode", "vertical-lr");
}

function mehtod_setStartTextOrientationHorizon() {
    $(start).css("writing-mode", "horizontal-tb");
}

function mehtod_removeStart() {
    $(start).remove();
}

var round = function (x, to) {
    return Math.round(x / to) * to;
};


function setEndOfContenteditable()
{
    var range,selection;
    var contentEditableElement = document.getElementById('editor');
    if(document.createRange)//Firefox, Chrome, Opera, Safari, IE 9+
    {
        range = document.createRange();//Create a range (a range is a like the selection but invisible)
        range.selectNodeContents(contentEditableElement);//Select the entire contents of the element with the range
        range.collapse(false);//collapse the range to the end point. false means collapse to end rather than the start
        selection = window.getSelection();//get the selection object (allows you to change selection)
        selection.removeAllRanges();//remove any selections already made
        selection.addRange(range);//make the range you have just created the visible selection
    }
    else if(document.selection)//IE 8 and lower
    {
        range = document.body.createTextRange();//Create a range (a range is a like the selection but invisible)
        range.moveToElementText(contentEditableElement);//Select the entire contents of the element with the range
        range.collapse(false);//collapse the range to the end point. false means collapse to end rather than the start
        range.select();//Select the range (make it the visible selection
    }
}
