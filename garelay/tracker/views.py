from django.http import HttpResponse

PIXEL_GIF_DATA = ("R0lGODlhAQABAIAAAAAAAP///yH5"
                  "BAEAAAAALAAAAAABAAEAAAIBRAA7").decode('base64')


def tracker(request):
    return HttpResponse(PIXEL_GIF_DATA, content_type='image/gif')
