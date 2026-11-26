
import requests

from django.conf import settings

from .exceptions import (
    CoinGeckoAuthenticationError,
    CoinGeckoRateLimitError,
    CoinGeckoNotFoundError,
    CoinGeckoAPIError,
    CoinGeckoConnectionError,
)


class CoinGeckoClient:

    def __init__(self):
        self.base_url = settings.COINGECKO_BASE_URL
        self.api_key = settings.COINGECKO_API_KEY

        if not self.api_key:
            raise CoinGeckoAuthenticationError(
                "CoinGecko API key is not configured."
            )

        self.headers = {
            "accept": "application/json",
            "x-cg-demo-api-key": self.api_key,
        }

        self.timeout = 15

    def get(self, endpoint, params=None):

        url = f"{self.base_url}{endpoint}"

        try:
            response = requests.get(
                url,
                headers=self.headers,
                params=params,
                timeout=self.timeout,
            )

            if response.status_code in (401, 403):
                raise CoinGeckoAuthenticationError(
                    "CoinGecko authentication failed."
                )

            if response.status_code == 429:
                raise CoinGeckoRateLimitError(
                    "CoinGecko rate limit exceeded."
                )

            if response.status_code == 404:
                raise CoinGeckoNotFoundError(
                    "Requested CoinGecko resource was not found."
                )

            response.raise_for_status()

            try:
                return response.json()
            except ValueError as exc:
                raise CoinGeckoAPIError(
                    "Invalid JSON response from CoinGecko."
                ) from exc

        except requests.exceptions.Timeout as exc:
            raise CoinGeckoConnectionError(
                "CoinGecko request timed out."
            ) from exc

        except requests.exceptions.ConnectionError as exc:
            raise CoinGeckoConnectionError(
                "Unable to connect to CoinGecko."
            ) from exc

        except requests.exceptions.HTTPError as exc:
            raise CoinGeckoAPIError(
                "CoinGecko API request failed."
            ) from exc

        except requests.exceptions.RequestException as exc:
            raise CoinGeckoConnectionError(
                "An unexpected network error occurred."
            ) from exc
