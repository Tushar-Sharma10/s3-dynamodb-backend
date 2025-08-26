# Terraform Remote Backend: S3 + DynamoDB

This repository contains Terraform configuration files to **bootstrap a remote backend** using:  
- **Amazon S3** for storing the Terraform state file  
- **Amazon DynamoDB** for state locking and consistency  

By storing your Terraform state remotely, you can collaborate with your team safely and avoid local state file issues.

---

## 📂 Project Structure

```bash
.
├── main.tf           # Terraform configuration for S3 bucket and DynamoDB table
├── Provider.tf       # Provider information
├── .gitignore        # Ignore sensitive and temporary Terraform files
└── README.md         # Project documentation
```

🔑 Features

✅ Globally unique S3 bucket name (via a random 2-byte hex suffix)
✅ State locking with DynamoDB to prevent concurrent changes
✅ Encryption at rest (AES-256)
✅ Versioning enabled for state rollback
✅ Public access blocked completely
✅ Bucket ownership enforcement
