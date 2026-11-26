class CoinGeckoException(Exception):
    """Base exception for CoinGecko integration."""


class CoinGeckoAuthenticationError(CoinGeckoException):
    """Raised when API authentication fails."""


class CoinGeckoRateLimitError(CoinGeckoException):
    """Raised when API rate limit is exceeded."""


class CoinGeckoAPIError(CoinGeckoException):
    """Raised when CoinGecko returns an API error."""


class CoinGeckoConnectionError(CoinGeckoException):
    """Raised when connection to CoinGecko fails."""

class CoinGeckoNotFoundError(CoinGeckoException):
    """Raised when the requested CoinGecko resource is not found."""
    pass