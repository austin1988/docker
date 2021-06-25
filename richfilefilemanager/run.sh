#!/bin/sh

# https://github.com/psolom/RichFilemanager
# http://github.com/servocoder/RichFilemanager.git
1. obtain repo
git clone https://github.com/jsooter/RichFilemanager-Python3Flask.git
2. modify
sed -i 's/\.File/File/' RichFilemanager-Python3Flask/FlaskApp.py
sed -i 's/\.FileManager/FileManager/' RichFilemanager-Python3Flask/File.py
sed -i 's/\.FileManagerResponse/FileManagerResponse/' RichFilemanager-Python3Flask/FileManager.py

# modify below content
# diff RichFilemanager-Python3Flask-original/FileManager.py RichFilemanager-Python3Flask/FileManager.py
# 279,283c279,284
# <         if request.is_xhr:
# <             response = FileManagerResponse(path)
# <             response.set_response()
# <             return jsonify(response.response)
# <         else:
# ---
# >         #if request.is_xhr:
# >         #    response = FileManagerResponse(path)
# >         #    response.set_response()
# >         #    return jsonify(response.response)
# >         #else:
# >         if True:

3. step into container, then install lib
docker exec -ti richfilemanager-flask /bin/bash
pip3 install pillow
run docker-entrypoint.d/30-start-gunicorn.sh again

4. browser input http://10.10.1.205:18888, you can see HelloWorld
input http://10.10.1.205:18888/files/filemanager, you can see RichFilemanager-Python3Flask/file directory files
