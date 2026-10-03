"""Session Replay: record and play back user sessions."""

FILTERS = ["country", "device", "event_name", "user_property", "rage_click"]


def list_replays(filters: dict):
    """Return replays matching the given filters."""
    return [f for f in filters if f in FILTERS]
