
from django.urls import path

from .views import (
    coin_details,
    coin_market_list,
    coin_search,
    coin_chart,
)

urlpatterns = [
    path("market/", coin_market_list, name="coin-market-list"),
    path("search/", coin_search, name="coin-search"),
    path("<str:coin_id>/", coin_details, name="coin-details"),
    path("<str:coin_id>/chart/", coin_chart, name="coin-chart"),
]
