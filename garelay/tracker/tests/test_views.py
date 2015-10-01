from django.test import TestCase
from django.test.client import Client
from django.core.urlresolvers import reverse


class ViewsTest(TestCase):

    def setUp(self):
        self.client = Client()

    def test_tracker_response_headers(self):
        response = self.client.get(reverse('tracker'))
        self.assertEqual(response['Content-Type'], 'image/gif')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response['Cache-Control'], 'max-age=0')
        self.assertTrue(response['Expires'])
