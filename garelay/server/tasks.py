from garelay import celery_app

from garelay.tracker.models import TrackingEvent


@celery_app.task(ignore_result=True)
def register_events():
    for event in TrackingEvent.objects.all().exclude(status='registered'):
        event.register()
        event.save()
