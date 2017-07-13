from django.http import HttpResponse


def ok_view(request):
    return HttpResponse("blue", status=200)
