# Recurring Payments (Rpay) Clarity Smart Contract
This Clarity smart contract facilitates recurring payments on the Stacks blockchain. It allows an administrator to configure payment details such as the recipient, amount, and interval between payments. The contract ensures only the authorized administrator can modify these settings.

# Features
Configurable Recurring Payments: Set the recipient, payment amount (in microSTX), and payment interval (in Stacks blocks).
Automated Payments: make-payment function allows anyone to trigger a payment if the designated interval has passed.
Admin Control: Only the contract administrator can configure, update, and stop payments.
Secure and Transparent: Leverages the security and transparency of the Stacks blockchain.
Error Handling: Includes error codes for unauthorized access, invalid inputs, and transfer failures.
How it Works
Configuration: The contract administrator uses configure-recurring-payment to set up the recurring payment details, including the recipient, amount, and interval.
Payment Trigger: Anyone can call the make-payment function. The contract checks if the current block height is greater than or equal to the next-payment-time.
Payment Execution: If the payment is due, the contract transfers the specified amount of STX from the contract's balance to the recipient's address.
Update Recipient: The administrator can update the recipient's address using the update-recipient function.
Stop Payments: The administrator can stop recurring payments using the stop-payments function. This resets the payment variables.
Public Functions
configure-recurring-payment (new-recipient principal) (amount uint) (interval uint): Configures the recurring payment. Only callable by the admin.
make-payment: Executes a payment if the interval has passed. Callable by anyone.
update-recipient (new-recipient principal): Updates the payment recipient. Only callable by the admin.
stop-payments: Stops recurring payments and resets payment variables. Only callable by the admin.

# Error Codes
ERR-UNAUTHORIZED (err u401): Unauthorized access.
ERR-INVALID-AMOUNT (err u402): Invalid payment amount.
ERR-INVALID-INTERVAL (err u403): Invalid payment interval.
ERR-TRANSFER-FAILED (err u404): STX transfer failed.
ERR-NOT-DUE (err u405): Payment not yet due.
ERR-INVALID-PRINCIPAL (err u406): Invalid principal provided.

#Deployment
clarinet contract deploy rpay

# Local Testing
clarinet console

# Contributing
Contributions are welcome! Please open an issue or submit a pull request.
