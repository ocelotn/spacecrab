
//Set up buttons
function setupSaveButton()
{
   //Save button which calls savesys
   $( "button.save" ).button().click(function() {
   //Checks if browser supports this type of save
	   if(typeof(Storage)!=="undefined")
	   {
	   // Saves data in save
			localStorage.setItem('saveCrab', ($('body').clone().html()));
			alert('Saved the story so far');	
			//Should tell what is actually in the savefile
//				//alert( JSON.parse(JSON.stringify(localStorage.getItem('saveCrab'))));
	   }
	   // If browser dont support it, then can't save
	   else
	   {
			 alert("Sorry, your browser does not support web storage");
	   }
   });
}
function setupLoadButton()
{
   //Load button which loads
   $( "button.load" ).button().click(function() {
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
}
function setupRestartButton()
{
   //Should restart the game by calling spacecrab.pl?0
   $( "button.startOver" ).button().click(function() 
   {
	   var varAppend = "/spacecrab.pl?"; 
   //	window.location.href = window.location.href.replace(".com",".com" + varAppend);
	   window.location.href = 'spacecrab.pl?';
   });
}

//Set up display
function setupAccordioning()
{
    $('#storywrapper').prepend('<h></h>');
   //Sets up accordion
	$( "#storywrapper" ).accordion(
	{
		collapsible: true,
		heightStyle: "content",
		header:'h'
	});
};

//Massage Content
function setTabs(){
  //sets the tab index but browser variation and according ineractions not good
  var tabindex = 1;
  $('div.story:last a').each(function() {
       $(this).attr("tabindex", tabindex);
       tabindex++;
     });
}

function activateLinks(){
    $('div.story:last a').each(
       function(){
       $(this).click(function(event){
		  goSomewhere($(this));
		  return false;
       });
    });
   //setTabs();
}
function getHref(link){
     //get destination for this link
     var $destno = 1;
     if($(link).attr('data-dest2')){
     var $destno = Math.round(Math.random()+1);
      }
     //$(link).attr('href','spacecrab.pl?'+$(link).attr('data-dest'+$destno));
     return $(link).attr('data-dest'+$destno);
}
function appendNode(linkidstring){
    $.ajax({ 
		url: "http://test.space-crab.com/spacecrabmeat.pl?"+linkidstring,
		dataType: 'html',
        complete: function() {
        },
        success: function(content) {
            //get div corresponding to linkidstring
            //stick it in at the end of storywrapper and activate its links
		    var wrapper = $('#storywrapper');
		    $(wrapper).append('<h></h>'+$(content).prop('outerHTML'));
		    activateLinks();
        },
        error: function(err) {
            $('#storywrapper').append(
             '<div>Where, exactly, did you want me to go?</div>'
            );
        }
	});	
}
function updateGraphics(linkidstring){
       $.ajax({ 
		url: "http://localhost/~lara/spacecrabeyes.pl?"+linkidstring,
		dataType: 'html',
        complete: function() {
        },
        success: function(content) {
		    var scene = $('div.scene');
		    $(scene).html($(content).prop('outerHTML'));
        },
        error: function(err) {
        //alert("failed to get graphics"+err.responseText);
        }
	});	
}

function goSomewhere(link){
	//where are we going?
    var nodeDestination = getHref(link);
	//should we go there?        
    var ancest = $(link).closest('div');
    var target = $('div.story:last');
	if (ancest[0] === target[0]){
	   //if we are in the most recent node
       //get the link content and append it to story wrapper
       appendNode(nodeDestination);
    $("#storywrapper" ).accordion( "option", "active", false );
    $('#storywrapper').accordion("refresh");
       //update graphics
       updateGraphics(nodeDestination);
    }
    //update the accordioning
}

$(function(){
	setupAccordioning();
	setupLoadButton();
	setupSaveButton();
	setupRestartButton();
	activateLinks();
});
