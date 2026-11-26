import logging

logger = logging.getLogger(__name__)
from rest_framework.decorators import (
    api_view,
    permission_classes,
)
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny

from .services import MarketService
from .serializers import (
    MarketCoinSerializer,
    MarketQuerySerializer,
    GlobalMarketStatsSerializer,
)

from integrations.coingecko.exceptions import (
    CoinGeckoAuthenticationError,
    CoinGeckoRateLimitError,
    CoinGeckoAPIError,
    CoinGeckoConnectionError,
)



@api_view(["GET"])
@permission_classes([AllowAny])
def market_coins(request):

    # Step 1: Validate incoming query parameters
    query_serializer = MarketQuerySerializer(
        data=request.query_params
    )

    if not query_serializer.is_valid():
        return Response({
            "success": False,
            "message": "Invalid query parameters",
            "errors": query_serializer.errors,
            "data": None
        }, status=status.HTTP_400_BAD_REQUEST)

    # Step 2: Get validated parameters
    params = query_serializer.validated_data

    try:
        service = MarketService()

        # Step 3: Fetch market coins
        coins = service.get_market_coins(
            currency=params["currency"],
            per_page=params["per_page"],
            page=params["page"],
            ids=params.get("ids"),
        )

        # Step 4: Validate CoinGecko response
        serializer = MarketCoinSerializer(
            coins,
            many=True
        )

        return Response({
            "success": True,
            "message": "Market data fetched successfully",
            "data": serializer.data
        }, status=status.HTTP_200_OK)

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

    
    
    except Exception :
        logger.exception("Unexpected error occurred in Market API")

        traceback.print_exc()

        return Response({
            "success": False,
            "message": "An unexpected server error occurred.",
           
            "data": None
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



@api_view(["GET"])
@permission_classes([AllowAny])
def global_market_stats(request):

    try:
        service = MarketService()

        result = service.get_global_market_data()

        global_data = result.get("data", {})

        serializer = GlobalMarketStatsSerializer(
            global_data
        )

        return Response({
            "success": True,
            "message": "Global market statistics fetched successfully",
            "data": serializer.data
        }, status=status.HTTP_200_OK)

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
        logger.exception(
            "Unexpected error occurred in Global Market Statistics API"
        )

        return Response({
            "success": False,
            "message": "An unexpected server error occurred.",
            "data": None
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)