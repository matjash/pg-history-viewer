# global

PLUGINNAME = pg_history_viewer

PY_FILES = main.py __init__.py event_dialog.py config_dialog.py error_dialog.py connection_wrapper.py credentials_dialog.py

EXTRAS = metadata.txt icons

UI_FILES = event_dialog.ui config.ui error_dialog.ui credentials_dialog.ui

VERSION=$(shell grep "version=" metadata.txt | cut -d'=' -f 2)

%.qm : %.ts
	lrelease $<

# The deploy  target only works on unix like operating system where
# the Python plugin directory is located at:
# $HOME/.qgis2/python/plugins
PLUGINDIR=$(HOME)/.qgis2/python/plugins/$(PLUGINNAME)
#PLUGINDIR=$(HOME)/.qgis-dev/python/plugins/$(PLUGINNAME)
deploy: transcompile
	mkdir -p $(PLUGINDIR)
	cp -vf $(PY_FILES) $(PLUGINDIR)
	cp -vf $(UI_FILES) $(PLUGINDIR)
	cp -p -vfRa $(EXTRAS) $(PLUGINDIR)

# The zip target deploys the plugin and creates a zip file with the deployed
# content. You can then upload the zip file on http://plugins.qgis.org
zip: deploy
	echo $(VERSION)
	rm -f $(PLUGINNAME)*.zip
	cd $(HOME)/.qgis2/python/plugins; zip -9r $(CURDIR)/$(PLUGINNAME)-$(VERSION).zip $(PLUGINNAME)

# transup
# update .ts translation files
transup:
	pylupdate5 Makefile

# transcompile
# compile translation files into .qm binary format
transcompile: $(TRANSLATIONS:.ts=.qm)

# transclean
# deletes all .qm files
transclean:
	rm -f i18n/*.qm

clean:
	rm $(UI_FILES) $(RESOURCE_FILES)
