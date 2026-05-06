"""APScheduler bootstrap for digest + analytics jobs.

Started on app lifespan startup, stopped on shutdown.
Single-replica safe; if you scale horizontally later, wrap each tick in a
pg_advisory_lock to dedupe.
"""
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger

from app.notifications.triggers import digest as digest_trigger
from app.notifications.triggers import analytics as analytics_trigger

_scheduler: AsyncIOScheduler | None = None


def start() -> None:
    global _scheduler
    if _scheduler is not None:
        return

    _scheduler = AsyncIOScheduler(timezone="UTC")

    # Daily digest tick — runs at the top of every UTC hour, sends to users
    # whose local hour matches their digest_hour.
    _scheduler.add_job(
        digest_trigger.run_hourly_digest_tick,
        CronTrigger(minute=0),
        id="digest_hourly",
        replace_existing=True,
        max_instances=1,
        coalesce=True,
    )

    # Daily analytics — 06:00 UTC
    _scheduler.add_job(
        analytics_trigger.run_analytics_tick,
        CronTrigger(hour=6, minute=10),
        id="analytics_daily",
        kwargs={"period": "daily"},
        replace_existing=True,
        max_instances=1,
        coalesce=True,
    )

    # Weekly analytics — Mondays 06:15 UTC
    _scheduler.add_job(
        analytics_trigger.run_analytics_tick,
        CronTrigger(day_of_week="mon", hour=6, minute=15),
        id="analytics_weekly",
        kwargs={"period": "weekly"},
        replace_existing=True,
        max_instances=1,
        coalesce=True,
    )

    # Monthly analytics — 1st of month 06:20 UTC
    _scheduler.add_job(
        analytics_trigger.run_analytics_tick,
        CronTrigger(day=1, hour=6, minute=20),
        id="analytics_monthly",
        kwargs={"period": "monthly"},
        replace_existing=True,
        max_instances=1,
        coalesce=True,
    )

    _scheduler.start()


def stop() -> None:
    global _scheduler
    if _scheduler is not None:
        _scheduler.shutdown(wait=False)
        _scheduler = None
