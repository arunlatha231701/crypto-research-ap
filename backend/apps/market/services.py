
from integrations.coingecko.client import CoinGeckoClient
from integrations.coingecko.endpoints import (
    COINS_MARKETS,
    GLOBAL_MARKET_DATA,
)


class MarketService:

    def __init__(self):
        self.client = CoinGeckoClient()

    def get_market_coins(
        self,
        currency="usd",
        per_page=20,
        page=1,
        ids=None,
    ):

        params = {
            "vs_currency": currency,
            "order": "market_cap_desc",
            "sparkline": False,
            "price_change_percentage": "24h",
        }

        if ids:
            # Fetch only the requested cryptocurrencies.
            params["ids"] = ",".join(ids)

        else:
            # Preserve existing Market Explorer pagination.
            params["per_page"] = per_page
            params["page"] = page

        return self.client.get(
            COINS_MARKETS,
            params=params,
        )

    def get_global_market_data(self):

        return self.client.get(
            GLOBAL_MARKET_DATA
        )
