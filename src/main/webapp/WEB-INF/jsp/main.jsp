<!DOCTYPE html>
<html>

<head>
<style>
    svg {
      font: 10px sans-serif;
    }
    .line {
      fill: none;
      stroke: #000;
      stroke-width: 1.5px;
    }
    .axis path,
    .axis line {
      fill: none;
      stroke: #000;
      shape-rendering: crispEdges;
    }
</style>
</head>

<body>
	<!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
	<div id="player"></div>

	<script>
      // 2. This code loads the IFrame Player API code asynchronously.
      var tag = document.createElement('script');

      tag.src = "https://www.youtube.com/iframe_api";
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      // 3. This function creates an <iframe> (and YouTube player)
      //    after the API code downloads.
      var player;
      function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
          height: '360',
          width: '640',
          videoId: '1z1LcX2bPY0',
          events: {
            'onStateChange': onPlayerStateChange
          }
        });
      }

      // 4. The API will call this function when the video player is ready.
      function onPlayerReady(event) {
        event.target.playVideo();
      }

      // 5. The API calls this function when the player's state changes.
      //    The function indicates that when playing a video (state=1),
      //    the player should play for six seconds and then stop.
      var done = false;
      function onPlayerStateChange(event) {
        if (event.data == YT.PlayerState.PLAYING && !done) {
          setTimeout(stopVideo, 6000);
          done = true;
        }
      }
      function stopVideo() {
        player.stopVideo();
      }
      function play() {
    	  player.playVideo();
      }
    </script>
	<form>
		<input type='button' value='play' onclick='play()'> <input
			type='button' value='stop' onclick='stopVideo()'>
	</form>
	
	<!-- graph -->	
	<script src='https://d3js.org/d3.v3.min.js'></script>
    <script>
    /**
     * 
     */
    var signal = ${heartData}

    var n = 100;
    
    var random = d3.random.normal(0, 10),
        data = d3.range(1).map(random);
    
    
    
    var margin = {top: 20, right: 20, bottom: 20, left: 40},
        width = 960 - margin.left - margin.right,
        height = 300 - margin.top - margin.bottom;
     
    // set axis
    var x = d3.scale.linear()
        .domain([0, n - 1])
        .range([0, width]);
     
    var y = d3.scale.linear()
        .domain([0, 150])
        .range([height, 0]);
     
    var line = d3.svg.line()
        .x(function(d, i) { return x(i); })
        .y(function(d, i) { return y(d); });
     
    var svg = d3.select("body").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
     
    svg.append("defs").append("clipPath")
        .attr("id", "clip")
      .append("rect")
        .attr("width", width)
        .attr("height", height);
     
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + y(0) + ")")
        .call(d3.svg.axis().scale(x).orient("bottom"));
     
    svg.append("g")
        .attr("class", "y axis")
        .call(d3.svg.axis().scale(y).orient("left"));
     
    var path = svg.append("g")
        .attr("clip-path", "url(#clip)")
      .append("path")
        .datum(data)
        .attr("class", "line")
        .attr("d", line);
 
    tick();
    
    var a = 0;
    var f = 0;

     
    function tick() {
     
      f++;
      if (f<100){
    	// push a new data point onto the back
          data.push(signal[a]);
          a++;
          
      // redraw the line, and slide it to the left
      path
          .attr("d", line)
          .attr("transform", null)
        .transition()
          .duration(50)
          .ease("linear")
          .attr("transform", "translate(" + x(-1) + ",0)")
          .each("end", tick);
     
      }
      else{
    	// push a new data point onto the back
          data.push(signal[a]);
          a++;
          
      // redraw the line, and slide it to the left
      path
          .attr("d", line)
          .attr("transform", null)
        .transition()
          .duration(50)
          .ease("linear")
          .attr("transform", "translate(" + x(-1) + ",0)")
          .each("end", tick);
     
      // pop the old data point off the front
      data.shift();
      }
    }

</script>


</body>


</html>