WITH RECURSIVE seq(n) AS (
  SELECT 1
  UNION ALL
  SELECT n+1 FROM seq WHERE n < 160
)
INSERT INTO ops_cases (
  case_id, created_at, issue_category, issue_type, root_cause, resolution_path,
  ttr_hours, preventable, notes,
  product, payment_state, refund_state, status, priority, reopened, sla_hours, breach,
  order_id, tx_id, channel, country
)
SELECT
  'OPS-' || printf('%04d', 1000 + n) AS case_id,
  datetime('2025-01-01', printf('+%d hours', n*3)) AS created_at,

  -- Category
  CASE
    WHEN n % 4 = 1 THEN 'PAY'     -- Payment, duplicate payment  (결제/중복결제)
    WHEN n % 4 = 2 THEN 'CRD'     -- Card, Processor (카드/프로세서)
    WHEN n % 4 = 3 THEN 'PAY'     -- Refund, Delay (환불/지연)
    ELSE 'KYC'   
  END AS issue_category,

  -- Issue Type 
  CASE
    WHEN n <= 40 THEN 'DUPLICATE_CHARGE' -- 중복 결제
    WHEN n <= 80 THEN 'NON_DELIVERY_NO_REFUND' -- 배달 X / 응답 X
    WHEN n <= 120 THEN 'CANNOT_CANCEL_NO_REFUND' -- 환불 X / 응답 X
    ELSE 'MERCHANT_LATE_CANCEL' -- 지연 취소
  END AS issue_type,

  -- Root cause 
  CASE
    WHEN n % 10 IN (1,2,3,4) THEN 'U'   -- user error
    WHEN n % 10 IN (5,6,7) THEN 'V'     -- vendor/partner
    WHEN n % 10 IN (8) THEN 'S'         -- system
    ELSE 'P'                            -- policy
  END AS root_cause,

  -- Resolution path
  CASE
    WHEN n % 5 = 0 THEN 'VEND'
    WHEN n % 7 = 0 THEN 'ENG'
    ELSE 'OPS'
  END AS resolution_path,

  -- TTR (Time To Resolution / 해결시간)
  CASE
    WHEN n % 12 = 0 THEN 72
    WHEN n % 6 = 0 THEN 48
    WHEN n % 3 = 0 THEN 24
    ELSE 12
  END AS ttr_hours,

  -- preventable
  CASE WHEN n % 10 IN (1,2,3,4,5,6) THEN 'Y' ELSE 'N' END AS preventable,

  -- notes
  CASE
    WHEN n <= 40 THEN 'User reports double charge; refund pending for one leg.'
    WHEN n <= 80 THEN 'Food not delivered; merchant unreachable; user requests full refund.'
    WHEN n <= 120 THEN 'Cancellation disabled; user unable to cancel; refund not available in-app.'
    ELSE 'Merchant closed; order accepted then canceled after long delay.'
  END AS notes,

  -- product (GrabPay vs GrabFood 분리)
  CASE
    WHEN n <= 40 THEN 'GrabPay'
    WHEN n <= 80 THEN 'GrabFood'
    WHEN n <= 120 THEN 'GrabFood'
    ELSE 'GrabFood'
  END AS product,

  -- payment_state / refund_state
  CASE
    WHEN n <= 40 THEN CASE WHEN n % 2 = 0 THEN 'CAPTURED' ELSE 'HOLD' END
    WHEN n <= 80 THEN 'CAPTURED'
    WHEN n <= 120 THEN 'CAPTURED'
    ELSE 'HOLD'
  END AS payment_state,

  CASE
    WHEN n % 9 = 0 THEN 'FAILED'
    WHEN n % 5 = 0 THEN 'PENDING'
    WHEN n % 4 = 0 THEN 'INITIATED'
    ELSE 'COMPLETED'
  END AS refund_state,

  -- status / priority
  CASE
    WHEN n % 11 = 0 THEN 'ESCALATED'
    WHEN n % 7 = 0 THEN 'PENDING'
    ELSE 'CLOSED'
  END AS status,

  CASE
    WHEN n % 10 IN (0,1) THEN 'HIGH'
    WHEN n % 10 IN (2,3,4) THEN 'MEDIUM'
    ELSE 'LOW'
  END AS priority,

  -- reopened / SLA / breach
  CASE WHEN n % 10 = 0 THEN 1 ELSE 0 END AS reopened,
  CASE
    WHEN n % 3 = 0 THEN 24
    WHEN n % 3 = 1 THEN 48
    ELSE 72
  END AS sla_hours,
  CASE WHEN (CASE
      WHEN n % 12 = 0 THEN 72
      WHEN n % 6 = 0 THEN 48
      WHEN n % 3 = 0 THEN 24
      ELSE 12
    END) >
    (CASE
      WHEN n % 3 = 0 THEN 24
      WHEN n % 3 = 1 THEN 48
      ELSE 72
    END)
  THEN 1 ELSE 0 END AS breach,

  -- order_id / tx_id
  CASE WHEN n <= 40 THEN NULL ELSE 'FOOD-' || printf('%08d', 90000000 + n) END AS order_id,
  'TX-' || printf('%012d', 700000000000 + n) AS tx_id,

  -- channel / country
  CASE WHEN n % 4 = 0 THEN 'CHAT' WHEN n % 4 = 1 THEN 'INAPP' WHEN n % 4 = 2 THEN 'EMAIL' ELSE 'CHAT' END AS channel,
  CASE WHEN n % 3 = 0 THEN 'SG' WHEN n % 3 = 1 THEN 'MY' ELSE 'PH' END AS country
FROM seq;
