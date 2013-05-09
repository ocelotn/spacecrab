
//Sets up accordion
$(function() 
{
	$( "#storywrapper" ).accordion(
	{
		collapsible: true,
		heightStyle: "content"
	});
});

//Sets up sizing of accordion
$(function() 
{
	$( "#accordion-resizer" ).resizable(
	{
		minHeight: 240,
		minWidth: 300,
		resize: function() 
		{
			$( "#storywrapper" ).accordion( "refresh" );
		}
	}
);
});

//Converted copier function to be in jQuery
$(function copier() 
{
	var screenCopy = $('body').clone().html();
    return screenCopy;
});

//Converted save function to be in jQuery
$(function saveSys() 
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
});

//Converted load function to be in jQuery
$(function loadSys() 
{
//Checks if there is a save called saveCrab
if(localStorage.getItem('saveCrab') != null)
  	{
	// Loads data from variable save and replaces the body
		document.body.innerHTML = localStorage.getItem('saveCrab');
  	}
	// If browser dont support it, then can't save/load
else
  {
		alert("Sorry, no saves detected");
  }
});

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

//Builds the extra tabs
function builder($start)
{
//Append just adds the body
	$(document.getElementById("storywrapper")).append('<h[$start]></h[$start]><div><p></p></div>');

//Loads data parsed from the .story in the spacecrabmeat into p
	$("p").load("http://test.space-crab.com/spacecrabmeat.pl? .story");


//Reloads the accordion after all this work has been done
	$('#storywrapper').accordion("refresh");

//Refocuses on the newest panel
	$("#storywrapper" ).accordion( "option", "active", $start );
}

