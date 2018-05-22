#!/usr/bin/env python

import time
import os
import glob
import shutil

DATE=time.strftime("%Y%m%d%H%M%S")
NW_CONFIG_PATH = "/etc/sysconfig/network-scripts"

def backup_config():
    backup_folder = NW_CONFIG_PATH + "/backup/" + DATE
    if not os.path.exists(backup_folder):
        os.makedirs(backup_folder)
    for f in glob.glob(NW_CONFIG_PATH + "/ifcfg-*"):
        shutil.copy(f, backup_folder)

backup_config()
