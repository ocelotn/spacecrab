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

function copier()
//Copies everything in the body for saving and loading
{
	var screenCopy = $('body').clone().html();
    return screenCopy;
}
		
function saveSys()
{
//Checks if browser supports this type of save
if(typeof(Storage)!=="undefined")
  	{
	// Saves data in save
	        localStorage.setItem('saveCrab', copier());
			
			//Should tell what is actually in the savefile
			alert( JSON.parse(JSON.stringify(localStorage.getItem('saveCrab'))));
	}
	// If browser dont support it, then can't save
	else
	  {
			alert("Sorry, your browser does not support web storage");
	  }
}

function loadSys()
{
//Checks if there is a save called saveCrab
if(localStorage.getItem('save') != null)
  	{
	// Loads data from variable save and replaces the body
		document.body.innerHTML = localStorage.getItem('saveCrab');
  	}
	// If browser dont support it, then can't save/load
else
  {
		alert("Sorry, no saves detected");
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
 
$function()
{
	alert("function has been called =)");
	for (thing in $('a.story')){		
		if $(thing.find('data-dest2'))
		{
			var result = Math.floor(Math.random()*2);	//generates either 1 or 0.
			alert("result = " + result);
			if(result == 1){
				$(thing).attr("href", "spacecrab.pl?" + data-dest2);
				alert("result = " + result);
			}
			else
			{
				alert("result != 1 ");
			}
		}
		else
		{
			$(thing).attr("href", "spacecrab.pl?" + data-dest1);
			alert("result != 1 it was " + result);
		}
	}
}

//Generates n Coinflips
function coinflip(int flipCount)
{
	while (flipCount!=0)
	{
		flipCount--;
		return Math.floor(Math.random()*2);
	}
}
