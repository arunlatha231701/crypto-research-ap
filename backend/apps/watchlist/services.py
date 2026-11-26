
from .models import WatchlistItem


class WatchlistService:

    @staticmethod
    def get_user_watchlist(user):
        return WatchlistItem.objects.filter(user=user)

    @staticmethod
    def add_coin(user, coin_id):
        return WatchlistItem.objects.create(
            user=user,
            coin_id=coin_id,
        )

    @staticmethod
    def remove_coin(user, item_id):
        return WatchlistItem.objects.filter(
            user=user,
            id=item_id,
        ).delete()
