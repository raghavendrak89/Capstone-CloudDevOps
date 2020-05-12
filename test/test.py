import unittest
from app import app


class TestHello(unittest.TestCase):
    def setUp(self):
        app.APP.testing = True
        self.app = app.APP.test_client()

    def test_hello(self):
        rv = self.app.get('/health')
        print(rv.status)
        self.assertEqual(rv.status, '200 OK')
        self.assertEqual(rv.data, b'UP')


if __name__ == '__main__':
    unittest.main()
