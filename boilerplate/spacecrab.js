/*

<div id="StoryNode001">
    Bob flipped a coin, what was the result?
</div>

<a href="" onclick="alert('Heads!')">Heads</a>

<a href="" onclick="alert('Tails!')">Tails</a>

*/
	
function randomNumGen()
// Generates Random # for dynamic story telling
{
	var coinFlip = Math.floor(Math.random()*2);
	var flipResult;
		if(coinFlip==1)
			flipResult = "Heads";
		else
			flipResult = "Tails";
}
//to branch different ranges, can be compressed into fewer lines
/* coinFlip undefined, not quite sure where this code is going
if (coinFlip =="Heads")
{
    document.getElementById("StoryNode001");
}
else
{
    document.getElementById("StoryNode002");
}
*/

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


		//available preview
		//http://jsfiddle.net/petko_james/nDMFG/3/


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
			
*/

$function(){
	for ('a' : 'story'){		//('#mydiv').find('.myclass');
		if ('a').find('data-dest2id')
		{
			('a').attr("href", "spacecrab.pl?" + data-dest2id); //add coinflip result here
		}
		else if ('a').find('data-dest1id')
		{
			('a').attr("href", "spacecrab.pl?" + data-dest1id); //here too
		}
	}
};