
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny,IsAuthenticated

from core.responses import success_response, error_response
from .serializers import (
    RegisterSerializer,
    ChangeUsernameSerializer,
    ChangePasswordSerializer,
)


@api_view(["POST"])
@permission_classes([AllowAny])
def register(request):
    serializer = RegisterSerializer(data=request.data)

    if serializer.is_valid():
        user = serializer.save()

        return success_response(
            message="Account created successfully.",
            data={
                "user": {
                    "id": user.id,
                    "username": user.username,
                    "email": user.email,
                }
            },
            status_code=201,
        )

    return error_response(
        message="Registration failed.",
        status_code=400,
        errors=serializer.errors,
    )





@api_view(["POST"])
@permission_classes([AllowAny])
def login(request):
    username = request.data.get("username")
    password = request.data.get("password")

    if not username or not password:
        return error_response(
            message="Username and password are required.",
            status_code=400,
        )

    user = authenticate(
        request,
        username=username,
        password=password,
    )

    if user is None:
        return error_response(
            message="Invalid username or password.",
            status_code=401,
        )

    token, created = Token.objects.get_or_create(user=user)

    return success_response(
        message="Login successful.",
        data={
            "token": token.key,
            "user": {
                "id": user.id,
                "username": user.username,
                "email": user.email,
            },
        },
    )


@api_view(["PATCH"])
@permission_classes([IsAuthenticated])
def change_username(request):
    serializer = ChangeUsernameSerializer(
        data=request.data,
        context={"request": request},
    )

    if not serializer.is_valid():
        return error_response(
            message="Username update failed.",
            status_code=400,
            errors=serializer.errors,
        )

    user = request.user
    user.username = serializer.validated_data["username"]
    user.save(update_fields=["username"])

    return success_response(
        message="Username updated successfully.",
        data={
            "user": {
                "id": user.id,
                "username": user.username,
                "email": user.email,
            }
        },
    )


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def change_password(request):
    serializer = ChangePasswordSerializer(
        data=request.data,
        context={"request": request},
    )

    if not serializer.is_valid():
        return error_response(
            message="Password update failed.",
            status_code=400,
            errors=serializer.errors,
        )

    user = request.user
    user.set_password(
        serializer.validated_data["new_password"]
    )
    user.save(update_fields=["password"])

    return success_response(
        message="Password changed successfully.",
        data=None,
    )


@api_view(["GET"])
@permission_classes([IsAuthenticated])
def profile(request):
    user = request.user

    return success_response(
        message="User profile retrieved successfully.",
        data={
            "user": {
                "id": user.id,
                "username": user.username,
                "email": user.email,
            }
        },
    )
