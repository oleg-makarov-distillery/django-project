from django.http import HttpResponse


def ok_view(request):
    return HttpResponse(status=200)
