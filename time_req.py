import urllib2
import time

opener = urllib2.build_opener()
request = urllib2.Request('http://example.com')

start = time.time()
resp = opener.open(request)
# read one byte
resp.read(1)
ttfb = time.time() - start
# read the rest
resp.read()
ttlb = time.time() - start