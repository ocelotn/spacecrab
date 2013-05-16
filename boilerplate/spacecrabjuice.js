
$(function(){
	alert($('div[class="story"] a[data-dest1]').text);
});

$(document).ready(function() {
   chooseALink();
 });

//Sets up accordion
$(function() 
{
	$( "#storywrapper" ).accordion(
	{
		collapsible: true,
		heightStyle: "content"
	});
});

//Save button which calls savesys
$( "button.save" )
.button()
.click(function() {
//Checks if browser supports this type of save
	if(typeof(Storage)!=="undefined")
		{
		// Saves data in save
				localStorage.setItem('saveCrab', ($('body').clone().html()));
				
				//Should tell what is actually in the savefile
//				alert( JSON.parse(JSON.stringify(localStorage.getItem('saveCrab'))));
		}
		// If browser dont support it, then can't save
		else
		  {
				alert("Sorry, your browser does not support web storage");
		  }
});

//Load button which loads
$( "button.load" )
.button()
.click(function() {
	//Checks if there is a save called saveCrab
	if(localStorage.getItem('saveCrab') != null)
		{
		// Loads data from variable save and replaces the body
			document.body.innerHTML = localStorage.getItem('saveCrab');
			var body= document.getElementsByTagName('body')[0];
			var script= document.createElement('script');
			script.id = 'theend';
			script.type= 'text/javascript';
			script.src= 'boilerplate/spacecrabjuice.js';
			body.appendChild(script);
		}
		// If browser dont support it, then can't save/load
	else
	  {
			alert("Sorry, no saves detected");
	  }
});


//Should restart the game by calling spacecrab.pl?0
$( "button.startOver" )
.button()
.click(function() 
{
	var varAppend = "/spacecrab.pl?0"; 
	window.location.href = window.location.href.replace(".com",".com" + varAppend);
});


var $nodeNum = 1;

//Builds the extra tabs

$("a").live("click", function()  
	{
		this.preventDefault();
	//Append just adds the body
		$(document.getElementById("storywrapper")).append('<h></h><div><p$nodeNum></p$nodeNum></div>');

	//Loads data parsed from the .story in the spacecrabmeat into p
	//	$("p$nod").load("http://test.space-crab.com/spacecrabmeat.pl? .story");

		$("p#nodeNum").load($(this).attr("href") + " .story"); 
	
	//Reloads the accordion after all this work has been done
		$('#storywrapper').accordion("refresh");
	});


