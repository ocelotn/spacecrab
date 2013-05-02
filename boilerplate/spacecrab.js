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
if (coinFlip =="Heads")
{
    document.getElementById("StoryNode001");
}
else
{
    document.getElementById("StoryNode002");
}


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

function saveSys()
{
if(typeof(Storage)!=="undefined")
  	{
	// Saves data in testVar
	        localStorage.setItem('save', copier());
	}
	// If browser dont support it, then can't save
	else
	  {
	//If tacking on, probably ignore it or something since it can't save anyways
			alert("Sorry, your browser does not support web storage");
	  }
}

function loadSys()
{
//Checks if there is a save called save
if(localStorage.getItem("save") != null)
  	{
	// Loads data from variable save and replaces the body
		document.body.innerHTML = localStorage.getItem("save");
  	}
	// If browser dont support it, then can't save/load
else
  {
		alert("Sorry, no saves detected");
  }
}		

$(function() 
{
	$( "#accordion" ).accordion(
	{
		collapsible: true,
		heightStyle: "content"
	});
});

$(function() 
{
	$( "#accordion-resizer" ).resizable(
	{
		minHeight: 240,
		minWidth: 300,
		resize: function() 
		{
			$( "#accordion" ).accordion( "refresh" );
		}
	}
);
});



//Builds the extra tabs
function builder($start)
{
//Append just adds the body, might be a more efficient way to add this in
//Load loads data, figure out how to integrate from the loader backend
	$(document.getElementById("accordion")).append('<h[$start]></h[$start]><div><p></p></div>');

//Loads data parsed from the .story in the spacecrabmeat into p
	$("p").load("http://test.space-crab.com/spacecrabmeat.pl? .story");


//Reloads the accordion after all this work has been done
	$('#accordion').accordion("refresh");

//Refocuses on the newest panel
	$("#accordion" ).accordion( "option", "active", $start );
}