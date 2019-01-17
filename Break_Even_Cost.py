## This is for creating a model for various break-even points of
## my business plan.

import random

num_mets = int(input("How many meteorologists are forecasting?"))

payout_rate = input("What is the payment amount to the company?")

if payout_rate[-1] == "%":
    percent = int(payout_rate[:-1]) / 100.
    base_amount = 0
else:
    percent = 0
    base_amount = float(payout_rate)

del(payout_rate)

print(percent, base_amount)

## Now we start checking break-even numbers.

revenue = 50000

if base_amount == 0:
    number_customers = (revenue / percent)
else:
    payout_met, payout_customer, number_customers = 0, 0, 0
    distribution = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    while payout_met < 50000:
        payment = int(random.gauss(3, 3) // 1)
        if payment < 1:
            payment = 1
        elif payment > 15:
            payment = 15

        payout_customer += payment - base_amount
        payout_met += base_amount
        number_customers += 1

        distribution[payment - 1] += 1

    print("Number customers:", number_customers, "& payout of", payout_met, payout_customer)
    print(distribution)

print(number_customers, (number_customers / 365), (number_customers / 3650))
