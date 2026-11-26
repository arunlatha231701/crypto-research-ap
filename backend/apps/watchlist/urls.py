from django.urls import path

from .views import watchlist_list, watchlist_remove

urlpatterns = [
    path("", watchlist_list, name="watchlist-list"),
    path("<int:item_id>/", watchlist_remove, name="watchlist-remove"),
]