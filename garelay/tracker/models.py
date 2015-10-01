from django.db import models


class TrackingEvent(models.Model):
    tracking_id = models.CharField(max_length=255)
    client_id = models.CharField(max_length=255)
    user_agent = models.TextField()
    data = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
