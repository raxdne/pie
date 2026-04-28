
# Setup of PIE WebUI

## PIE

	git clone https://github.com/raxdne/pie.git
	cd pie
	git checkout develop
	cp -r test ../develop

## https://jqueryui.com/download/

	mkdir code.jquery.com
	curl https://code.jquery.com/jquery-3.7.1.min.js -o code.jquery.com/jquery.js

## https://jqueryui.com/download/

	cd code.jquery.com
	unzip jquery-ui-1.14.2.custom.zip

### https://jquerymobile.com/

	wget https://jquerymobile.com/resources/download/jquery.mobile-1.4.5.zip
	mkdir -p code.jquery.com/mobile/1.4.5
	unzip -d code.jquery.com/mobile/1.4.5 jquery.mobile-1.4.5.zip
	curl https://code.jquery.com/jquery-1.11.3.min.js -o code.jquery.com/jquery-1.11.3.min.js

## https://github.com/swisnl/jQuery-contextMenu

	wget https://github.com/swisnl/jQuery-contextMenu/archive/refs/tags/2.10.0.zip
	unzip 2.10.0.zip

## [jquery.tablesorter](https://mottie.github.io/tablesorter/docs/#Download)

	wget https://github.com/Mottie/tablesorter/archive/master.zip
	unzip master.zip

## https://github.com/ajaxorg/ace

	git clone https://github.com/ajaxorg/ace-builds.git
	
