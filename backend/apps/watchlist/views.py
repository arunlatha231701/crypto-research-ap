
import logging

from django.db import IntegrityError
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated

from core.responses import success_response, error_response
from apps.coins.services import CoinDetailsService
from integrations.coingecko.exceptions import (
    CoinGeckoNotFoundError,
    CoinGeckoRateLimitError,
    CoinGeckoConnectionError,
    CoinGeckoAPIError,
    CoinGeckoAuthenticationError,
)

from .serializers import WatchlistItemSerializer
from .services import WatchlistService

logger = logging.getLogger(__name__)


@api_view(["GET", "POST"])
@permission_classes([IsAuthenticated])
def watchlist_list(request):

    if request.method == "GET":
        items = WatchlistService.get_user_watchlist(request.user)
        serializer = WatchlistItemSerializer(items, many=True)

        return success_response(
            message="Watchlist fetched successfully.",
            data=serializer.data,
        )

    coin_id = request.data.get("coin_id")

    if not isinstance(coin_id, str) or not coin_id.strip():
        return error_response(
            message="A valid coin_id is required.",
            status_code=status.HTTP_400_BAD_REQUEST,
        )

    coin_id = coin_id.strip().lower()

    # Validate the coin with CoinGecko
    try:
        CoinDetailsService().get_coin_details(coin_id)

    except CoinGeckoNotFoundError:
        return error_response(
            message="Invalid CoinGecko coin ID.",
            status_code=status.HTTP_404_NOT_FOUND,
        )

    except CoinGeckoRateLimitError:
        return error_response(
            message="CoinGecko rate limit exceeded. Please try again later.",
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
        )

    except CoinGeckoConnectionError:
        return error_response(
            message="Unable to connect to CoinGecko.",
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
        )

    except (CoinGeckoAPIError, CoinGeckoAuthenticationError):
        logger.exception("CoinGecko validation failed.")
        return error_response(
            message="Coin validation service is temporarily unavailable.",
            status_code=status.HTTP_502_BAD_GATEWAY,
        )

    # Save the validated coin
    try:
        item = WatchlistService.add_coin(request.user, coin_id)

    except IntegrityError:
        return error_response(
            message="This coin is already in your watchlist.",
            status_code=status.HTTP_409_CONFLICT,
        )

    serializer = WatchlistItemSerializer(item)

    return success_response(
        message="Coin added to watchlist successfully.",
        data=serializer.data,
        status_code=status.HTTP_201_CREATED,
    )


@api_view(["DELETE"])
@permission_classes([IsAuthenticated])
def watchlist_remove(request, item_id):

    deleted_count, _ = WatchlistService.remove_coin(
        request.user,
        item_id,
    )

    if deleted_count == 0:
        return error_response(
            message="Watchlist item not found.",
            status_code=status.HTTP_404_NOT_FOUND,
        )

    return success_response(
        message="Coin removed from watchlist successfully.",
    )
