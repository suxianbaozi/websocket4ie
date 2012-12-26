var handlers = {
    'connects':[],
    'onClose':function(index,flag) {
        this.connects[index.replace("socket_","")].onClose();
    },
    'onConnect':function(index) {
        this.connects[index.replace("socket_","")].onConnect();
    },
    'onData':function(index,text) {
        this.connects[index.replace("socket_","")].onData(text);
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
    this.onClose  = function() {
        
    }
    this.onConnect = function() {
        
    }
    this.onData = function(text) {
        
    }
    this.init();
}
