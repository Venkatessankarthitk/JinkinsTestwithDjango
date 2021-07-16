from django.urls import path

from expenses.views import ExpensesPage, dashboard, purchase_item

from . import views

urlpatterns = [
    # path('', views.index, name='index'),
    path("", ExpensesPage.as_view(), name="home"),
    path("dashboard", dashboard.as_view(), name="dashboard"),
    path("purchase_items/", views.purchase_item),
    path("abcd/", views.abcd),
    path("expenses", views.expenses),
]
