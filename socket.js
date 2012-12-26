var handlers = {
    'connects':[],
    'onClose':function(index,flag) {
        this.connects[index.replace("socket_","")].onclose();
    },
    'onConnect':function(index) {
        
        this.connects[index.replace("socket_","")].onopen();
    },
    'onData':function(index,text) {
        this.connects[index.replace("socket_","")].onmessage(text);
    },
    'debug':function(index,str) {
        console.log(str);
    }
};


function socket4ie() {
    this.debug = 0;
    this.init = function() {
        this.index = handlers.connects.length;
        handlers.connects.push(this);
    }
    this.connect = function(domain,port) {
        this.createFlash(domain,port);
    }
    this.createFlash = function(domain,port) {
        var html = '<object id="socket_'+this.index+'" type="application/x-shockwave-flash" data="websocket4ie.swf" width=0 height=0 class="swfupload">\
            <param name="wmode" value="window">\
            <param name="movie" value="websocket4ie.swf">\
            <param name="quality" value="high">\
            <param name="menu" value="false">\
            <param name="allowScriptAccess" value="always">\
            <param name="flashvars" value="movieName=socket_'+this.index+'&amp;handlers=handlers&amp;server='+domain+'&amp;port='+port+'&amp;debug='+this.debug+'"></object>';    
        var div = document.createElement('div');
        div.id = "flash_"+this.index;
        div.innerHTML = html;
        document.body.appendChild(div);
    }
    this.onclose  = function() {
        
    }
    this.onopen = function() {
        
    }
    this.onmessage = function(text) {
        
    }
    this.send = function(text) {
        this.callFlash("sendData",[text]);
    }
    
    
    this.callFlash = function (functionName, argumentArray) {
        argumentArray = argumentArray || [];
        
        var movieElement = document.getElementById("socket_"+this.index);
        
        var returnValue, returnString;
        
        // Flash's method if calling ExternalInterface methods (code adapted from MooTools).
        try {
                returnString = movieElement.CallFunction('<invoke name="' + functionName + '" returntype="javascript">' + __flash__argumentsToXML(argumentArray, 0) + '</invoke>');
                returnValue = eval(returnString);
        } catch (ex) {
                throw "Call to " + functionName + " failed";
        }
        

        return returnValue;
    };
    
    this.init();
}
