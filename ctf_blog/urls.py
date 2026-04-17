from django.contrib import admin
from django.urls import path, include

admin.site.site_header = "NEURAL_FEED :: ADMIN_PORTAL"
admin.site.site_title  = "NEURAL_FEED"
admin.site.index_title = "[ CTF_LAB CONTROL PANEL ]"

urlpatterns = [
    path('manage/', admin.site.urls),   # Django admin — jazzmin themed
    path('', include('blog.urls')),
]
