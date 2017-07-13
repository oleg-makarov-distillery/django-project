from django.http import HttpResponse


def ok_view(request):
    return HttpResponse("green", status=200)
