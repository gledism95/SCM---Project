[README.md](https://github.com/user-attachments/files/28638846/README.md)
# SCM — Business Central AL Extension

> A personal Business Central AL extension used for learning, experimentation, and reusable customisation across multiple functional areas.

---

## Overview

This extension targets **Microsoft Dynamics 365 Business Central** (SaaS / On-Premises) and covers several independent functional enhancements developed for learning and practical use. Each feature area is self-contained and can be reviewed or adapted independently.

---

## Features

### 1. On Hold Status
Adds a structured **On Hold Status** field (Enum-driven) to both Purchase Orders and Sales Orders, replacing the native free-text "On Hold" field with a controlled value set. A blocking codeunit prevents posting when a document is on hold.

**Objects:**
- `Enum50001` — `Order Hold Status`
- `TableExt50001` — Purchase Header On Hold Extension
- `TableExt50002` — Sales Header On Hold Extension
- `PageExt50001` — Purchase Order List (On Hold Status column)
- `PageExt50002` — Purchase Order Card (On Hold Status field)
- `PageExt50003` — Sales Order Card (On Hold Status field)
- `PageExt50004` — Sales Order List (On Hold Status column)
- `Codeunit50004` — On Hold Status Block (posting prevention)

---

### 2. Item Certification
Adds a certification flag and validation logic to the Item Card and Item List, ensuring items requiring certification are flagged before use on documents.

**Objects:**
- `Codeunit50002` — Item Certification Validation
- `PageExt50052` — Item Card (Certification field)
- `PageExt50053` — Item List (Certification column)

---

### 3. Bank Reconciliation — Default GL Account
Automates the assignment of a default G/L Account on Bank Reconciliation lines to reduce manual entry and improve consistency.

**Objects:**
- `Codeunit50001` — Bank Rec Default GL Mgmt
- `Codeunit50003` — Bank Rec Insert Subscriber
- `ReportExt50001` — Transfer Balance to GL (Report Extension)

---

### 4. Warehouse Bin UOM Update
A utility report to bulk-update Unit of Measure on Warehouse Bins, with a Word layout for preview output.

**Objects:**
- `Report50000` — Update Bin UOM (processing report)
- `Report50001` — Update Bin UOM Word Layout
- `ReportLayouts/UOMUpdatePreview.docx` — Word layout

---

### 5. Delivery Docket Report
A custom Warehouse Delivery/Collection Docket report with a branded Word layout, developed for a SaaS client environment.

**Objects:**
- `Report50002` — Delivery Docket Report
- `ReportLayouts/SunsynkWord.docx` — Word layout

---

## Project Structure

```
SCM---Project/
│
├── src/
│   ├── Enums/
│   ├── TableExtensions/
│   ├── PageExtensions/
│   ├── Codeunits/
│   ├── Reports/
│   ├── ReportExtensions/
│   └── ReportLayouts/
│
├── .vscode/
│   └── launch.json
│
├── app.json
├── .gitignore
└── README.md
```

---

## Object ID Range

| Range | Object Type | Feature Area |
|-------|-------------|--------------|
| 50001 | Enum | On Hold Status |
| 50001–50004 | Codeunit | Bank Rec, Certification, On Hold |
| 50001–50002 | Table Extension | On Hold Status (Purchase + Sales) |
| 50001–50004 | Page Extension | On Hold Status |
| 50052–50053 | Page Extension | Item Certification |
| 50000–50002 | Report | Bin UOM + Delivery Docket |
| 50001 | Report Extension | Bank Rec Transfer to GL |

---

## Prerequisites

| Requirement | Details |
|-------------|---------|
| BC Version | Dynamics 365 Business Central 2023 Wave 1 (v22+) recommended |
| AL Extension | VS Code AL Language extension |
| VS Code | Latest stable |
| Target | SaaS (cloud sandbox) or On-Premises |

---

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/[your-username]/SCM---Project.git
   cd SCM---Project
   ```

2. **Open in VS Code**
   ```bash
   code .
   ```

3. **Configure `launch.json`**
   Update `.vscode/launch.json` with your sandbox URL, tenant, and authentication method.

4. **Publish to sandbox**
   Press `F5` in VS Code (or `Ctrl+Shift+B` to build without publishing).

---

## app.json (Key Settings)

```json
{
  "id": "[your-extension-guid]",
  "name": "SCM BC Extension",
  "publisher": "[Your Name or Publisher]",
  "version": "1.0.0.0",
  "platform": "22.0.0.0",
  "application": "22.0.0.0",
  "idRanges": [
    { "from": 50000, "to": 50099 }
  ]
}
```

---

## Naming Conventions Used

| Object Type | Pattern | Example |
|-------------|---------|---------|
| Enum | `Enum[ID].[PascalCaseName].al` | `Enum50001.OrderHoldStatus.al` |
| Table Extension | `TableExt[ID].[PascalCaseName].al` | `TableExt50001.PurchaseHeaderOnHold.al` |
| Page Extension | `PageExt[ID].[PascalCaseName].al` | `PageExt50001.PurchaseOrderListOnHold.al` |
| Codeunit | `Codeunit[ID].[PascalCaseName].al` | `Codeunit50001.BankRecDefaultGLMgmt.al` |
| Report | `Report[ID].[PascalCaseName].al` | `Report50000.UpdateBinUOM.al` |
| Report Extension | `ReportExt[ID].[PascalCaseName].al` | `ReportExt50001.TransferBalanceToGL.al` |

---

## Learning Notes

This project was built to explore the following BC AL development concepts:

- Enum-based field extensions on standard tables
- Event subscriber patterns (OnInsert, OnBeforePost)
- Page extension field placement and FactBox customisation
- Report design: RDL vs Word layout selection
- Report extensions vs custom reports
- Word layout content control mapping (`NavWordReportXmlPart`)
- Codeunit structure: single-responsibility vs. multi-event codeunits
- `.gitignore` and AL project hygiene for BC SaaS

---

## Contributing

This is a personal learning repository. Contributions are not expected, but issues and suggestions are welcome via GitHub Issues.

---

## Licence

This project is for personal learning and reference. No licence is applied — adapt freely for your own use.

---

## Author

**Gledis Muca**  
Senior Business Central Consultant  

---

*Built with AL, VS Code, and too many sandbox resets.*
