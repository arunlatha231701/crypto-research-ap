
import logging

from rest_framework.decorators import (
    api_view,
    permission_classes,
)
from rest_framework.response import Response
from rest_framework import status
from core.responses import success_response, error_response
from rest_framework.permissions import AllowAny

from .services import (
    CoinDetailsService,
    CoinService,
    CoinSearchService,
    CoinChartService,
)

from .serializers import (
    CoinDetailsSerializer,
    CoinMarketSerializer,
    CoinSearchSerializer,
    CoinChartSerializer,
    CoinChartQuerySerializer,
)

from integrations.coingecko.exceptions import (
    CoinGeckoAuthenticationError,
    CoinGeckoRateLimitError,
    CoinGeckoNotFoundError,
    CoinGeckoAPIError,
    CoinGeckoConnectionError,
)


logger = logging.getLogger(__name__)


# --------------------------------------------------
# Coin Details API
# --------------------------------------------------

@api_view(["GET"])
@permission_classes([AllowAny])
def coin_details(request, coin_id):

    try:
        service = CoinDetailsService()
        coin = service.get_coin_details(coin_id)

        serializer = CoinDetailsSerializer(coin)

        return success_response(
    message="Coin details fetched successfully",
    data=serializer.data,
    status_code=status.HTTP_200_OK,
)

    except CoinGeckoNotFoundError as exc:
        return error_response(
    message=str(exc),
    status_code=status.HTTP_404_NOT_FOUND,
)

    except CoinGeckoAuthenticationError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_502_BAD_GATEWAY)

    except CoinGeckoRateLimitError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_429_TOO_MANY_REQUESTS)

    except CoinGeckoConnectionError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_503_SERVICE_UNAVAILABLE)

    except CoinGeckoAPIError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_502_BAD_GATEWAY)

    except Exception:
        logger.exception("Unexpected error occurred in Coin Details API")

        return Response({
            "success": False,
            "message": "An unexpected server error occurred.",
            "data": None
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# --------------------------------------------------
# Coin Market List API
# --------------------------------------------------

@api_view(["GET"])
@permission_classes([AllowAny])
def coin_market_list(request):

    currency = request.query_params.get("currency", "usd").lower()
    order = request.query_params.get("order", "market_cap_desc")

    allowed_currencies = {"usd", "inr", "eur", "gbp"}
    allowed_orders = CoinService.ALLOWED_ORDERS

    if currency not in allowed_currencies:
        return Response({
            "success": False,
            "message": "Unsupported currency. Use USD, INR, EUR or GBP.",
            "data": None
        }, status=status.HTTP_400_BAD_REQUEST)

    if order not in allowed_orders:
        return Response({
            "success": False,
            "message": "Unsupported sorting option.",
            "data": None
        }, status=status.HTTP_400_BAD_REQUEST)

    try:
        per_page = int(request.query_params.get("per_page", 20))
        page = int(request.query_params.get("page", 1))

    except ValueError:
        return Response({
            "success": False,
            "message": "per_page and page must be valid integers.",
            "data": None
        }, status=status.HTTP_400_BAD_REQUEST)

    if not 1 <= per_page <= 100 or page < 1:
        return Response({
            "success": False,
            "message": (
                "per_page must be between 1 and 100, "
                "and page must be at least 1."
            ),
            "data": None
        }, status=status.HTTP_400_BAD_REQUEST)

    try:
        service = CoinService()

        coins = service.get_market_coins(
            currency=currency,
            order=order,
            per_page=per_page,
            page=page,
        )

        serializer = CoinMarketSerializer(coins, many=True)

        return Response({
            "success": True,
            "message": "Coin market list fetched successfully",
            "data": serializer.data
        }, status=status.HTTP_200_OK)

    except CoinGeckoNotFoundError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_404_NOT_FOUND)

    except CoinGeckoAuthenticationError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_502_BAD_GATEWAY)

    except CoinGeckoRateLimitError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_429_TOO_MANY_REQUESTS)

    except CoinGeckoConnectionError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_503_SERVICE_UNAVAILABLE)

    except CoinGeckoAPIError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_502_BAD_GATEWAY)

    except Exception:
        logger.exception("Unexpected error occurred in Coin Market List API")

        return Response({
            "success": False,
            "message": "An unexpected server error occurred.",
            "data": None
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# --------------------------------------------------
# Coin Search API
# --------------------------------------------------

@api_view(["GET"])
@permission_classes([AllowAny])
def coin_search(request):

    query = request.query_params.get("query", "").strip()

    if not query:
        return Response({
            "success": False,
            "message": "Search query is required.",
            "data": None
        }, status=status.HTTP_400_BAD_REQUEST)

    if len(query) < 2:
        return Response({
            "success": False,
            "message": "Search query must contain at least 2 characters.",
            "data": None
        }, status=status.HTTP_400_BAD_REQUEST)

    if len(query) > 100:
        return Response({
            "success": False,
            "message": "Search query cannot exceed 100 characters.",
            "data": None
        }, status=status.HTTP_400_BAD_REQUEST)

    try:
        service = CoinSearchService()
        result = service.search_coins(query)

        coins = result.get("coins", [])

        serializer = CoinSearchSerializer(
            coins,
            many=True
        )

        return Response({
            "success": True,
            "message": "Coin search completed successfully",
            "data": serializer.data
        }, status=status.HTTP_200_OK)

    except CoinGeckoNotFoundError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_404_NOT_FOUND)

    except CoinGeckoAuthenticationError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_502_BAD_GATEWAY)

    except CoinGeckoRateLimitError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_429_TOO_MANY_REQUESTS)

    except CoinGeckoConnectionError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_503_SERVICE_UNAVAILABLE)

    except CoinGeckoAPIError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_502_BAD_GATEWAY)

    except Exception:
        logger.exception("Unexpected error occurred in Coin Search API")

        return Response({
            "success": False,
            "message": "An unexpected server error occurred.",
            "data": None
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# --------------------------------------------------
# Coin Chart API
# --------------------------------------------------

@api_view(["GET"])
@permission_classes([AllowAny])
def coin_chart(request, coin_id):

    query_serializer = CoinChartQuerySerializer(
        data=request.query_params
    )

    if not query_serializer.is_valid():
        return Response({
            "success": False,
            "message": "Invalid chart query parameters.",
            "errors": query_serializer.errors,
            "data": None
        }, status=status.HTTP_400_BAD_REQUEST)

    params = query_serializer.validated_data

    try:
        service = CoinChartService()

        chart_data = service.get_coin_chart(
            coin_id=coin_id,
            currency=params["currency"],
            period=params["period"],
        )

        serializer = CoinChartSerializer(chart_data)

        return Response({
            "success": True,
            "message": "Coin price history fetched successfully.",
            "data": serializer.data
        }, status=status.HTTP_200_OK)

    except CoinGeckoNotFoundError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_404_NOT_FOUND)

    except CoinGeckoAuthenticationError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_502_BAD_GATEWAY)

    except CoinGeckoRateLimitError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_429_TOO_MANY_REQUESTS)

    except CoinGeckoConnectionError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_503_SERVICE_UNAVAILABLE)

    except CoinGeckoAPIError as exc:
        return Response({
            "success": False,
            "message": str(exc),
            "data": None
        }, status=status.HTTP_502_BAD_GATEWAY)

    except Exception:
        logger.exception("Unexpected error occurred in Coin Chart API")

        return Response({
            "success": False,
            "message": "An unexpected server error occurred.",
            "data": None
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
