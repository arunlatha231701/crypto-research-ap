
from rest_framework.response import Response


def success_response(
    message,
    data=None,
    status_code=200,
):
    """
    Return a standardized successful API response.
    """

    return Response(
        {
            "success": True,
            "message": message,
            "data": data,
        },
        status=status_code,
    )


def error_response(
    message,
    status_code=400,
    data=None,
    errors=None,
):
    """
    Return a standardized API error response.
    """

    response_data = {
        "success": False,
        "message": message,
        "data": data,
    }

    if errors is not None:
        response_data["errors"] = errors

    return Response(
        response_data,
        status=status_code,
    )
