import json

from django.http import HttpResponseBadRequest


def server(request):
    try:
        tracking_event = json.loads(request.body)
    except ValueError:
        return HttpResponseBadRequest()

    TrackingEvent.objects.clone(tracking_event)
    # tracking_event.delay()
