/**
 * Copyright (C) 2015 Wasabeef
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 "use strict";

var RE = {};
var defaultImageHeight = 100 // in px
const defaultImageSizeChangeRate = 25

window.onload = function() {
    RE.callback("ready");
};

RE.editor = document.getElementById('editor');

// Not universally supported, but seems to work in iOS 7 and 8
document.addEventListener("selectionchange", function() {
    RE.backuprange();
});

// Methods added by Diqing Chang, 07.11.2017

RE.resizeImageOfSelectedDiv = function(size) {
    var myimg = RE.editor.getElementsByTagName('img');
    for (i = 0; i < myimg.length; i++) {
        myimg[i].height = size;
    }
}

//looks specifically for a Range selection and not a Caret selection
RE.rangeSelectionExists = function() {
    //!! coerces a null to bool
    var sel = document.getSelection();
    if (sel && sel.type == "Range") {
        return true;
    }
    return false;
};

RE.rangeOrCaretSelectionExists = function() {
    //!! coerces a null to bool
    var sel = document.getSelection();
    if (sel && (sel.type == "Range" || sel.type == "Caret")) {
        return true;
    }
    return false;
};

RE.editor.addEventListener("input", function() {
    RE.updatePlaceholder();
    RE.backuprange();
    RE.callback("input");
});

RE.editor.addEventListener("focus", function() {
    RE.backuprange();
    RE.callback("focus");
});

RE.editor.addEventListener("blur", function() {
    RE.callback("blur");
});

RE.customAction = function(action) {
    RE.callback("action/" + action);
};

RE.updateHeight = function() {
    RE.callback("updateHeight");
}

RE.callbackQueue = [];
RE.runCallbackQueue = function() {
    if (RE.callbackQueue.length === 0) {
        return;
    }

    setTimeout(function() {
        window.location.href = "re-callback://";
    }, 0);
};

RE.getCommandQueue = function() {
    var commands = JSON.stringify(RE.callbackQueue);
    RE.callbackQueue = [];
    return commands;
};

RE.callback = function(method) {
    RE.callbackQueue.push(method);
    RE.runCallbackQueue();
};

RE.setHtml = function(contents) {
    var tempWrapper = document.createElement('div');
    tempWrapper.innerHTML = contents;
    var images = tempWrapper.querySelectorAll("img");

    for (var i = 0; i < images.length; i++) {
        images[i].onload = RE.updateHeight;
    }

    RE.editor.innerHTML = tempWrapper.innerHTML;
    RE.updatePlaceholder();
};

RE.getHtml = function() {
    return RE.editor.innerHTML;
};

RE.getText = function() {
    return RE.editor.innerText;
};

RE.setPlaceholderText = function(text) {
    RE.editor.setAttribute("placeholder", text);
};

RE.updatePlaceholder = function() {
    if (RE.editor.textContent.length > 0) {
        RE.editor.classList.remove("placeholder");
    } else {
        RE.editor.classList.add("placeholder");
    }
};

RE.removeFormat = function() {
    document.execCommand('removeFormat', false, null);
};

RE.setFontSize = function(size) {
    RE.editor.style.fontSize = size;
};

RE.setBackgroundColor = function(color) {
    RE.editor.style.backgroundColor = color;
};

RE.setHeight = function(size) {
    RE.editor.style.height = size;
};

RE.undo = function() {
    document.execCommand('undo', false, null);
};

RE.redo = function() {
    document.execCommand('redo', false, null);
};

RE.setBold = function() {
    document.execCommand('bold', false, null);
};

RE.setItalic = function() {
    document.execCommand('italic', false, null);
};

RE.setSubscript = function() {
    document.execCommand('subscript', false, null);
};

RE.setSuperscript = function() {
    document.execCommand('superscript', false, null);
};

RE.setStrikeThrough = function() {
    document.execCommand('strikeThrough', false, null);
};

RE.setUnderline = function() {
    document.execCommand('underline', false, null);
};

RE.setTextColor = function(color) {
    RE.restorerange();
    document.execCommand("styleWithCSS", null, true);
    document.execCommand('foreColor', false, color);
    document.execCommand("styleWithCSS", null, false);
};

RE.setTextBackgroundColor = function(color) {
    RE.restorerange();
    document.execCommand("styleWithCSS", null, true);
    document.execCommand('hiliteColor', false, color);
    document.execCommand("styleWithCSS", null, false);
};

RE.setHeading = function(heading) {
    document.execCommand('formatBlock', false, '<h' + heading + '>');
};

RE.setIndent = function() {
    document.execCommand('indent', false, null);
};

RE.setOutdent = function() {
    document.execCommand('outdent', false, null);
};

RE.setOrderedList = function() {
    document.execCommand('insertOrderedList', false, null);
};

RE.setUnorderedList = function() {
    document.execCommand('insertUnorderedList', false, null);
};

RE.setJustifyLeft = function() {
    document.execCommand('justifyLeft', false, null);
};

RE.setJustifyCenter = function() {
    document.execCommand('justifyCenter', false, null);
};

RE.setJustifyRight = function() {
    document.execCommand('justifyRight', false, null);
};

RE.getLineHeight = function() {
    return RE.editor.style.lineHeight;
};

RE.setLineHeight = function(height) {
    RE.editor.style.lineHeight = height;
};

RE.insertImage = function(url, alt) {
    RE.restorerange();
    var parentElement = getSelectionBoundaryElement("start");
    var img = document.createElement('img');
    img.setAttribute("src", url);
    img.setAttribute("alt", alt);
    img.setAttribute("height", defaultImageHeight)
    img.setAttribute("style","float:left")
    img.onload = RE.updateHeight;
    if (parentElement.id == "editor") {
        var wrapper = document.createElement('div');
        wrapper.appendChild(img);
        RE.insertHTML(wrapper.outerHTML);
    } else {
        RE.insertHTML(img.outerHTML);
    }
    
    RE.callback("input");
};

// Methods added by Diqing Chang, 07.11.2017
RE.increaseImageSizeOfSelectedDiv = function() {
    var editor = getSelectionBoundaryElement("start");
    //alert(editor.id);
    var images = editor.querySelectorAll("img");
    for (var i = 0; i < images.length; i++) {
        images[i].height = images[i].height + defaultImageSizeChangeRate;
    }
};

RE.decreaseImageSizeOfSelectedDiv = function() {
    var editor = getSelectionBoundaryElement("start");
    //alert(editor.id);
    var images = editor.querySelectorAll("img");
    for (var i = 0; i < images.length; i++) {
        images[i].height = images[i].height - defaultImageSizeChangeRate;
    }
};

function getSelectionBoundaryElement(isStart) {
    var range, sel, container;
    if (document.selection) {
        range = document.selection.createRange();
        range.collapse(isStart);
        return range.parentElement();
    } else {
        sel = window.getSelection();
        if (sel.getRangeAt) {
            if (sel.rangeCount > 0) {
                range = sel.getRangeAt(0);
            }
        } else {
            // Old WebKit
            range = document.createRange();
            range.setStart(sel.anchorNode, sel.anchorOffset);
            range.setEnd(sel.focusNode, sel.focusOffset);
            
            // Handle the case when the selection was selected backwards (from the end to the start in the document)
            if (range.collapsed !== sel.isCollapsed) {
                range.setStart(sel.focusNode, sel.focusOffset);
                range.setEnd(sel.anchorNode, sel.anchorOffset);
            }
        }
        
        if (range) {
            container = range[isStart ? "startContainer" : "endContainer"];
            
            // Check if the container is a text node and return its parent if so
            return container.nodeType === 3 ? container.parentNode : container;
        }
    }
}

RE.setBlockquote = function() {
    document.execCommand('formatBlock', false, '<blockquote>');
};

RE.insertHTML = function(html) {
    RE.restorerange();
    document.execCommand('insertHTML', false, html);
};

RE.insertLink = function(url, title) {
    RE.restorerange();
    var sel = document.getSelection();
    if (sel.toString().length !== 0) {
        if (sel.rangeCount) {

            var el = document.createElement("a");
            el.setAttribute("href", url);
            el.setAttribute("title", title);

            var range = sel.getRangeAt(0).cloneRange();
            range.surroundContents(el);
            sel.removeAllRanges();
            sel.addRange(range);
        }
    }
    RE.callback("input");
};

RE.prepareInsert = function() {
    RE.backuprange();
};

RE.backuprange = function() {
    var selection = window.getSelection();
    if (selection.rangeCount > 0) {
        var range = selection.getRangeAt(0);
        RE.currentSelection = {
            "startContainer": range.startContainer,
            "startOffset": range.startOffset,
            "endContainer": range.endContainer,
            "endOffset": range.endOffset
        };
    }
};

RE.addRangeToSelection = function(selection, range) {
    if (selection) {
        selection.removeAllRanges();
        selection.addRange(range);
    }
};

// Programatically select a DOM element
RE.selectElementContents = function(el) {
    var range = document.createRange();
    range.selectNodeContents(el);
    var sel = window.getSelection();
    // this.createSelectionFromRange sel, range
    RE.addRangeToSelection(sel, range);
};

RE.restorerange = function() {
    var selection = window.getSelection();
    selection.removeAllRanges();
    var range = document.createRange();
    range.setStart(RE.currentSelection.startContainer, RE.currentSelection.startOffset);
    range.setEnd(RE.currentSelection.endContainer, RE.currentSelection.endOffset);
    selection.addRange(range);
};

RE.focus = function() {
    var range = document.createRange();
    range.selectNodeContents(RE.editor);
    range.collapse(false);
    var selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    RE.editor.focus();
};

RE.focusAtPoint = function(x, y) {
    var range = document.caretRangeFromPoint(x, y) || document.createRange();
    var selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    RE.editor.focus();
};

RE.blurFocus = function() {
    RE.editor.blur();
};

/**
Recursively search element ancestors to find a element nodeName e.g. A
**/
var _findNodeByNameInContainer = function(element, nodeName, rootElementId) {
    if (element.nodeName == nodeName) {
        return element;
    } else {
        if (element.id === rootElementId) {
            return null;
        }
        _findNodeByNameInContainer(element.parentElement, nodeName, rootElementId);
    }
};

var isAnchorNode = function(node) {
    return ("A" == node.nodeName);
};

RE.getAnchorTagsInNode = function(node) {
    var links = [];

    while (node.nextSibling !== null && node.nextSibling !== undefined) {
        node = node.nextSibling;
        if (isAnchorNode(node)) {
            links.push(node.getAttribute('href'));
        }
    }
    return links;
};

RE.countAnchorTagsInNode = function(node) {
    return RE.getAnchorTagsInNode(node).length;
};

/**
 * If the current selection's parent is an anchor tag, get the href.
 * @returns {string}
 */
RE.getSelectedHref = function() {
    var href, sel;
    href = '';
    sel = window.getSelection();
    if (!RE.rangeOrCaretSelectionExists()) {
        return null;
    }

    var tags = RE.getAnchorTagsInNode(sel.anchorNode);
    //if more than one link is there, return null
    if (tags.length > 1) {
        return null;
    } else if (tags.length == 1) {
        href = tags[0];
    } else {
        var node = _findNodeByNameInContainer(sel.anchorNode.parentElement, 'A', 'editor');
        href = node.href;
    }

    return href ? href : null;
};

// Returns the cursor position relative to its current position onscreen.
// Can be negative if it is above what is visible
RE.getRelativeCaretYPosition = function() {
    var y = 0;
    var sel = window.getSelection();
    if (sel.rangeCount) {
        var range = sel.getRangeAt(0);
        var needsWorkAround = (range.startOffset == 0)
        /* Removing fixes bug when node name other than 'div' */
        // && range.startContainer.nodeName.toLowerCase() == 'div');
        if (needsWorkAround) {
            y = range.startContainer.offsetTop - window.pageYOffset;
        } else {
            if (range.getClientRects) {
                var rects=range.getClientRects();
                if (rects.length > 0) {
                    y = rects[0].top;
                }
            }
        }
    }

    return y;
};
