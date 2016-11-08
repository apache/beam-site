"""Script to fix the links in the staged website.

Usage:
  From root directory, after running the jekyll build, execute
  'python tools/fix_links.py'.

Dependencies:
  beautifulsoup4
  Installable via pip as 'sudo pip install beautifulsoup4' or apt via
  'sudo apt-get install python-beautifulsoup4'.

"""

import fnmatch
import os
import re
from bs4 import BeautifulSoup

linkMatch = r'^\/(.*\.(?!([a-zA-Z0-9]+)$))?[^.]*$'
anchorMatch1 = r'(.+\/)(#[^\/]+$)'
anchorMatch2 = r'(.+\/[a-zA-Z0-9]+)(#[^\/]+$)'

matches = []
for root, dirnames, filenames in os.walk('content'):
  for filename in fnmatch.filter(filenames, '*.html'):
    if 'javadoc' not in root:
      matches.append(os.path.join(root, filename))

print 'Matches: ' + str(len(matches))
for match in matches:
  print 'Fixing links in: ' + match
  mf = open(match)
  soup = BeautifulSoup(mf)
  for a in soup.findAll('a'):
    try:
      hr = a['href']
      if re.match(linkMatch, hr) is not None:
        if hr.endswith('/'):
          a['href'] = hr + 'index.html'
        elif re.match(anchorMatch1, hr) is not None:
          mat = re.match(anchorMatch1, hr)
          a['href'] = mat.group(1) + 'index.html' + mat.group(2)
        elif re.match(anchorMatch2, hr) is not None:
          mat = re.match(anchorMatch2, hr)
          a['href'] = mat.group(2) + '/index.html' + mat.group(2)
        else:
          a['href'] = hr + '/index.html'
        mf.close()

        html = soup.prettify("utf-8")
        with open(match, "wb") as f:
          print 'Replacing ' + hr + ' with: ' + a['href']
          f.write(html)
    except KeyError as e:
      continue
