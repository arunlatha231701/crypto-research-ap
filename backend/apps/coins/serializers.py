
from rest_framework import serializers


class CoinDetailsSerializer(serializers.Serializer):

    id = serializers.CharField()
    symbol = serializers.CharField()
    name = serializers.CharField()
    description = serializers.DictField(required=False)
    image = serializers.DictField(required=False)
    market_data = serializers.DictField(required=False)

    market_cap_rank = serializers.IntegerField(
        allow_null=True,
        required=False
    )

    genesis_date = serializers.DateField(
        allow_null=True,
        required=False
    )


class CoinMarketSerializer(serializers.Serializer):

    id = serializers.CharField()
    symbol = serializers.CharField()
    name = serializers.CharField()
    image = serializers.URLField(allow_null=True)

    current_price = serializers.FloatField(allow_null=True)
    market_cap = serializers.FloatField(allow_null=True)
    market_cap_rank = serializers.IntegerField(allow_null=True)
    total_volume = serializers.FloatField(allow_null=True)

    price_change_percentage_24h = serializers.FloatField(
        allow_null=True,
        required=False
    )

    circulating_supply = serializers.FloatField(allow_null=True)
    total_supply = serializers.FloatField(allow_null=True)
    max_supply = serializers.FloatField(allow_null=True)


class CoinSearchSerializer(serializers.Serializer):

    id = serializers.CharField()
    name = serializers.CharField()
    symbol = serializers.CharField()

    market_cap_rank = serializers.IntegerField(
        allow_null=True,
        required=False
    )

    thumb = serializers.URLField(
        allow_null=True,
        required=False
    )

    large = serializers.URLField(
        allow_null=True,
        required=False
    )


class ChartDataPointSerializer(serializers.Serializer):

    timestamp = serializers.IntegerField()
    value = serializers.FloatField(allow_null=True)


class CoinChartMetadataSerializer(serializers.Serializer):

    point_count = serializers.IntegerField()

    start_timestamp = serializers.IntegerField(
        allow_null=True
    )

    end_timestamp = serializers.IntegerField(
        allow_null=True
    )

    trend = serializers.ChoiceField(
        choices=[
            "up",
            "down",
            "unchanged",
            "unavailable",
        ]
    )


class CoinChartSerializer(serializers.Serializer):

    coin_id = serializers.CharField()
    currency = serializers.CharField()
    period = serializers.CharField()

    prices = ChartDataPointSerializer(many=True)
    market_caps = ChartDataPointSerializer(many=True)
    total_volumes = ChartDataPointSerializer(many=True)

    summary = serializers.DictField()
    metadata = CoinChartMetadataSerializer()


class CoinChartQuerySerializer(serializers.Serializer):

    SUPPORTED_CURRENCIES = [
        "usd",
        "inr",
        "eur",
        "gbp",
    ]

    SUPPORTED_PERIODS = [
        "1d",
        "1w",
        "1m",
        "1y",
    ]

    currency = serializers.ChoiceField(
        choices=SUPPORTED_CURRENCIES,
        default="usd"
    )

    period = serializers.ChoiceField(
        choices=SUPPORTED_PERIODS,
        default="1w"
    )
