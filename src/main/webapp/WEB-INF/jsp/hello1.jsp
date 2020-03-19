<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
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
          height: '300',
          width: '600',
          videoId: 'PSKEmWhjqVU',
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
          done = true;
        }
      }
      function stopVideo() {
        player.stopVideo();
      }
      function playVideo() {
    	  player.playVideo();
    	  
      }
    </script>
	<form>
		<input type='button' id='btnPlay' value='play' onclick='playVideo()'> 
		<input type='button' id='btnStop' value='stop' onclick='stopVideo()'>
	</form>

<!-------------------- graph --------------------->

<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>

<figure class="highcharts-figure">
    <div id="container"></div>
    <p class="highcharts-description">
        Chart showing data updating every second, with old data being removed.
    </p>
</figure>

<script>

var length = ${length};
var timePlayed = ${timePlayed};
var samplingRate = length/timePlayed;
var cnt = 0;
console.log(samplingRate);

Highcharts.chart('container', {
    chart: {
        type: 'spline',
        animation: Highcharts.svg, // don't animate in old IE
        marginRight: 10,
        events: {
            load: function () {

                // set up the updating of the chart each second
                var series = this.series[0];
          	    var signal = ${heartData};
                var i = 0;
                
                btnPlay.onclick = function() {
                	player.playVideo();
                	setInterval(function () {
                    cnt += samplingRate;
                    var x = (new Date()).getTime(), // current time
                        y = signal[parseInt(cnt)];
                    series.addPoint([x, y], true, true);
                    i++;
                }, 1000);}
                
                
                
            }
        },
        
    },

    time: {
        useUTC: false
    },

    title: {
        text: 'Live random data'
    },

    accessibility: {
        announceNewData: {
            enabled: true,
            minAnnounceInterval: 15000,
            announcementFormatter: function (allSeries, newSeries, newPoint) {
                if (newPoint) {
                    return 'New point added. Value: ' + newPoint.y;
                }
                return false;
            }
        }
    },

    xAxis: {
        type: 'datetime',
        tickPixelInterval: 150
    },

    yAxis: {
        title: {
            text: 'Value'
        },
        plotLines: [{
            value: 0,
            width: 1,
            color: '#808080'
        }]
    },

    tooltip: {
        headerFormat: '<b>{series.name}</b><br/>',
        pointFormat: '{point.x:%Y-%m-%d %H:%M:%S}<br/>{point.y:.2f}'
    },

    legend: {
        enabled: false
    },

    exporting: {
        enabled: false
    },
    
    l: function() {
    	setInterval(function () {
            cnt += samplingRate;
            var x = (new Date()).getTime(), // current time
                y = signal[parseInt(cnt)];
            series.addPoint([x, y], true, true);
            i++;
        }, 1000);
    },

    series: [{
        name: 'Random data',
        data: (function () {
            // generate an array of random data
            var data = [],
            	time = (new Date()).getTime(),
                i;
            for (i = 0; i <= 10; i += 1) {
                data.push({
                	x: time + i*100,
                    y: 0
                });
            }
            return data;
        }())
    }]
});

</script>
</body>
</html>