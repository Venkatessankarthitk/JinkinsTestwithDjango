# Generated by Django 2.0.7 on 2018-07-13 17:55

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("expenses", "0002_auto_20180712_1215"),
    ]

    operations = [
        migrations.CreateModel(
            name="expenses_details",
            fields=[
                (
                    "id",
                    models.AutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("parchased_product", models.CharField(max_length=255)),
                ("parchased_price", models.CharField(max_length=255)),
                ("parchased_date", models.DateField()),
            ],
        ),
    ]
