WKWebViewLocal
==============

Example of WKWebView loading local files and calling between javascript and Objective-C.  
  
Local files are accessed via a minimal embedded http server to work around  
the current limitations of WKWebView in iOS8.x, ie:  

- WKWebView can only load local files from the tmp directory  
(files need to be copied, can be cleared by system).  

- WKWebView can load html strings, but local resources such  
as css and images wont load.  

