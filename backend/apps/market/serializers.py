
from rest_framework import serializers


# Validates cryptocurrency data received from CoinGecko
class MarketCoinSerializer(serializers.Serializer):
    id = serializers.CharField()
    symbol = serializers.CharField()
    name = serializers.CharField()
    image = serializers.URLField(allow_null=True)
    current_price = serializers.FloatField(allow_null=True)
    market_cap = serializers.FloatField(allow_null=True)
    market_cap_rank = serializers.IntegerField(allow_null=True)
    total_volume = serializers.FloatField(allow_null=True)
    high_24h = serializers.FloatField(allow_null=True)
    low_24h = serializers.FloatField(allow_null=True)
    price_change_percentage_24h = serializers.FloatField(allow_null=True)
    circulating_supply = serializers.FloatField(allow_null=True)


# Validates parameters received from Flutter


class MarketQuerySerializer(serializers.Serializer):

    SUPPORTED_CURRENCIES = [
        "usd",
        "inr",
        "eur",
        "gbp",
        "jpy",
        "aud",
        "cad",
        "chf",
        "cny",
        "sgd",
        "btc",
        "eth",
    ]

    currency = serializers.ChoiceField(
        choices=SUPPORTED_CURRENCIES,
        default="usd"
    )

    per_page = serializers.IntegerField(
        default=20,
        min_value=1,
        max_value=100
    )

    page = serializers.IntegerField(
        default=1,
        min_value=1
    )

    # Optional comma-separated CoinGecko coin IDs.
    ids = serializers.CharField(
        required=False,
        allow_blank=False,
        trim_whitespace=True
    )

    def validate_ids(self, value):
        coin_ids = [
            coin_id.strip().lower()
            for coin_id in value.split(",")
        ]

        if not coin_ids or any(not coin_id for coin_id in coin_ids):
            raise serializers.ValidationError(
                "Provide valid comma-separated coin IDs."
            )

        if len(coin_ids) > 100:
            raise serializers.ValidationError(
                "A maximum of 100 coin IDs is allowed."
            )

        if len(set(coin_ids)) != len(coin_ids):
            raise serializers.ValidationError(
                "Duplicate coin IDs are not allowed."
            )

        for coin_id in coin_ids:
            if not all(
                character.isalnum() or character == "-"
                for character in coin_id
            ):
                raise serializers.ValidationError(
                    f"Invalid coin ID: {coin_id}"
                )

        return coin_ids

class GlobalMarketStatsSerializer(serializers.Serializer):

    active_cryptocurrencies = serializers.IntegerField(
        required=False
    )

    markets = serializers.IntegerField(
        required=False
    )

    total_market_cap = serializers.DictField(
        required=False
    )

    total_volume = serializers.DictField(
        required=False
    )

    market_cap_percentage = serializers.DictField(
        required=False
    )

    market_cap_change_percentage_24h_usd = serializers.FloatField(
        required=False,
        allow_null=True
    )

    updated_at = serializers.IntegerField(
        required=False
    )