// Public Functions:

// Reading and Writing Page-Header:
function WriteHeader() {
    var test = loadFile('/Assets/BaseFiles/TopBar.html')

    if(test != null){
        document.write(loadFile('/Assets/BaseFiles/TopBar.html'));
    } else {
        document.write('<div class="Header">\
                <h2 class="Header-Border" align="center">\
                    <a href="/"> <img src="/Assets/favicon.png" alt="Cute Pixelart Catgirl" style="width:55px;height:55px";></a>\
                    <a href="/">CatWithCode</a>\
                    <br>\
                    <br>\
                    <b>&nbsp;</b>\
                    <a href="/blog.html">BLOG</a>\
                    <b>&nbsp;</b>\
                    <a href="/privacy.html">PRIVACY</a>\
                    <b>&nbsp;</b>\
                    <a href="/license.html">LICENSE</a>\
                    <b>&nbsp;</b>\
                    <a href="/contact.html">CONTACT</a>\
                    <b>&nbsp;</b>\
                    <a href="https://catwithcode.moe/Feed/RSS.xml">📡&nbsp;RSS</a>\
                    <b>&nbsp;</b>\
                </h2>\
            </div>\
        ');
    }
}

// Reading and Writing Footer-Header:
function WriteFooter(dateText) {
    var test = loadFile('/Assets/BaseFiles/TopBar.html')

    if(test != null){
        document.write(loadFile('/Assets/BaseFiles/Footer.html').replace("###DATE_TEXT###", dateText));
    } else {
        var output = '<h5 class="Fooder">'
        .concat(dateText) // Date
            .concat('&nbsp;&nbsp;|&nbsp;&nbsp;')
                .concat('©️ CatWithCode') // Maker
                    .concat('&nbsp;&nbsp;|&nbsp;&nbsp;')
                        .concat('CC BY-NC-ND 4.0') // License
                            .concat('</h5>');
                            
        document.write(output);
    }
}


// Internel Functions:
function loadFile(filePath) {
    // Creating Request:
    var xmlhttp = new XMLHttpRequest();

    // Getting the File: 
    xmlhttp.open("GET", filePath, false);
    xmlhttp.send();

    // Retrun if the File was found, else do fallback:
    if (xmlhttp.status==200) {
        return xmlhttp.responseText;
    } else {
        return null;
    }
  }