.. Google Analytics Relay documentation master file, created by
   sphinx-quickstart on Fri Oct  2 14:24:05 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Google Analytics Relay
======================

.. image:: https://upload.wikimedia.org/wikipedia/commons/7/76/Guglielmo_Marconi_1901_wireless_signal.jpg
  :alt: first short wave transmissions over a long distance
  :target: https://en.wikipedia.org/wiki/International_broadcasting

Capture pageviews in a somewhat offline capacity. Store them temporarily
and relay them as batches to an upstream server (when connectivity is
available). The upstream server then registers these page views with
Google Analytics.

This works using a embedding a 1x1 pixel GIF image::

  +-------------+
  | Wifi Phone  |
  | / Client    |
  +-------------+
      |
    Local HTTP request
      |
      \/
  +-------------+
  | Application |
  +-------------+
      |
    timestamped pageview
      |
      \/
  +--------+                       +--------------+
  | Relay  | -> Batches relayed -> | Registration |
  | Server |    over terrible      | Server       |
  +--------+    Internets          +--------------+
                                          |
                                        Back dated Google Analytics
                                        page view registration
                                          |
                                          \/
                                      +-----------+
                                      | Google    |
                                      | Analytics |
                                      +-----------+

.. note::   Events are submitted to Google Analytics with a ``queue time``
            parameter set. Google Analytics gives no guarantees about events
            that are submitted with a queue time of more than 4 hours ago.

Proof
-----

.. image:: ./garelay.gif
  :alt: server, tracker & google analytics results
  :target: ./_images/garelay.gif

Embedding Directly
------------------
::

   <img src="http://garelay/tracker-<GA-TRACKING-CODE>.gif?dp=/mycurrent/page.html">

GARelay will automatically include the following parameters:

**uip**
  The registered REMOTE_ADDR
**dr**
  The HTTP Referer
**ul**
  The Accept Language

Any of the `Google Analytics tracking parameters <https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters>`_ can be passed along
to the GIF. If you use Javascript to generate the ``<img/>`` tag then you
can also include dynamic values such as device screen size.


Proxying via Nginx
------------------
::

   <img src="tracker-<GA-TRACKING-CODE>.gif">

Setting up Nginx to proxy anything matching ``tracker-(?P<tracking_id>[A-Za-z0-9\-]+)\.gif``
will result in the automatic inclusion of the Document Path parameter since the image
is loaded relative to the current path:

If you URL is ``http://www.example.com/mypage/hello/`` and you embed the img tag there it will result in
a ``dp`` (document path) value of ``mypage/hello/`` since the pixel is retrieved
from the URL::

  http://garelay/mypage/hello/tracker-<GA-TRACKING-CODE>.gif

Which sets the ``dp`` parameter.

Overriding Default Values
-------------------------

Any of the values specified as extra querystring parameters will override
the defaults.

Installation
------------

::

  $ virtualenv ve
  $ source ve/bin/activate
  (ve)$ pip install garelay

Run the Google Analytics registration server::

  (ve)$ django-admin runserver --settings=garelay.settings.production

Run the Google Analytics registration server::

  (ve)$ django-admin runserver --settings=garelay.settings.production

To relay the pageview events from the relay server to the registration server::

  (ve)$ GARELAY_SERVER=http://www.example.com/ django-admin \
    --settings=garelay.settings.production \
    relay_events

To register the relayed pageview events at Google Analytics::

  (ve)$ django-admin \
    --settings=garelay.settings.production \
    register_events
