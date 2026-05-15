# Kronika

## How It Works

Add KronikaFembot to your Telegram group. Every user who wants time conversion registers their time zone (users should enter valid time zone, or set it by their location in Kronika private chat):
```text
   /set Europe/Paris
```

Users can then write messages containing time:
```text
   Let's meet at 17:00
```

Kronika replies with local time converted by tg-time Telegram functionality

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
Alice:
Let's meet at 17:00
```

Kronika automatically responds with:
```text
Local time 17:00
```

If Alice no longer wants to trigger Kronika local time message:
```text
/unset
```

## 🛠️ Built With & Credits

This project is powered by the following excellent free-tier services:

| Service | Purpose | Description |
| :--- | :--- | :--- |
| [Upstash](https://upstash.com/) | Persist user time zone | Serverless Data Platform powering backend storage. |
| [Render](https://render.com/) | Hosting / Deployment | The cloud platform hosting bot server. |
| [GeoNames](https://www.geonames.org/) | Find time zone by location | Provides the database for location-based lookups. |

*Note: This project uses geographical data from GeoNames, which is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).*
