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
		document.body.innerHTML = localStorage.getItem('saveCrab';
  	}
	// If browser dont support it, then can't save/load
else
  {
		alert("Sorry, no saves detected");
  }
}

//Save button which calls savesys
$( "button.save" )
.button()
.click(function() {
saveSys();
});

//Load button which calls loadsys
$( "button.load" )
.button()
.click(function() {
loadSys();
});

//Should restart the game by calling spacecrab.pl?0
$( "button.startOver" )
.button()
.click(function() {
//$(this).load('spacecrab.pl?0');
$(document).load('spacecrab.pl');
});

/*

           on_load -> find all the <a> inside div[class="story"] and for each link,
               -  if there is a data_dest2 then, if there is also a data_dest1, pick one of the two and set href inside that link to point to 
			   "spacecrab.pl?nodeID"  where nodeID is the id of the destination that your code selected.

			TODO:
			@JimPetko
			implement coinflips at loadtime to start, then try to use AJAX to intercept onclick and flip coin and direct them to resulting destination. 
			if( dest2 exists) flip a coin else{ flip a coin for dest 1) 
			
			JQuery
			$("#target").click(function() {
				
});

*/


//detects forks in the choices and redirects to random choice. 
$function()
{
	for ('a' : '.story'){		
		if ('a').find('data-dest2id')
		{
			var result = Math.floor(Math.random()*1);	//generates either 1 or 0.
			if(result == 1){
				('a').attr("href", "spacecrab.pl?" + data-dest2id);
			}
		}
		else
		{
			('a').attr("href", "spacecrab.pl?" + data-dest1id);
		}
	}
}

//Generates n Coinflips
function coinflip(int flipCount)
{
	while (flipCount!=0)
	{
		flipCount--;
		return Math.floor(Math.random()*1);
	}
}
