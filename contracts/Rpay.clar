;; File: contracts/recurring-payments.clar

;; Define data variables to store recurring payment settings.
(define-data-var admin principal tx-sender) ;; Admin/owner of the contract
(define-data-var recipient principal tx-sender) ;; Recipient of payments
(define-data-var payment-amount uint u0) ;; Amount to be transferred in each payment
(define-data-var payment-interval uint u0) ;; Interval between payments in seconds
(define-data-var next-payment-time uint u0) ;; Timestamp for the next payment

;; Error codes
(define-constant ERR-UNAUTHORIZED (err u401))
(define-constant ERR-INVALID-AMOUNT (err u402))
(define-constant ERR-INVALID-INTERVAL (err u403))
(define-constant ERR-TRANSFER-FAILED (err u404))
(define-constant ERR-NOT-DUE (err u405))
(define-constant ERR-INVALID-PRINCIPAL (err u406))

;; Allow the admin to configure recurring payments.
(define-public (configure-recurring-payment (new-recipient principal) (amount uint) (interval uint))
  (begin
    ;; Ensure only the admin can configure the payment.
    (asserts! (is-eq tx-sender (var-get admin)) ERR-UNAUTHORIZED)
    
    ;; Check for valid amount and interval
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (> interval u0) ERR-INVALID-INTERVAL)
    
    ;; Validate the new recipient principal
    (asserts! (is-valid-principal? new-recipient) ERR-INVALID-PRINCIPAL)
    
    ;; Set the new configuration
    (var-set recipient new-recipient)
    (var-set payment-amount amount)
    (var-set payment-interval interval)
    (var-set next-payment-time (+ stacks-block-height interval))
    
    (ok true)
  )
)

;; Execute a recurring payment.
(define-public (make-payment)
  (let ((current-time stacks-block-height)
        (next-payment (var-get next-payment-time))
        (amount (var-get payment-amount))
        (payment-recipient (var-get recipient)))
    
    ;; Check if it's time for the next payment.
    (asserts! (>= current-time next-payment) ERR-NOT-DUE)
    
    ;; Perform the STX transfer and update the next payment time.
    (match (stx-transfer? amount tx-sender payment-recipient)
      success (begin
                (var-set next-payment-time (+ current-time (var-get payment-interval)))
                (ok true))
      error ERR-TRANSFER-FAILED
    )
  )
)

;; Allow the admin to update the recipient.
(define-public (update-recipient (new-recipient principal))
  (begin
    ;; Ensure only the admin can update the recipient.
    (asserts! (is-eq tx-sender (var-get admin)) ERR-UNAUTHORIZED)
    
    ;; Validate the new recipient principal
    (asserts! (is-valid-principal? new-recipient) ERR-INVALID-PRINCIPAL)
    
    ;; Update the recipient
    (var-set recipient new-recipient)
    (ok true)
  )
)

;; Allow the admin to stop payments by resetting variables.
(define-public (stop-payments)
  (begin
    ;; Ensure only the admin can stop payments.
    (asserts! (is-eq tx-sender (var-get admin)) ERR-UNAUTHORIZED)
    
    ;; Reset payment details.
    (var-set recipient tx-sender)
    (var-set payment-amount u0)
    (var-set payment-interval u0)
    (var-set next-payment-time u0)
    (ok true)
  )
)

;; Helper function to check if a principal is valid
(define-private (is-valid-principal? (principal principal))
  (is-ok (principal-destruct? principal))
)

