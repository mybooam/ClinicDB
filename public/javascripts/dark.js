function getWindowSize() {
  var myWidth = 0, myHeight = 0;
  if( typeof( window.innerWidth ) == 'number' ) {
    //Non-IE
    myWidth = window.innerWidth;
    myHeight = window.innerHeight;
  } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
    //IE 6+ in 'standards compliant mode'
    myWidth = document.documentElement.clientWidth;
    myHeight = document.documentElement.clientHeight;
  } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
    //IE 4 compatible
    myWidth = document.body.clientWidth;
    myHeight = document.body.clientHeight;
  }
  return [myWidth, myHeight];
}

function grayOut(vis, options) {
  // Pass true to gray out screen, false to ungray
  // options are optional.  This is a JSON object with the following (optional) properties
  // opacity:0-100         // Lower number = less grayout higher = more of a blackout 
  // zindex: #             // HTML elements with a higher zindex appear on top of the gray out
  // bgcolor: (#xxxxxx)    // Standard RGB Hex color code
  // box: true/false       // Whether to show a box with a spinning wheel
  // box_text: [text]	   // Text to display in the box
  // grayOut(true, {'zindex':'50', 'bgcolor':'#0000FF', 'opacity':'70'});
  // Because options is JSON opacity/zindex/bgcolor are all optional and can appear
  // in any order.  Pass only the properties you need to set.
  
  var options = options || {}; 
  var zindex = options.zindex || 50;
  var opacity = options.opacity || 70;
  var opaque = (opacity / 100);
  var bgcolor = options.bgcolor || '#000000';
  var box = options.box || false;
  var box_text = options.box_text || '';
  
  var dark=document.getElementById('darkenScreenObject');
  var box = document.getElementById('darkenScreenBox');
  
  if (!dark) {
    // The dark layer doesn't exist, it's never been created.  So we'll
    // create it here and apply some basic styles.
    // If you are getting errors in IE see: http://support.microsoft.com/default.aspx/kb/927917
    var tbody = document.getElementsByTagName("body")[0];
    var tnode = document.createElement('div');           // Create the layer.
        tnode.style.position='fixed';                 // Position absolutely
        tnode.style.top='0px';                           // In the top
        tnode.style.left='0px';                          // Left corner of the page
        tnode.style.overflow='hidden';                   // Try to avoid making scroll bars            
        tnode.style.display='none';                      // Start out Hidden
        tnode.id='darkenScreenObject';                   // Name it so we can find it later
    tbody.appendChild(tnode);                            // Add it to the web page
    dark=document.getElementById('darkenScreenObject');  // Get the object.
  }
  
  if (!box) {
  	var tbody = document.getElementsByTagName("body")[0];
    var tnode = document.createElement('div');           // Create the layer.
        tnode.style.position='fixed';                 // Position absolutely
        tnode.style.overflow='hidden';                   // Try to avoid making scroll bars            
        tnode.style.display='none';                      // Start out Hidden
        tnode.id='darkenScreenBox';                   // Name it so we can find it later
		tnode.appendChild(document.createTextNode(box_text));
		tnode.appendChild(document.createElement("br"));
	var img = document.createElement("IMG");
		img.src = "/images/spinner_48.gif";
		img.style.marginTop = "10px";
		tnode.appendChild(img);
    tbody.appendChild(tnode);                            // Add it to the web page
    box=document.getElementById('darkenScreenBox');  // Get the object.
  }
  
  if (vis) {
	size = getWindowSize();
	windowWidth = size[0];
	windowHeight = size[1];
	
    //set the shader to cover the entire page and make it visible.
    dark.style.opacity=opaque;                      
    dark.style.MozOpacity=opaque;                   
    dark.style.filter='alpha(opacity='+opacity+')'; 
    dark.style.zIndex=zindex;        
    dark.style.backgroundColor=bgcolor;  
    dark.style.width= windowWidth + "px";
    dark.style.height= windowHeight + "px";
	
	//set the box position
	box.style.opacity=1;                      
    box.style.MozOpacity=1;                   
    box.style.filter='alpha(opacity='+100+')'; 
    box.style.zIndex=zindex+1;
	box_width = 250;
	box_height = 100;
	box.style.top= Math.floor(windowHeight/2-box_height/2) + "px";
    box.style.left= Math.floor(windowWidth/2-box_width/2) + "px";
    box.style.width= box_width + "px";
    box.style.height= box_height + "px";
	
	box.style.display='block';
    dark.style.display='block';                          
  } else {
	box.style.display='none';
    dark.style.display='none';
  }
}