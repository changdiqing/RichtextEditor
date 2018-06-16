var pressed = false,
isResized = false,
start = undefined,
resizeStepWidth = 15,
startX, startY, startTop, startLeft, startWidth, startHeight, offsetX, offsetY, newWidth, newHeight,
posOffset = 0,
touchBlockFocused = false;

// test methods

/*$('div[contenteditable]').keydown(function(e) {
// trap the return key being pressed
if (e.keyCode === 13) {
// insert 2 br tags (if only one br tag is inserted the cursor won't go to the next line)
//document.execCommand('insertHTML', false, '<br></br>'); // gives </div><br>
e.preventDefault();
//RE.insertHTML('\n');
//document.write('<br />');
document.execCommand('insertHTML', false, '<br></br>');
//document.body.insertAdjacentHTML( 'afterbegin', '<br></br>' );
// prevent the default behaviour of return key pressed
return false;
}

});*/

function setJustifyFull() {
    document.execCommand('justifyFull', false, null);
};

function setEditorFonts(fontsType) {
    RE.editor.style.fontFamily = fontsType;
}



function getImgSrcs() {
    var allImg=document.getElementsByTagName("img"), i=0, img;
    var imgSrcs = [];
    while (img = allImg[i++])
    {
        imgSrcs[i-1]= img.src;
    }
    return imgSrcs;
}

// floatingTouchBlock Methods
function updateImgSrcs(docDirectory) {
    var allImg=document.getElementsByTagName("img"), i=0, img;
    
    while (img = allImg[i++])
    {
        var pathArray = img.src.split('/');
        if (pathArray[pathArray.length-2] == "Documents") {
           img.src = docDirectory.concat(pathArray[pathArray.length-1]);
        }
        
    }
    
    var touchsurface = document.querySelectorAll("div.touchblockBGICover");
    for (var i = 0; i < touchsurface.length ; i++) {
        var imgurl = touchsurface[i].style.backgroundImage;
        var bi = imgurl.slice(4, -1).replace(/"/g, "");
        var pathArray = bi.split('/');
        if (pathArray[pathArray.length-2] == "Documents") {
            imgurl = docDirectory.concat(pathArray[pathArray.length-1]);
            touchsurface[i].style.backgroundImage = "url(" + imgurl + ")";
        }
        
    }
};

function testGetCaretData() {
    var y = 0;
    var sel = window.getSelection();
    var needsWorkAround = false;
    var pageYOffset = 0;
    if (sel.rangeCount) {
        var range = sel.getRangeAt(0);
        needsWorkAround = (range.startOffset == 0)
        /* Removing fixes bug when node name other than 'div' */
        // && range.startContainer.nodeName.toLowerCase() == 'div');
        if (needsWorkAround) {
            y = range.startContainer.offsetTop - window.pageYOffset;
            pageYOffset = window.pageYOffset;
        } else {
            if (range.getClientRects) {
                var rects=range.getClientRects();
                if (rects.length > 0) {
                    y = rects[0].top;
                }
            }
        }
    }
    
    return pageYOffset;
}

function testGetCaretData2() {
    
    var touchsurface = document.querySelectorAll("div.floatingTouchblock");
    var result = touchsurface[0].offsetTop;
    
    //result = $("#floatingTouchblock").offset().top;
    var start = $(this).parent();
    var offsetTop = $(start).offset().top;
    
    return offsetTop;
}

function f(){
    var r = document.getElementById('touchblockMoveCover').getBoundingClientRect();
    return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}';
}

function resetPosOffset(newPosOffset) {
    posOffset = newPosOffset;
}

function method_initTouchblockCovers() {
    var touchsurface = document.querySelectorAll("div.touchblockMoveCover");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].addEventListener('touchstart', method_touchStartFunction, false);
        touchsurface[i].addEventListener('touchmove', method_touchMoveFloating, false);
        touchsurface[i].addEventListener('touchend', method_touchEndFunction, false);
    }
    
    var touchsurface = document.querySelectorAll("div.touchblockResizeCover");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].addEventListener('touchstart', method_touchStartFunction, false);
        touchsurface[i].addEventListener('touchmove', method_touchMoveFunction, false);
        touchsurface[i].addEventListener('touchend', method_touchEndFunction, false);
    }
    
    var touchsurface = document.querySelectorAll("img");
    for (var i = 0; i < touchsurface.length ; i++) {
        /*touchsurface[i].addEventListener('touchstart', method_touchStartImg, false);*/
        touchsurface[i].addEventListener('touchmove', method_touchMoveFunction, false);
        touchsurface[i].addEventListener('touchend', method_touchEndImg, false);
    }
    
    /* obsolete, flex-row no longer used, old touchblock: touchblockObsolete.html
    var touchsurface = document.querySelectorAll("div.flex-row");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].contentEditable = "false";
    }*/
    
    var touchsurface = document.querySelectorAll("div.touchblock");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].contentEditable = "false";
    }
    
    
}

function method_enterLayoutMode() {
    var myMoveCovers = document.querySelectorAll("div.touchblockMoveCover");
    for (var i = 0; i < myMoveCovers.length ; i++) {
        myMoveCovers[i].style.display= "block";
    }
    
    var myResizeCovers = document.querySelectorAll("div.touchblockResizeCover");
    for (var i = 0; i < myResizeCovers.length ; i++) {
        myResizeCovers[i].style.display= "block";
    }
                                             
                                             var myImgs = document.querySelectorAll("img");
                                             for (var i = 0; i < myImgs.length ; i++) {
                                             myImgs[i].addEventListener('touchstart', method_touchStartImg, false);
                                             }
}

function method_enterContentMode() {
    var myMoveCovers = document.querySelectorAll("div.touchblockMoveCover");
    for (var i = 0; i < myMoveCovers.length ; i++) {
        myMoveCovers[i].style.display= "none";
    }
    
    var myResizeCovers = document.querySelectorAll("div.touchblockResizeCover");
    for (var i = 0; i < myResizeCovers.length ; i++) {
        myResizeCovers[i].style.display= "none";
    }
                                             
                                             var myImgs = document.querySelectorAll("img");
                                             for (var i = 0; i < myImgs.length ; i++) {
                                             myImgs[i].removeEventListener('touchstart', method_touchStartImg, false);
                                             }
}

function method_touchStartFunction(e){
    /*
     e.stopPropagation();
     start = $(this).parent();
     var rect = this.parentElement.getBoundingClientRect();
     //console.log(rect.top, rect.right, rect.bottom, rect.left);
     pressed = true;
     startX = e.pageX;
     startY = e.pageY;
     startWidth = $(start).width();
     startHeight = $(start).height();
     startLeft = this.parentElement.offsetLeft;
     startTop = this.parentElement.offsetTop;
     document.getElementById("demo").innerHTML = rect.bottom;*/
    
    e.stopPropagation();
    start = this.parentElement;
    var rect = start.getBoundingClientRect();
    //console.log(rect.top, rect.right, rect.bottom, rect.left);
    pressed = true;
    startX = e.pageX;
    startY = e.pageY;
    startLeft = start.offsetLeft;
    startTop = start.offsetTop;
    startWidth = $(start).width(); //.style.width;
    startHeight = $(start).height(); //.style.height;
    
    e.preventDefault();
}

function method_touchStartImg(e){
    
    e.stopPropagation();
    start = $(this);
    pressed = true;
    startX = e.pageX;
    startY = e.pageY;
    startWidth = $(start).width();
    startHeight = $(start).height();
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

function method_touchMoveFloating(e){
    offsetX = e.pageX-startX;
    offsetY = e.pageY-startY;
    
    if (!isResized) {
        if ((Math.abs(offsetX) > resizeStepWidth) || (Math.abs(offsetY) > resizeStepWidth)) {isResized = true;}
    }
    
    if(pressed && isResized) {
        $(start).css({top: startTop+offsetY, left: startLeft+offsetX, position:'absolute'});
    }
    e.preventDefault();
}

function method_touchEndFunction(e){
    if(pressed) {
        pressed = false;
                                             if(isResized){
                                             isResized = false;
                                             leftOffset = start.offsetLeft;
                                             topOffset = start.offsetTop;
                                             undivisibleR = leftOffset + $(start).width()- posOffset
                                             devisibleR = round(undivisibleR, resizeStepWidth)
                                             newWidth = devisibleR + posOffset - leftOffset
                                             newHeight = round($(start).height(), resizeStepWidth)
                                             
                                             start.style.width = newWidth + "px"
                                             start.style.height = newHeight + "px"
                                             } else {
                                             javaScriptCallToSwift.showTouchblockMenu();
                                             }
    }
    
    
    e.preventDefault();
}

function method_touchEndImg(e){
    if(pressed) {
        pressed = false;
                                             if(isResized){
                                             isResized = false;
                                             leftOffset = start.offsetLeft;
                                             topOffset = start.offsetTop;
                                             undivisibleR = leftOffset + $(start).width()- posOffset;
                                             devisibleR = round(undivisibleR, resizeStepWidth);
                                             newWidth = devisibleR + posOffset - leftOffset;
                                             newHeight = round($(start).height(), resizeStepWidth);
                                             $(start).width(newWidth);
                                             $(start).height(newHeight);
                                             } else {
                                             javaScriptCallToSwift.showImgMenu();
                                             }
    }

    
    e.preventDefault();
}


function method_cloneTouchblock() {
    var $clone = $(start).clone();
    $(start).parent().append($clone);
}
                                             
function method_setImgFilter(filterType){
    $(start).css('filter',filterType);
}
                                             
function method_setImgFloat(floatType){
    $(start).css('float',floatType);
}

function method_setImgFloatMiddle(){
    start.style = "float:middle";
}
                                             


function method_setImgBorder(borderType){
    $(start).css('border', borderType);
}
                                             
function method_setTouchblockFilter(filterType){
    $(start).find('.touchblockBGICover').css("filter",filterType);
}

function method_setTouchblockBorder(borderType){
    $(start).find('.touchblockContentCover').css('border', borderType);
}
                                             
function method_setTouchblockFonts(borderType){
    $(start).find('.touchblockContentCover').css('font-family', borderType);
}

function method_setTouchblockBorderColor(colorInHex){
    $(start).find('.touchblockContentCover').css('border-color', colorInHex);
}

function method_changeStartBackgroundColor(color){
    $(start).find('.touchblockBGICover').css('background-image', 'none');
    $(start).find('.touchblockBGICover').css('background-color',color);
}

function method_changeStartBackgroundImage(url, alt) {
    try {
        $(start).find('.touchblockBGICover').css("background-image", "url(" + url + ")");
    } finally {
                   document.getElementById("demo").innerHTML = $(start).attr('src');
                  $(start).attr('src',url);
    }
};

function mehtod_setStartTextOrientationVertical() {
    $(start).find('.touchblockContentCover').css("writing-mode", "vertical-lr");
};

function mehtod_setStartTextOrientationHorizon() {
    $(start).find('.touchblockContentCover').css("writing-mode", "horizontal-tb");
};

function myFunction() {
    var touchsurface = document.querySelectorAll("div.touchblockContentCover");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].contentEditable = "true";
        touchsurface[i].parentNode.contentEditable = "false";
    }
}

function focusoutFunction() {
    var touchsurface = document.querySelectorAll("div.touchblockContentCover");
    for (var i = 0; i < touchsurface.length ; i++) {
        touchsurface[i].contentEditable = "false";
        touchsurface[i].parentNode.contentEditable = "false";
    }
    
    touchBlockFocused = false;
}

function mehtod_removeStart() {
    $(start).remove();
}

var round = function (x, to) {
    return Math.ceil(x / to) * to;
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
//document.getElementById("demo").innerText = getDocElementHtml();
function getDocElementHtml() {
    return document.documentElement.outerHTML;
};
//document.getElementById("demo").innerText = getDocElementHtml();
function getDocElementHtml() {
    return document.documentElement.outerHTML;
};
