from django.conf.urls import patterns, url

from .views import tracker


urlpatterns = patterns(
    '',
    url(r'^tracker\.gif', tracker, name='tracker'),
)
