// Create a snippet on chrome developer options
(function () {

    'use strict';

})


// text = strongs[0].textContent;
// console.log(text);

// actions = document.getElementsByClassName("actions");
// console.log(actions);
// actions[0].appendChild(btn);



// for (let strong of strongs) {
//     console.log(strong.textContent);
// }
// for (let link of hyperlinks) {
//     console.log(link.textContent);
// }



//------------------------------------------------------------------
//------------------------------------------------------------------
//------------------------------------------------------------------

//Wait for the page to load before executing the function
window.addEventListener('load', function () {
    'use strict';
    let strongs = document.getElementsByTagName('strong');
    let hyperlinks = document.getElementsByTagName('a');
    let ems = document.getElementsByTagName('em');
    addNormalizeButton(strongs, hyperlinks, ems);

    const underlinedTexts = document.querySelectorAll('span[style*="text-decoration: underline"]');
    underlinedTexts.forEach(uText => uText.style.removeProperty('text-decoration'))

    //Copying to the clipboard doesn't work as desired yet
    this.navigator.clipboard.writeText(this.document.body.innerText);
});


let styleSheet = `
.copyBtn {
    background-color: green;
    padding: 9px;
    font-size: 12px;
}
`;
let s = document.createElement('style');
s.type = "text/css";
s.innerHTML = styleSheet;
(document.head || document.documentElement).appendChild(s);

//Adds the Remove Strongs button above the date element
function addNormalizeButton(strongs, hyperlinks, ems) {
    console.clear();

    let btn = document.createElement('BUTTON');
    btn.innerHTML = "Normalize";
    btn.onclick = () => {
        let count = 0;
        while (count < 9) {
            for (let strong of strongs) {
                replaceTagWithSpan(strong);
            }
            for (let link of hyperlinks) {
                replaceTagWithSpan(link);
            }
            for (let em of ems) {
                replaceTagWithSpan(em);
            }
            count = count + 1;
        }
    }

    let listTitle = document.getElementsByClassName("list-title");
    listTitle[0].insertBefore(document.createElement('br'), listTitle[0].firstChild);
    listTitle[0].insertBefore(btn, listTitle[0].firstChild);
}

//Replaces the strong with a span to remove the bold effect
function replaceTagWithSpan(element) {
    let span = document.createElement('span');

    for (const attr of element.attributes) {
        span.setAttributeNS(null, attr.name, attr.value);
    }
    span.innerHTML = element.innerHTML;

    element.parentNode.insertBefore(span, element);
    element.parentNode.removeChild(element);
}

//--------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------



//Copy text from an element, possible only from a editable element
// navigator.clipboard.writeText(temp.value); 
function copy(ele) {
    let temp = document.createElement('textarea');
    document.body.appendChild(temp);
    temp.value = ele.textContent;
    temp.select();
    document.execCommand('copy');
    temp.remove();
}