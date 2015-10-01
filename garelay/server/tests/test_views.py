from django.test import TestCase
from django.test.client import Client


class ServerTest(TestCase):

    def setUp(self):
        self.client = Client()

    def test_tracking_event(self):
        pass
