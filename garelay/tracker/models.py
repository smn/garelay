from uuid import uuid4
from django.db import models


class TrackingEvent(models.Model):
    source = models.CharField(max_length=255, choices=(
        ('tracker', 'Tracker'),
        ('server', 'Server'),
    ), null=False)
    uuid = models.CharField(max_length=255, default=lambda: uuid4().hex)
    tracking_id = models.CharField(max_length=255)
    client_id = models.CharField(max_length=255)
    user_agent = models.TextField()
    data = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = (('uuid', 'source'),)
