from django.test import TestCase

# Create your tests here.
import unittest
from django.test import Client

class SimpleTest(unittest.TestCase):
    def test_details(self):
        client = Client()
        response = client.get('/purchase_items/')
        self.assertEqual(response.status_code, 200)

    def test_index(self):
        client = Client()
        response = client.get('purchase_items')
        self.assertEqual(response.status_code, 200)
