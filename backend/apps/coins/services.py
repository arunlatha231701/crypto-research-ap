
from integrations.coingecko.client import CoinGeckoClient
from integrations.coingecko.endpoints import (
    COIN_DETAILS,
    COINS_MARKETS,
    COIN_SEARCH,
    MARKET_CHART,
)


class CoinDetailsService:

    def __init__(self):
        self.client = CoinGeckoClient()

    def get_coin_details(self, coin_id):
        params = {
            "localization": False,
            "tickers": False,
            "market_data": True,
            "community_data": False,
            "developer_data": False,
            "sparkline": False,
        }

        endpoint = COIN_DETAILS.format(coin_id=coin_id)

        return self.client.get(endpoint, params=params)


class CoinService:

    ALLOWED_ORDERS = {
        "market_cap_desc",
        "market_cap_asc",
        "volume_desc",
        "volume_asc",
        "id_asc",
        "id_desc",
    }

    def __init__(self):
        self.client = CoinGeckoClient()

    def get_market_coins(
        self,
        currency="usd",
        order="market_cap_desc",
        per_page=20,
        page=1,
    ):
        if order not in self.ALLOWED_ORDERS:
            raise ValueError("Unsupported market sorting option.")

        params = {
            "vs_currency": currency,
            "order": order,
            "per_page": per_page,
            "page": page,
            "sparkline": False,
            "price_change_percentage": "24h",
        }

        return self.client.get(COINS_MARKETS, params=params)


class CoinSearchService:

    def __init__(self):
        self.client = CoinGeckoClient()

    def search_coins(self, query):
        params = {"query": query}

        result = self.client.get(
            COIN_SEARCH,
            params=params,
        )

        coins = result.get("coins", [])
        normalized_query = query.strip().lower()

        def search_priority(coin):
            name = coin.get("name", "").lower()
            symbol = coin.get("symbol", "").lower()

            if name == normalized_query:
                priority = 0
            elif symbol == normalized_query:
                priority = 1
            elif name.startswith(normalized_query):
                priority = 2
            elif normalized_query in name:
                priority = 3
            else:
                priority = 4

            rank = coin.get("market_cap_rank")

            return (
                priority,
                rank is None,
                rank if rank is not None else float("inf"),
            )

        coins.sort(key=search_priority)
        result["coins"] = coins[:10]

        return result


class CoinChartService:

    ALLOWED_RANGES = {
        "1d": 1,
        "1w": 7,
        "1m": 30,
        "1y": 365,
    }

    def __init__(self):
        self.client = CoinGeckoClient()

    @staticmethod
    def normalize_points(data):
        points = []

        for item in data or []:
            if not isinstance(item, (list, tuple)) or len(item) < 2:
                continue

            timestamp, value = item[0], item[1]

            if timestamp is None:
                continue

            points.append({
                "timestamp": int(timestamp),
                "value": float(value) if value is not None else None,
            })

        points.sort(key=lambda point: point["timestamp"])

        return points

    @staticmethod
    def calculate_summary(prices):
        valid_prices = [
            point["value"]
            for point in prices
            if point["value"] is not None
        ]

        if not valid_prices:
            return {
                "first_price": None,
                "latest_price": None,
                "absolute_change": None,
                "percentage_change": None,
            }

        first_price = valid_prices[0]
        latest_price = valid_prices[-1]

        absolute_change = latest_price - first_price

        percentage_change = (
            (absolute_change / first_price) * 100
            if first_price != 0
            else None
        )

        return {
            "first_price": first_price,
            "latest_price": latest_price,
            "absolute_change": absolute_change,
            "percentage_change": percentage_change,
        }

    def get_coin_chart(
        self,
        coin_id,
        currency="usd",
        period="1w",
    ):
        days = self.ALLOWED_RANGES.get(period)

        if days is None:
            raise ValueError("Unsupported chart period.")

        endpoint = MARKET_CHART.format(
            coin_id=coin_id
        )

        params = {
            "vs_currency": currency,
            "days": days,
        }

        result = self.client.get(
            endpoint,
            params=params,
        )

        prices = self.normalize_points(
            result.get("prices", [])
        )

        market_caps = self.normalize_points(
            result.get("market_caps", [])
        )

        total_volumes = self.normalize_points(
            result.get("total_volumes", [])
        )

        # Calculate chart summary once.
        summary = self.calculate_summary(prices)

        # Determine overall price trend.
        percentage_change = summary["percentage_change"]

        if percentage_change is None:
            trend = "unavailable"
        elif percentage_change > 0:
            trend = "up"
        elif percentage_change < 0:
            trend = "down"
        else:
            trend = "unchanged"

        # Prepare chart metadata.
        metadata = {
            "point_count": len(prices),
            "start_timestamp": (
                prices[0]["timestamp"] if prices else None
            ),
            "end_timestamp": (
                prices[-1]["timestamp"] if prices else None
            ),
            "trend": trend,
        }

        return {
            "coin_id": coin_id,
            "currency": currency,
            "period": period,
            "prices": prices,
            "market_caps": market_caps,
            "total_volumes": total_volumes,
            "summary": summary,
            "metadata": metadata,
        }
