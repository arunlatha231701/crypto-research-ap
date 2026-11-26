from django.urls import path

from .views import (
    market_coins,
    global_market_stats,
)

urlpatterns = [
    path("coins/", market_coins, name="market-coins"),
    path("global/", global_market_stats, name="global-market-stats"),
]