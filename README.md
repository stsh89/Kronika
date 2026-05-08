# Kronika

## How It Works

Add KronikaFembot to your Telegram group. Every user who wants time conversion registers their time zone (users should enter valid time zone, for example they can check correct time zone name [here](https://toolv.com/en/app/time-zone-list)):
```text
   /set Europe/Paris
```

Users can then write messages containing time:
```text
   Let's meet at 17:00
```

Kronika replies with converted times for all registered users in the chat.



## Supported Time Format

Kronika only detects time written in 24-hour format:

✅ Supported:
```text
09:30
17:00
23:45
```

❌ Not supported:
```text
5pm
5 PM
17
```

## Example workflow

```text
Alice:
/set Europe/Paris

Bob:
/set America/New_York

Charlie:
/set Asia/Tokyo
```

Later:
```text
Let's meet at 17:00
```

Kronika automatically responds with:
```text
17:00 Europe/Paris
11:00 America/New_York
00:00 Asia/Tokyo
```

If Bob no longer wants conversions:
```text
/unset
```
Future conversions will exclude Bob’s time zone. Also, if Bob mentions a time, Kronika will not respond.

