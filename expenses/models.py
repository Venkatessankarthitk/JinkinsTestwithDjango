from django.db import models
# Create your models here.
class purchasing_items(models.Model):
	product_name = models.CharField(max_length=255)
	product_price = models.IntegerField()
	def __str__(self):
		return self.product_name

class source(models.Model):
	SOURCE_CHOICES = (
        ('DEBITCARD', 'Debitcard'),
        ('MONEY', 'Money'),
        ('CREDITCARD', 'Creditcard'),
        ('OTHERS', 'Others'),
    )
	source = models.CharField(
        max_length=12,
        choices=SOURCE_CHOICES,
        default='MONEY',
    )

class expenses_details(models.Model):
    parchased_product = models.CharField(max_length=255)
    parchased_price = models.IntegerField()
    parchased_date = models.DateTimeField('date')

    def __str__(self):
        return self.parchased_product
    
