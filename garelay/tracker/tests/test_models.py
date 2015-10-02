from django.test import TestCase
from django.utils import timezone
from ..models import TrackingEvent


class ModelTest(TestCase):

    def update_event_fields(self, event, **fields):
        defaults = {
            'tracking_id': 'tracking_id',
            'client_id': 'client_id',
            'user_agent': 'user_agent',
            'data': {
                'foo': 'bar'
            },
            'created_at': timezone.now(),
            'updated_at': timezone.now(),
            'captured_at': timezone.now(),
            'relayed_at': timezone.now(),
            'registered_at': timezone.now(),
        }
        defaults.update(fields)
        event.update_fields(defaults)
        return defaults

    def test_update_fields(self):
        event = TrackingEvent.objects.create(uuid='the-uuid')
        self.update_event_fields(event, id=-1, status='captured')
        self.assertTrue(event.tracking_id)
        self.assertTrue(event.client_id)
        self.assertTrue(event.user_agent)
        self.assertTrue(event.data)
        self.assertTrue(event.created_at)
        self.assertTrue(event.updated_at)
        self.assertTrue(event.captured_at)
        self.assertTrue(event.relayed_at)
        self.assertTrue(event.registered_at)
        self.assertNotEqual(event.status, 'captured')
        self.assertNotEqual(event.id, -1)

    def test_to_dict(self):
        event = TrackingEvent.objects.create(uuid='the-uuid')
        fields = self.update_event_fields(event)
        self.assertNotEqual(
            event.to_dict(),
            fields)
