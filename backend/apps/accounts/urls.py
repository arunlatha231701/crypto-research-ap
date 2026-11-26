
from django.urls import path

from .views import (
    register,
    login,
    change_username,
    change_password,
    profile
)

urlpatterns = [
    path("register/", register, name="register"),
    path("login/", login, name="login"),
    path(
        "change-username/",
        change_username,
        name="change-username",
    ),
    path(
        "change-password/",
        change_password,
        name="change-password",
    ),
    path("profile/", profile, name="profile"),
]
