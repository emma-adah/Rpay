# Recurring Payments Contract

This Clarity smart contract facilitates recurring payments on the Stacks blockchain.

## Features

- **Recurring Payments:**  Automatically sends payments at specified intervals.
- **Admin Controls:**  Allows an administrator to configure, pause/resume, update, and stop payments.
- **Input Validation:**  Ensures valid payment amounts, intervals, and recipient addresses.
- **Error Handling:** Provides specific error codes for easier debugging.
- **Pausable:** Payments can be paused and resumed by the admin.

## Public Functions

- `configure-recurring-payment (new-recipient principal) (amount uint) (interval uint)`: Configures the recurring payment settings. Only callable by the admin.
- `make-payment`: Executes a recurring payment if the scheduled time has passed.
- `pause-payments (pause bool)`: Pauses or resumes payments. Only callable by the admin.
- `update-payment-amount (amount uint)`: Updates the payment amount. Only callable by the admin.
- `update-payment-interval (interval uint)`: Updates the payment interval. Only callable by the admin.
- `update-recipient (new-recipient principal)`: Updates the payment recipient. Only callable by the admin.
- `stop-payments`: Stops recurring payments and resets contract variables. Only callable by the admin.


## Error Codes

- `ERR-UNAUTHORIZED (u401)`: Unauthorized access.
- `ERR-INVALID-AMOUNT (u402)`: Invalid payment amount.
- `ERR-INVALID-INTERVAL (u403)`: Invalid payment interval.
- `ERR-TRANSFER-FAILED (u404)`: STX transfer failed.
- `ERR-NOT-DUE (u405)`: Payment not yet due.
- `ERR-INVALID-PRINCIPAL (u406)`: Invalid principal address.
- `ERR-PAUSED (u407)`: Payments are paused.


## Deployment

```bash
clarinet contract deploy
