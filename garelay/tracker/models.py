import json
import logging

from uuid import uuid4

from django.db import models
from django.utils import timezone

from UniversalAnalytics import Tracker


class TrackingEvent(models.Model):
    uuid = models.CharField(max_length=255, default=lambda: uuid4().hex)
    tracking_id = models.CharField(max_length=255)
    client_id = models.CharField(max_length=255)
    user_agent = models.TextField()
    data = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    captured_at = models.DateTimeField(null=True)
    relayed_at = models.DateTimeField(null=True)
    registered_at = models.DateTimeField(null=True)
    status = models.CharField(max_length=255, choices=(
        ('captured', 'Captured'),
        ('relayed', 'Relayed'),
        ('registered', 'Registered')
    ), null=True)

    class Meta:
        ordering = ['created_at']

    def update_fields(self, data):
        self.tracking_id = data['tracking_id']
        self.client_id = data['client_id']
        self.user_agent = data['user_agent']
        self.data = json.dumps(data['data'])
        self.captured_at = data['captured_at']
        self.relayed_at = data['relayed_at']
        self.registered_at = data['registered_at']

    def to_dict(self):
        return dict(
            (field.name, getattr(self, field.name))
            for field in self._meta.fields
            if field.name not in ['id', 'status'])

    def register(self):
        tracker = Tracker.create(self.tracking_id,
                                 client_id=self.client_id,
                                 user_agent=self.user_agent)
        data = json.loads(self.data)

        # back date
        delta = timezone.now() - self.captured_at
        if delta.seconds > (4 * 60 * 60):
            logging.warning('Queue time exceeds 4 hours, '
                            'may be ignored by Google Analytics.')

        data['qt'] = delta.total_seconds() * 1000  # GA requires milliseconds

        tracker.send('pageview', data)
        self.registered_at = timezone.now()
        self.status = 'registered'
