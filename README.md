websocket4ie
============

基于flash内核，让ie6也能用websocket，完全回调js，flash不处理任何ui

服务端,可以用我另外一个python写的websocket服务端


由于flash的socket需要一个843的端口验证,所以需要另开启一个服务,我用python写了个,你要修改一下,然后跑起来


其它看test.htm




还有一个问题，默认的websocket是mask的，但是我这儿模拟的时候并没有mask，所以需要服务端在处理数据的时候对mask判断一下



在flash里,是否将缓存的数据buffer在每读一个数据块的时候清掉?
