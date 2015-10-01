from django.conf.urls import patterns, url

from .views import tracker


urlpatterns = patterns(
    '',
    url(r'^(?P<tracking_id>[A-Za-z0-9\-]+)/(?P<path>.*)/?tracker\.gif',
        tracker, name='tracker'),
)
