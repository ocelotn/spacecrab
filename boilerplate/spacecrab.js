
function hideDiv()
//hide Div content
{ 
	if (document.getElementById) { // DOM3 = IE5, NS6 
	document.getElementById('hideShow').style.visibility = 'hidden'; 
	} 

	else {
	 
		if (document.layers) { // Netscape 4 
			document.hideShow.visibility = 'hidden'; 
		} 
		else { // IE 4 
			document.all.hideShow.style.visibility = 'hidden'; 
		} 
	} 
}

function showDiv()
//show Div content
{ 
	if (document.getElementById) { // DOM3 = IE5, NS6 
	document.getElementById('hideShow').style.visibility = 'visible'; 
	} 
	else { 
		if (document.layers) { // Netscape 4 
		document.hideShow.visibility = 'visible'; 
		} 
		else { // IE 4 
		document.all.hideShow.style.visibility = 'visible'; 
		} 
	} 
}

function chooseALink(){
   $("a").click(function() {
     //alert("Hello world!");
     var $destno = 1;
     if($(this).attr('data-dest2')){
     var $destno = Math.round(Math.random()+1);
	 }
	 $(this).attr('href','spacecrab.pl?'+$(this).attr('data-dest'+$destno));
   });
}

$(document).ready(function() {
   chooseALink();
 });
