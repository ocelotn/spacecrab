
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

//Save button which calls savesys
$( "button.save" )
.button()
.click(function() {
$(this).ready.load('spacecrab.pl?0');
saveSys();
});

//Load button which calls loadsys
$( "button.save" )
.button()
.click(function() {
$(this).ready.load('spacecrab.pl?0');
loadSys();
});

//Should restart the game by calling spacecrab.pl?0
$( "button.startOver" )
.button()
.click.load('spacecrab.pl?0');
