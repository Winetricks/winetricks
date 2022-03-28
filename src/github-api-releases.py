# pylint: disable=invalid-name
'''
Create a release using GitHub's API, and upload its assets
'''

# Homepage: https://github.com/josephbisch/test-releases-api/blob/master/github-api-releases.py
#
# Copyright:
#   Copyright (C) 2016 Joseph Bisch <joseph.bisch AT gmail.com>
#
# License:
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU Lesser General Public
#   License as published by the Free Software Foundation; either
#   version 2.1 of the License, or (at your option) any later
#   version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Lesser General Public License for more details.
#
#   You should have received a copy of the GNU Lesser General Public
#   License along with this program.  If not, see
#   <https://www.gnu.org/licenses/>.

import json
import sys
import os
import ntpath

from urllib.parse import urljoin

import mimetypes
import requests

GITHUB_API = 'https://api.github.com'

def check_status(res, j):
    '''
    Check that the HTTP server didn't return an error
    '''
    if res.status_code >= 400:
        msg = j.get('message', 'UNDEFINED')
        print(f'ERROR: {msg} / code {res.status_code}')
        return 1
    return 0


# pylint: disable=redefined-outer-name
def create_release(owner, repo, tag, token):
    '''
    Create the release on GitHub
    '''
    url = urljoin(GITHUB_API, '/'.join(['repos', owner, repo, 'releases']))
    headers = {'Authorization': token}
    data = {'tag_name': tag, 'name': tag, 'body': f'winetricks - {tag}'}
    res = requests.post(url, auth=(owner, token), data=json.dumps(data), headers=headers)

    j = json.loads(res.text)
    if check_status(res, j):
        return 1
    return 0

# pylint: disable=too-many-locals
def upload_asset(path, owner, repo, tag):
    '''
    Upload the asset to github
    '''
    token = os.environ['GITHUB_TOKEN']

    url = urljoin(GITHUB_API,
                  '/'.join(['repos', owner, repo, 'releases', 'tags', tag]))
    res = requests.get(url)

    j = json.loads(res.text)
    if check_status(res, j):
        # release must not exist, creating release from tag
        if create_release(owner, repo, tag, token):
            return 0
        else:
            # Need to start over with uploading now that release is created
            # Return 1 to indicate we need to run upload_asset again
            return 1
    upload_url = j['upload_url']
    upload_url = upload_url.split('{')[0]

    fname = ntpath.basename(path)
    with open(path, encoding="utf8") as f:
        contents = f.read()

    content_type = mimetypes.guess_type(path)

    headers = {'Content-Type': content_type, 'Authorization': token}
    params = {'name': fname}

    res = requests.post(upload_url, data=contents, auth=(owner, token),
                        headers=headers, params=params)

    j = json.loads(res.text)
    if check_status(res, j):
        return 0
    print(f'SUCCESS: {fname} uploaded')
    return 0

if __name__ == '__main__':
    path = sys.argv[1]
    owner = sys.argv[2]
    repo = sys.argv[3]
    tag = sys.argv[4]
    if not os.path.isabs(path):
        path = os.path.join(os.path.dirname(os.path.realpath(__file__)), path)
    RET = 1  # Run upload_asset at least once.
    while RET:
        RET = upload_asset(path, owner, repo, tag)
