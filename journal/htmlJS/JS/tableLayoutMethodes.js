var pressed = false,
hasSelected = false,
isResized = false,
start = undefined,
start2 = undefined,
resizeStepWidth = 15,
startX, startY, startTop, startLeft, startWidth, startHeight, offsetX, offsetY,
posOffset = 0,
touchBlockFocused = false;
var hLine = document.getElementById("hLine");
var vLine = document.getElementById("vLine");

function bodyInsertHTML(html) {
    alert("something");
    //RE.editor.insertAdjacentHTML( 'beforeend', html);  // afterbegin
    document.getElementsByTagName("BODY")[0].insertAdjacentHTML( 'beforeend', html);  // Test, Diqing 19.07.2018
    
};

function initNewDomPos() {  // For now only work to initial floatingTouchBlock's position
    var newDom = document.getElementById("1");
    var initTop = window.pageYOffset+200;
    newDom.style.top = initTop + "px";
    newDom.id = "0";
}

function hasHightlight() {
    var sel;
    if (window.getSelection) {
        sel = window.getSelection();
        if (sel.toString().length !== 0) {
            return true
        }
    } else if ( (sel = document.selection) && sel.type != "Control" && sel.toString().length !== 0) {
        return true
    }
    return false  // if selection length longer than content then should edit the selected text not the parent node
}

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

function f(){
    var r = document.getElementById('touchblockMoveCover').getBoundingClientRect();
    return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}';
}

function resetPosOffset(newPosOffset) {
    posOffset = newPosOffset;
}

// Initial dom element with event listeners
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
        //touchsurface[i].addEventListener('touchstart', method_imgtouchStart, false);
        //touchsurface[i].addEventListener('touchmove', method_imgMoveFunction, false);
        touchsurface[i].addEventListener('touchend', method_imgTouchEnd, false);
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
        myImgs[i].addEventListener('touchstart', method_imgTouchStart, false);
        myImgs[i].addEventListener('touchmove', method_imgMoveFunction, false);
    }
}

function removeMasksButThis() {
    var myMoveCovers = document.querySelectorAll("div.touchblockMoveCover:not(#thisCover)");
    for (var i = 0; i < myMoveCovers.length ; i++) {
        myMoveCovers[i].style.display= "none";
    }
    
    var myResizeCovers = document.querySelectorAll("div.touchblockResizeCover:not(#thisCover)");
    for (var i = 0; i < myResizeCovers.length ; i++) {
        myResizeCovers[i].style.display= "none";
    }
    
    var myImgs = document.querySelectorAll("img:not(#thisCover)");
    for (var i = 0; i < myImgs.length ; i++) {
        myImgs[i].removeEventListener('touchstart', method_imgTouchStart, false);
        myImgs[i].removeEventListener('touchmove', method_imgMoveFunction, false);
    }
}

function method_enterContentMode() {
    
    hasSelected = false;  // contentMode can not have any selected div
    
    var selCovers = document.querySelectorAll("#thisCover");
    for (var i = 0; i < selCovers.length ; i++) {
        selCovers[i].id = "";
    }
    
    removeMasksButThis();
}

function method_touchStartFunction(e){
    e.stopPropagation();
    start = this.parentElement;
    
    if (start.id !== "thisCover") {  // if no div selected then should clean all but this div
        start.id = "thisCover";
        var moveCover = start.querySelector('.touchblockMoveCover');
        var resizeCover = start.querySelector('.touchblockResizeCover');
        if (moveCover !== null) {
            moveCover.id = "thisCover";
        }
        if (resizeCover !== null) {
            resizeCover.id = "thisCover";
        }
        removeMasksButThis();
    }
    
    
    var rect = start.getBoundingClientRect();
    //console.log(rect.top, rect.right, rect.bottom, rect.left);
    hasSelected = true;  // true: there is an only selected div
    pressed = true;
    startX = e.pageX;
    startY = e.pageY;
    startLeft = start.offsetLeft;
    startTop = start.offsetTop;
    startWidth = $(start).width(); //.style.width;
    startHeight = $(start).height(); //.style.height;
    e.preventDefault();
}

function method_imgTouchStart(e){
    
    e.stopPropagation();
    start = this;
    
    if (start.id !== "thisCover") {
        start.id = "thisCover";
        removeMasksButThis();
    }
    
    
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

function method_imgMoveFunction(e){
    offsetX = e.pageX-startX;
    //offsetY = e.pageY-startY;
    
    if (!isResized) {
        if ((Math.abs(offsetX) > resizeStepWidth) || (Math.abs(offsetY) > resizeStepWidth)) {isResized = true;}
    }
    
    if(pressed && isResized) {
        $(start).width(startWidth+offsetX);
        //$(start).height(startHeight+offsetY);
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
            undivisibleR = leftOffset + $(start).width()- posOffset;
            devisibleR = round(undivisibleR, resizeStepWidth);
            
            var rightEnd = devisibleR + posOffset;
            var newWidth = rightEnd - leftOffset;
            var newHeight = round($(start).height(), resizeStepWidth);
            var bottomEnd = newHeight + topOffset;
            
            start.style.width = newWidth + "px";
            start.style.height = newHeight + "px";
            blink(rightEnd,bottomEnd)
        } else {
            javaScriptCallToSwift.showTouchblockMenu();
        }
    }
    e.preventDefault();
}

function method_imgTouchEnd(e){
    if(pressed) {
        pressed = false;
        if(isResized){
            isResized = false;
            leftOffset = start.offsetLeft;
            //topOffset = start.offsetTop;
            undivisibleR = leftOffset + $(start).width()- posOffset;
            devisibleR = round(undivisibleR, resizeStepWidth);
            var newWidth = devisibleR + posOffset - leftOffset;
            //newHeight = round($(start).height(), resizeStepWidth);
            start.style.width = newWidth + "px";
            //start.style.height = newHeight + "px";
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
    //start.style = "float:" + floatType;
    start.style.cssFloat = floatType;
    
    if (floatType == "left") {
        start.style.width = "25%";
        start.style.margin = "5px 10px 10px 5px";
    } else if (floatType == "right") {
        start.style.width = "25%";
        start.style.margin = "5px 5px 10px 10px";
    } else if (floatType == "none") {  // set float to none to middle the images
        start.style.height = "auto";
        start.style.width = "80%";
        start.style.marginTop = "20px";
        start.style.marginBottom = "10px";
        start.style.marginLeft = "Auto";
        start.style.marginRight = "Auto";
    }
    
}

function method_setImgBorder(borderType){
    $(start).css('border', borderType);
}

function method_setTouchblockFilter(filterType){
    $(start).find('.touchblockBGICover').css('filter',filterType);
}

function method_setTouchblockBorder(borderType){
    $(start).find('.touchblockContentCover').css('border', borderType);
}

function method_setTouchblockFonts(fontType){
    $(start).find('.touchblockContentCover').css('font-family', fontType);
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
        $(start).find('.touchblockBGICover').css('background-image', "url(" + url + ")");
    } finally {

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

function changeParentFontBy(fontType) {
    var parentNode = getSelectionParentElement();
    if (parentNode == null) {  // null: only edit highlighted text
        document.execCommand("fontName", false, fontType);
    } else {  // !=null: no highlighted text, edit whole parent node where cursor is placed
        parentNode.style.fontFamily = fontType;
    }
}

function changeParentFontSizeBy(step) {
    var highlightDoms = getHighlightDoms();  // all Doms that contain highlighted text
    var style = window.getComputedStyle(highlightDoms[0], null).getPropertyValue('font-size');
    var sizeInFloat = parseFloat(style);
    sizeInFloat += step;
    for (var i=0, dom; dom = highlightDoms[i]; i++) {
        dom.style.fontSize = sizeInFloat + "px";
        dom.style.lineHeight = "1.7";
    }
}


function changeNodeFontSize(node, step) {  // change node font size by step width, no longer used
    var style = window.getComputedStyle(node, null).getPropertyValue('font-size');
    var sizeInFloat = parseFloat(style);
    sizeInFloat += step;
    node.style.fontSize = sizeInFloat + "px";
    node.style.lineHeight = "1.7";
}


function getHighlightDoms() {
    // get all Doms that contain the highlighted text
    var allSelected = [];
    var selection = window.getSelection();
    var range = selection.getRangeAt(0);
    var parentEl = range.commonAncestorContainer;
    if (parentEl.nodeType != 1) {  // if highlight doesn't cover multiple DOMs node type will not be 1
        allSelected.push(parentEl.parentNode);
    } else {
        var allWithinRangeParent =     parentEl.getElementsByTagName("*");
        for (var i=0, el; el = allWithinRangeParent[i]; i++) {
            //The second parameter says to include the element
            //even if it's not fully selected
            if (selection.containsNode(el, true) ) {
                allSelected.push(el);
            }
        }
    }
    //console.log('All selected =', allSelected);
    return allSelected;
}

// return parent element of selection
function getSelectionParentElement() {
    var parentEl = null, sel;
    if (window.getSelection) {
        sel = window.getSelection();
        if ((sel.toString().length == 0) && (sel.rangeCount)) {
            parentEl = sel.getRangeAt(0).commonAncestorContainer;
            if (parentEl.nodeType != 1) {
                parentEl = parentEl.parentNode;
            }
        }
    } else if ( (sel = document.selection) && sel.type != "Control" && sel.toString().length == 0) {
        parentEl = sel.createRange().parentElement();
    } else {
        return null  // if selection length longer than content then should edit the selected text not the parent node
    }
    return parentEl;
}

// return the nearest parent div of el
function upTo(el, tagName) {
    tagName = tagName.toLowerCase();
    
    while (el && el.parentNode) {
        if (el.tagName && el.tagName.toLowerCase() == tagName) {
            return el;
        }
        el = el.parentNode;
    }
    
    // Many DOM methods return null if they don't
    // find the element they are searching for
    // It would be OK to omit the following and just
    // return undefined
    return null;
}

//blink hLine and vLine once to indicate the right and left boundary
function blink(x,y) {
    hLine.style.top = y+'px';
    vLine.style.left = x+'px';
    $(vLine).fadeIn();
    $(hLine).fadeIn();
    $(hLine).fadeOut();
    $(vLine).fadeOut();
}

//document.getElementById("demo").innerText = getDocElementHtml();
function getDocElementHtml() {
    return document.documentElement.outerHTML;
};

// update srcs of all images including background images of DIVs after software update
function updateImgSrcs(docDirectory) {
    var allImg=document.getElementsByTagName("img"), i=0, img;
    
    while (img = allImg[i++])
    {
        var pathArray = img.src.split('/');
        if (pathArray[pathArray.length-3] == "Documents") {
            img.src = docDirectory.concat(pathArray[pathArray.length-2] + "/" + pathArray[pathArray.length-1]);
        }
        
    }
    
    var touchsurface = document.querySelectorAll("div.touchblockBGICover");
    for (var i = 0; i < touchsurface.length ; i++) {
        var imgurl = touchsurface[i].style.backgroundImage;
        var bi = imgurl.slice(4, -1).replace(/"/g, '');
                                             var pathArray = bi.split('/');
                                             if (pathArray[pathArray.length-3] == "Documents") {
                                             imgurl = docDirectory.concat(pathArray[pathArray.length-2] + "/" + pathArray[pathArray.length-1]);
                                             touchsurface[i].style.backgroundImage = "url(" + imgurl + ")";
                                             }
                                             
                                             }
                                             }
