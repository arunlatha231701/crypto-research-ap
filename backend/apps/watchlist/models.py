
from django.conf import settings
from django.db import models


class WatchlistItem(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="watchlist_items",
    )
    coin_id = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]
        constraints = [
            models.UniqueConstraint(
                fields=["user", "coin_id"],
                name="unique_user_watchlist_coin",
            )
        ]

    def __str__(self):
        return f"{self.user.username} - {self.coin_id}"
