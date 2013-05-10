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

/*
			TODO:
			@JimPetko
			implement coinflips at loadtime to start, then try to use AJAX to intercept onclick and flip coin and direct them to resulting destination. 
			if( dest2 exists) flip a coin else{ flip a coin for dest 1) 
			
			JQuery
			$("#target").click(function() {
				
});

*/


//detects forks in the choices and redirects to random choice.
alert("js is being called correctly");
 
$(function()
{
	alert("function has been called =)");
    for (thing in $('a.story[data-dest2]'))
	{		
		var result = Math.floor(Math.random()*2);	//generates either 1 or 0.
		alert("after random gen - result = " + result);
		
		if(result == 1){
			$(thing).attr("href", "spacecrab.pl?" + data-dest2);
			alert("inside if statement - result = " + result);			
		}
	}
})

//Generates n Coinflips
function coinflip(int flipCount)
{
	while (flipCount!=0)
	{
		flipCount--;
		return Math.floor(Math.random()*2);
	}
}
