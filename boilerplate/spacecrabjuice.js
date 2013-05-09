
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

//Should restart the game by calling 
$( "button.startOver" )
.button()
.click(function() {
$(document).load('spacecrab.pl?0');
});