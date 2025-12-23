## Stablecoin Payment Operations Simulation
A hands-on project simulating payment and compliance operations for a stablecoin-based fintech product.

### What This Project Shows <br/>
This project demonstrates how payment, KYC, and card-related issues are handled operationally in a stablecoin fintech. <br/>
It focuses on identifying recurring issues, analyzing ops data with SQL, and proposing process improvements.

### Scope<br/>
- Onboarding & KYC operations<br/>
- Wallet funding (USDT / USDC)<br/>
- Payments & card declines<br/>
- Ops case tracking and SQL analysis

### Ops Case Framework
Cases are structured by issue category, root cause, resolution path, TTR, <br/>
and preventability to mirror real fintech ops workflows.

### Data & SQL Analysis
Operational cases are stored in SQLite and analyzed using SQL to identify bottlenecks and improvement opportunities.<br/>
See: analysis.sql

### Key Takeaways
- KYC issues were the most frequent operational bottleneck.<br/>
- Payment and card issues showed longer resolution times due to vendor dependencies.<br/>
- Many issues were preventable through clearer UX guidance and ops playbooks.

