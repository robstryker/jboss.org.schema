#!/bin/sh
du -ah | grep "index.html" | cut -f 2 | awk '{ print "rm \"" $0 "\"";}' | sh

