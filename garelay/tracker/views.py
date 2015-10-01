from django.http import HttpResponse
from django.views.decorators.cache import never_cache

PIXEL_GIF_DATA = ("R0lGODlhAQABAIAAAAAAAP///yH5"
                  "BAEAAAAALAAAAAABAAEAAAIBRAA7").decode('base64')


@never_cache
def tracker(request):
    return HttpResponse(PIXEL_GIF_DATA, content_type='image/gif')
