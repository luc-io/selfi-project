# Telegram Payments Integration Guide

## Overview
This guide covers implementing payments for digital goods via Telegram's Bot API. For Selfi Bot, we use Telegram Stars (XTR) as the currency for all transactions.

## Key Implementation Steps

1. **Create Invoice**
   - Use `sendInvoice` method
   - Currency must be "XTR" for digital goods
   - Provider token can be empty for digital goods

2. **Handle Pre-Checkout**
   - Bot receives `pre_checkout_query`
   - Must respond within 10 seconds using `answerPrecheckoutQuery`
   - Include user-friendly error messages if order cannot be processed

3. **Process Successful Payment**
   - Wait for `successful_payment` update
   - Store `telegram_payment_charge_id` for potential refunds
   - Deliver digital goods only after receiving this confirmation

## Current Issues in Selfi Bot

1. **Payment Provider Error**
   ```
   Bad Request: PAYMENT_PROVIDER_INVALID
   ```
   Fix: Update currency from "USD" to "XTR" in stars.ts

2. **Stars Package Configuration**
   ```typescript
   const starPacks = [
     { stars: 5, price: 99, label: '5 ⭐' },
     { stars: 10, price: 149, label: '10 ⭐' },
     { stars: 20, price: 249, label: '20 ⭐' },
     { stars: 50, price: 499, label: '50 ⭐' },
   ];
   ```
   Prices need to be adjusted for XTR currency.

## Implementation Notes

### Invoice Types
1. **Bot Invoice**
   - Sent directly to chats using `sendInvoice`
   - Can be sent to private chats, groups, or channels

2. **Inline Invoice**
   - Requires bot to support inline mode
   - Uses `inputInvoiceMessageContent`
   - Can be shared across chats

### Forwarding Behavior
- **Multi-chat invoice**: Pay button works in forwarded messages
- **Single-chat invoice**: Only payable in original chat, forwards show deep link

### Important Warnings
1. Always verify successful payment before delivering goods
2. Handle multiple payments carefully with inline invoices
3. Respond to pre-checkout queries within 10 seconds
4. Store payment IDs for refund purposes

## Testing
Test payments can be done in Telegram's test environment.