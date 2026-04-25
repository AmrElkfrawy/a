"""
Django command to pause execution until the database is available.
"""

from django.core.management.base import BaseCommand
from psycopg2 import OperationalError as Psycopg2Error
from django.db.utils import OperationalError
import time


class Command(BaseCommand):
    """Django command to pause execution until the database is available."""

    def handle(self, *args, **options):
        """Entrypoint for the command."""
        self.stdout.write("Waiting for database...")
        db_up = False
        while not db_up:
            try:
                self.check(databases=["default"])
                db_up = True
            except (Psycopg2Error, OperationalError) as e:
                self.stdout.write(
                    f"Database unavailable,\
waiting 1 second... ({e})"
                )
                time.sleep(1)
        self.stdout.write(self.style.SUCCESS("Database available!"))
