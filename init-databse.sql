-- drop all tables from current database

DROP TABLE IF EXISTS INVOICE CASCADE;
DROP TABLE IF EXISTS INVOICE_NOTE CASCADE;
DROP TABLE IF EXISTS PROCESS_CONTROL CASCADE;
DROP TABLE IF EXISTS PRECEDING_INVOICE_REFERENCE CASCADE;
DROP TABLE IF EXISTS SELLER CASCADE;
DROP TABLE IF EXISTS SELLER_IDENTIFIER CASCADE;
DROP TABLE IF EXISTS SELLER_POSTAL_ADDRESS CASCADE;
DROP TABLE IF EXISTS SELLER_CONTACT CASCADE;
DROP TABLE IF EXISTS BUYER CASCADE;
DROP TABLE IF EXISTS BUYER_POSTAL_ADDRESS CASCADE;
DROP TABLE IF EXISTS BUYER_CONTACT CASCADE;
DROP TABLE IF EXISTS PAYEE CASCADE;
DROP TABLE IF EXISTS SELLER_TAX_REPRESENTATIVE_PARTY CASCADE;
DROP TABLE IF EXISTS SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS CASCADE;
DROP TABLE IF EXISTS DELIVERY_INFORMATION CASCADE;
DROP TABLE IF EXISTS INVOICING_PERIOD CASCADE;
DROP TABLE IF EXISTS DELIVER_TO_ADDRESS CASCADE;
DROP TABLE IF EXISTS PAYMENT_INSTRUCTIONS CASCADE;
DROP TABLE IF EXISTS CREDIT_TRANSFER CASCADE;
DROP TABLE IF EXISTS PAYMENT_CARD_INFORMATION CASCADE;
DROP TABLE IF EXISTS DIRECT_DEBIT CASCADE;
DROP TABLE IF EXISTS DOCUMENT_LEVEL_ALLOWANCES CASCADE;
DROP TABLE IF EXISTS DOCUMENT_LEVEL_CHARGES CASCADE;
DROP TABLE IF EXISTS DOCUMENT_TOTALS CASCADE;
DROP TABLE IF EXISTS VAT_BREAKDOWN CASCADE;
DROP TABLE IF EXISTS ADDITIONAL_SUPPORTING_DOCUMENTS CASCADE;
DROP TABLE IF EXISTS INVOICE_LINE CASCADE;
DROP TABLE IF EXISTS INVOICE_LINE_PERIOD CASCADE;
DROP TABLE IF EXISTS INVOICE_LINE_ALLOWANCES CASCADE;
DROP TABLE IF EXISTS INVOICE_LINE_CHARGES CASCADE;
DROP TABLE IF EXISTS PRICE_DETAILS CASCADE;
DROP TABLE IF EXISTS LINE_VAT_INFORMATION CASCADE;
DROP TABLE IF EXISTS ITEM_INFORMATION CASCADE;
DROP TABLE IF EXISTS ITEM_ATTRIBUTES CASCADE;

-- INVOICE
-- attribute
-- - Invoice number : Identifier [1]
-- - Invoice issue date : Date [1]
-- - Invoice type code : Code [1] 326,380,384 or 876
-- - Invoice currency code : Code [1]
-- - VAT accounting currency code : Code [0..1]
-- - Value added tax point date : Date [0..1]
-- - Value added tax point date code : Code [0..1]
-- - Payment due date : Date [0..1]
-- - Buyer reference : Text [1]
-- - Project reference : Document Reference [0..1]
-- - Contract reference : Document Reference [0..1]
-- - Purchase order reference : Document Reference [0..1]
-- - Sales order reference : Document Reference [0..1]
-- - Receiving advice reference : Document Reference [0..1]
-- - Despatch advice reference : Document Reference [0..1]
-- - Tender or lot reference : Document Reference [0..1]
-- - Invoiced object identifier : Identifier [0..1]
-- - Buyer accounting reference : Text [0..1]
-- - Payment terms : Text [0..1]
-- - INVOICE NOTE : INVOICE NOTE [0..*]
-- - PROCESS CONTROL : PROCESS CONTROL [1]
-- - PRECEDING INVOICE REFERENCE : PRECEDING INVOICE REFERENCE [0..*]
-- - SELLER : SELLER [1]
-- - BUYER : BUYER [1]
-- - PAYEE : PAYEE [0..1]
-- - SELLER TAX REPRESENTATIVE PARTY : SELLER TAX REPRESENTATIVE
-- PARTY [0..1]
-- - DELIVERY INFORMATION : DELIVERY INFORMATION [0..1]
-- - PAYMENT INSTRUCTIONS : PAYMENT INSTRUCTIONS [1]
-- - DOCUMENT LEVEL ALLOWANCES : DOCUMENT LEVEL ALLOWANCES [0..*]
-- - DOCUMENT LEVEL CHARGES : DOCUMENT LEVEL CHARGES [0..*]
-- - DOCUMENT TOTALS : DOCUMENT TOTALS [1]
-- - VAT BREAKDOWN : VAT BREAKDOWN [1..*]
-- - ADDITIONAL SUPPORTING DOCUMENTS : ADDITIONAL SUPPORTING DOCU-
-- MENTS [0..*]
-- - INVOICE LINE : INVOICE LINE [1..*]

CREATE TABLE INVOICE (
    id SERIAL PRIMARY KEY,
    invoice_number VARCHAR(255) NOT NULL,
    invoice_issue_date DATE NOT NULL,
    invoice_type_code INT NOT NULL,
    invoice_currency_code VARCHAR(3) NOT NULL,
    vat_accounting_currency_code VARCHAR(3),
    value_added_tax_point_date DATE,
    value_added_tax_point_date_code INT,
    payment_due_date DATE,
    buyer_reference TEXT NOT NULL,
    project_reference VARCHAR(255),
    contract_reference VARCHAR(255),
    purchase_order_reference VARCHAR(255),
    sales_order_reference VARCHAR(255),
    receiving_advice_reference VARCHAR(255),
    despatch_advice_reference VARCHAR(255),
    tender_or_lot_reference VARCHAR(255),
    invoiced_object_identifier VARCHAR(255),
    buyer_accounting_reference TEXT,
    payment_terms TEXT,
    -- invoice_note
    -- process_control
    -- preceding_invoice_reference
    -- seller
    -- buyer
    -- payee
    -- seller_tax_representative_party
    -- delivery_information
    -- payment_instructions
    -- document_level_allowances
    -- document_level_charges
    -- document_totals
    -- vat_breakdown
    -- additional_supporting_documents
    -- invoice_line
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INVOICE NOTE
-- attribute
-- - Invoice note subject code : Code [0..1]
-- - Invoice note : Text [1]

CREATE TABLE INVOICE_NOTE (
    id SERIAL PRIMARY KEY,
    invoice_note_subject_code VARCHAR(255),
    invoice_note TEXT NOT NULL,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PROCESS CONTROL
-- attribute
-- - Business process type : Text [1]
-- - Specification identifier : Identifier [1]

CREATE TABLE PROCESS_CONTROL (
    id SERIAL PRIMARY KEY,
    business_process_type TEXT NOT NULL,
    specification_identifier VARCHAR(255) NOT NULL,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRECEDING INVOICE REFERENCE
-- attribute
-- - Preceding Invoice reference : Document Reference [1]
-- - Preceding Invoice issue date : Date [0..1]

CREATE TABLE PRECEDING_INVOICE_REFERENCE (
    id SERIAL PRIMARY KEY,
    preceding_invoice_reference VARCHAR(255) NOT NULL,
    preceding_invoice_issue_date DATE,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SELLER
-- attribute
-- - Seller name : Text [1]
-- - Seller trading name : Text [0..1]
-- - Seller identifier : Identifier [0..*]
-- - Seller legal registration identifier : Identifier [0..1]
-- - Seller VAT identifier : Identifier [0..1]
-- - Seller tax registration identifier : Identifier [0..1]
-- - Seller additional legal information : Text [0..1]
-- - Seller electronic address : Identifier [1]
-- - SELLER POSTAL ADDRESS : SELLER POSTAL ADDRESS [1]
-- - SELLER CONTACT : SELLER CONTACT [1]

CREATE TABLE SELLER (
    id SERIAL PRIMARY KEY,
    seller_name TEXT NOT NULL,
    seller_trading_name TEXT,
    seller_legal_registration_identifier VARCHAR(255),
    seller_vat_identifier VARCHAR(255),
    seller_tax_registration_identifier VARCHAR(255),
    seller_additional_legal_information TEXT,
    seller_electronic_address VARCHAR(255) NOT NULL,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE SELLER_IDENTIFIER (
    id SERIAL PRIMARY KEY,
    seller_identifier VARCHAR(255) NOT NULL,
    seller_id INT NOT NULL,
    FOREIGN KEY (seller_id) REFERENCES SELLER(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SELLER POSTAL ADDRESS
-- attribute
-- - Seller address line 1 : Text [0..1]
-- - Seller address line 2 : Text [0..1]
-- - Seller address line 3 : Text [0..1]
-- - Seller city : Text [1]
-- - Seller post code : Text [1]
-- - Seller country subdivision : Text [0..1]
-- - Seller country code : Code [1]

CREATE TABLE SELLER_POSTAL_ADDRESS (
    id SERIAL PRIMARY KEY,
    seller_address_line_1 TEXT,
    seller_address_line_2 TEXT,
    seller_address_line_3 TEXT,
    seller_city TEXT NOT NULL,
    seller_post_code TEXT NOT NULL,
    seller_country_subdivision TEXT,
    seller_country_code VARCHAR(3) NOT NULL,
    seller_id INT NOT NULL,
    FOREIGN KEY (seller_id) REFERENCES SELLER(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SELLER CONTACT
-- attribute
-- - Seller contact point : Text [1]
-- - Seller contact telephone number : Text [1]
-- - Seller contact email address : Text [1]

CREATE TABLE SELLER_CONTACT (
    id SERIAL PRIMARY KEY,
    seller_contact_point TEXT NOT NULL,
    seller_contact_telephone_number TEXT NOT NULL,
    seller_contact_email_address TEXT NOT NULL,
    seller_id INT NOT NULL,
    FOREIGN KEY (seller_id) REFERENCES SELLER(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BUYER
-- attribute
-- - Buyer name : Text [1]
-- - Buyer trading name : Text [0..1]
-- - Buyer identifier : Identifier [0..1]
-- - Buyer legal registration identifier : Identifier [0..1]
-- - Buyer VAT identifier : Identifier [0..1]
-- - Buyer electronic address : Identifier [1]
-- - BUYER POSTAL ADDRESS : BUYER POSTAL ADDRESS [1]
-- - BUYER CONTACT : BUYER CONTACT [0..1]

CREATE TABLE BUYER (
    id SERIAL PRIMARY KEY,
    buyer_name TEXT NOT NULL,
    buyer_trading_name TEXT,
    buyer_identifier VARCHAR(255),
    buyer_legal_registration_identifier VARCHAR(255),
    buyer_vat_identifier VARCHAR(255),
    buyer_electronic_address VARCHAR(255) NOT NULL,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BUYER POSTAL ADDRESS
-- attribute
-- - Buyer address line 1 : Text [0..1]
-- - Buyer address line 2 : Text [0..1]
-- - Buyer address line 3 : Text [0..1]
-- - Buyer city : Text [1]
-- - Buyer post code : Text [1]
-- - Buyer country subdivision : Text [0..1]
-- - Buyer country code : Code [1]

CREATE TABLE BUYER_POSTAL_ADDRESS (
    id SERIAL PRIMARY KEY,
    buyer_address_line_1 TEXT,
    buyer_address_line_2 TEXT,
    buyer_address_line_3 TEXT,
    buyer_city TEXT NOT NULL,
    buyer_post_code TEXT NOT NULL,
    buyer_country_subdivision TEXT,
    buyer_country_code VARCHAR(3) NOT NULL,
    buyer_id INT NOT NULL,
    FOREIGN KEY (buyer_id) REFERENCES BUYER(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BUYER CONTACT
-- attribute
-- - Buyer contact point : Text [0..1]
-- - Buyer contact telephone number : Text [0..1]
-- - Buyer contact email address : Text [0..1]

CREATE TABLE BUYER_CONTACT (
    id SERIAL PRIMARY KEY,
    buyer_contact_point TEXT,
    buyer_contact_telephone_number TEXT,
    buyer_contact_email_address TEXT,
    buyer_id INT NOT NULL,
    FOREIGN KEY (buyer_id) REFERENCES BUYER(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PAYEE
-- attribute
-- - Payee name : Text [1]
-- - Payee identifier : Identifier [0..1]
-- - Payee legal registration identifier : Identifier [0..1]

CREATE TABLE PAYEE (
    id SERIAL PRIMARY KEY,
    payee_name TEXT NOT NULL,
    payee_identifier VARCHAR(255),
    payee_legal_registration_identifier VARCHAR(255),
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SELLER TAX REPRESENTATIVE PARTY
-- attribute
-- - Seller tax representative name : Text [1]
-- - Seller tax representative VAT identifier : Identifier [1]
-- - SELLER TAX REPRESENTATIVE POSTAL ADDRESS : SELLER TAX
-- REPRESENTATIVE POSTAL ADDRESS [1]

CREATE TABLE SELLER_TAX_REPRESENTATIVE_PARTY (
    id SERIAL PRIMARY KEY,
    seller_tax_representative_name TEXT NOT NULL,
    seller_tax_representative_vat_identifier VARCHAR(255) NOT NULL,
    seller_tax_representative_postal_address_id INT NOT NULL,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    -- FOREIGN KEY (seller_tax_representative_postal_address_id) REFERENCES SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SELLER TAX REPRESENTATIVE POSTAL ADDRESS
-- attribute
-- - Tax representative address line 1 : Text [0..1]
-- - Tax representative address line 2 : Text [0..1]
-- - Tax representative address line 3 : Text [0..1]
-- - Tax representative city : Text [0..1]
-- - Tax representative post code : Text [0..1]
-- - Tax representative country subdivision : Text [0..1]
-- - Tax representative country code : Code [1]

CREATE TABLE SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS (
    id SERIAL PRIMARY KEY,
    tax_representative_address_line_1 TEXT,
    tax_representative_address_line_2 TEXT,
    tax_representative_address_line_3 TEXT,
    tax_representative_city TEXT,
    tax_representative_post_code TEXT,
    tax_representative_country_subdivision TEXT,
    tax_representative_country_code VARCHAR(3) NOT NULL,
    seller_tax_representative_party_id INT NOT NULL,
    FOREIGN KEY (seller_tax_representative_party_id) REFERENCES SELLER_TAX_REPRESENTATIVE_PARTY(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DELIVERY INFORMATION
-- attribute
-- - Deliver to party name : Text [0..1]
-- - Deliver to location identifier : Identifier [0..1]
-- - Actual delivery date : Date [0..1]
-- - INVOICING PERIOD : INVOICING PERIOD [0..1]
-- - DELIVER TO ADDRESS : DELIVER TO ADDRESS [0..1]

CREATE TABLE DELIVERY_INFORMATION (
    id SERIAL PRIMARY KEY,
    deliver_to_party_name TEXT,
    deliver_to_location_identifier VARCHAR(255),
    actual_delivery_date DATE,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INVOICING PERIOD
-- attribute
-- - Invoicing period start date : Date [0..1]
-- - Invoicing period end date : Date [0..1

CREATE TABLE INVOICING_PERIOD (
    id SERIAL PRIMARY KEY,
    invoicing_period_start_date DATE,
    invoicing_period_end_date DATE,
    delivery_information_id INT NOT NULL,
    FOREIGN KEY (delivery_information_id) REFERENCES DELIVERY_INFORMATION(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DELIVER TO ADDRESS
-- attribute
-- - Deliver to address line 1 : Text [0..1]
-- - Deliver to address line 2 : Text [0..1]
-- - Deliver to address line 3 : Text [0..1]
-- - Deliver to city : Text [1]
-- - Deliver to post code : Text [1]
-- - Deliver to country subdivision : Text [0..1]
-- - Deliver to country code : Code [1]

CREATE TABLE DELIVER_TO_ADDRESS (
    id SERIAL PRIMARY KEY,
    deliver_to_address_line_1 TEXT,
    deliver_to_address_line_2 TEXT,
    deliver_to_address_line_3 TEXT,
    deliver_to_city TEXT NOT NULL,
    deliver_to_post_code TEXT NOT NULL,
    deliver_to_country_subdivision TEXT,
    deliver_to_country_code VARCHAR(3) NOT NULL,
    delivery_information_id INT NOT NULL,
    FOREIGN KEY (delivery_information_id) REFERENCES DELIVERY_INFORMATION(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PAYMENT INSTRUCTIONS
-- attribute
-- - Payment means type code : Code [1]
-- - Payment means text : Text [0..1]
-- - Remittance information : Text [0..1]
-- - CREDIT TRANSFER : CREDIT TRANSFER [0..*]
-- - PAYMENT CARD INFORMATION : PAYMENT CARD INFORMATION [0..1]
-- - DIRECT DEBIT : DIRECT DEBIT [0..1]

CREATE TABLE PAYMENT_INSTRUCTIONS (
    id SERIAL PRIMARY KEY,
    payment_means_type_code INT NOT NULL,
    payment_means_text TEXT,
    remittance_information TEXT,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CREDIT TRANSFER
-- attribute
-- - Payment account identifier : Identifier [1]
-- - Payment account name : Text [0..1]
-- - Payment service provider identifier : Identifier [0..1]

CREATE TABLE CREDIT_TRANSFER (
    id SERIAL PRIMARY KEY,
    payment_account_identifier VARCHAR(255) NOT NULL,
    payment_account_name TEXT,
    payment_service_provider_identifier VARCHAR(255),
    payment_instructions_id INT NOT NULL,
    FOREIGN KEY (payment_instructions_id) REFERENCES PAYMENT_INSTRUCTIONS(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PAYMENT CARD INFORMATION
-- attribute
-- - Payment card primary account number : Text [1]
-- - Payment card holder name : Text [0..1]

CREATE TABLE PAYMENT_CARD_INFORMATION (
    id SERIAL PRIMARY KEY,
    payment_card_primary_account_number TEXT NOT NULL,
    payment_card_holder_name TEXT,
    payment_instructions_id INT NOT NULL,
    FOREIGN KEY (payment_instructions_id) REFERENCES PAYMENT_INSTRUCTIONS(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DIRECT DEBIT
-- attribute
-- - Mandate reference identifier : Identifier [1]
-- - Bank assigned creditor identifier : Identifier [1]
-- - Debited account identifier : Identifier [1]

CREATE TABLE DIRECT_DEBIT (
    id SERIAL PRIMARY KEY,
    mandate_reference_identifier VARCHAR(255) NOT NULL,
    bank_assigned_creditor_identifier VARCHAR(255) NOT NULL,
    debited_account_identifier VARCHAR(255) NOT NULL,
    payment_instructions_id INT NOT NULL,
    FOREIGN KEY (payment_instructions_id) REFERENCES PAYMENT_INSTRUCTIONS(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DOCUMENT LEVEL ALLOWANCES
-- attribute
-- - Document level allowance amount : Amount [1]
-- - Document level allowance base amount : Amount [0..1]
-- - Document level allowance percentage : Percentage [0..1]
-- - Document level allowance VAT category code : Code [1]
-- - Document level allowance VAT rate : Percentage [0..1]
-- - Document level allowance reason : Text [0..1]
-- - Document level allowance reason code : Code [0..1]

CREATE TABLE DOCUMENT_LEVEL_ALLOWANCES (
    id SERIAL PRIMARY KEY,
    document_level_allowance_amount DECIMAL(10, 2) NOT NULL,
    document_level_allowance_base_amount DECIMAL(10, 2),
    document_level_allowance_percentage DECIMAL(3, 2),
    document_level_allowance_vat_category_code INT NOT NULL,
    document_level_allowance_vat_rate DECIMAL(10, 2),
    document_level_allowance_reason TEXT,
    document_level_allowance_reason_code INT,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DOCUMENT LEVEL CHARGES
-- attribute
-- - Document level charge amount : Amount [1]
-- - Document level charge base amount : Amount [0..1]
-- - Document level charge percentage : Percentage [0..1]
-- - Document level charge VAT category code : Code [1]
-- - Document level charge VAT rate : Percentage [0..1]
-- - Document level charge reason : Text [0..1]
-- - Document level charge reason code : Code [0..1]

CREATE TABLE DOCUMENT_LEVEL_CHARGES (
    id SERIAL PRIMARY KEY,
    document_level_charge_amount DECIMAL(10, 2) NOT NULL,
    document_level_charge_base_amount DECIMAL(10, 2),
    document_level_charge_percentage DECIMAL(3, 2),
    document_level_charge_vat_category_code INT NOT NULL,
    document_level_charge_vat_rate DECIMAL(10, 2),
    document_level_charge_reason TEXT,
    document_level_charge_reason_code INT,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DOCUMENT TOTALS
-- attribute
-- - Sum of Invoice line net amount : Amount [1]
-- - Sum of allowances on document level : Amount [0..1]
-- - Sum of charges on document level : Amount [0..1]
-- - Invoice total amount without VAT : Amount [1]
-- - Invoice total VAT amount : Amount [0..1]
-- - Invoice total VAT amount in accounting currency : Amount [0..1]
-- - Invoice total amount with VAT : Amount [1]
-- - Paid amount : Amount [0..1]
-- - Rounding amount : Amount [0..1]
-- - Amount due for payment : Amount [1]

CREATE TABLE DOCUMENT_TOTALS (
    id SERIAL PRIMARY KEY,
    sum_of_invoice_line_net_amount DECIMAL(10, 2) NOT NULL,
    sum_of_allowances_on_document_level DECIMAL(10, 2),
    sum_of_charges_on_document_level DECIMAL(10, 2),
    invoice_total_amount_without_vat DECIMAL(10, 2) NOT NULL,
    invoice_total_vat_amount DECIMAL(10, 2),
    invoice_total_vat_amount_in_accounting_currency DECIMAL(10, 2),
    invoice_total_amount_with_vat DECIMAL(10, 2) NOT NULL,
    paid_amount DECIMAL(10, 2),
    rounding_amount DECIMAL(10, 2),
    amount_due_for_payment DECIMAL(10, 2) NOT NULL,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- VAT BREAKDOWN
-- attribute
-- - VAT category taxable amount : Amount [1]
-- - VAT category tax amount : Amount [1]
-- - VAT category code : Code [1]
-- - VAT category rate : Percentage [1]
-- - VAT exemption reason text : Text [0..1]
-- - VAT exemption reason code : Code [0..1]

CREATE TABLE VAT_BREAKDOWN (
    id SERIAL PRIMARY KEY,
    vat_category_taxable_amount DECIMAL(10, 2) NOT NULL,
    vat_category_tax_amount DECIMAL(10, 2) NOT NULL,
    vat_category_code INT NOT NULL,
    vat_category_rate DECIMAL(3, 2) NOT NULL,
    vat_exemption_reason_text TEXT,
    vat_exemption_reason_code INT,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ADDITIONAL SUPPORTING DOCUMENTS
-- attribute
-- - Supporting document reference : Document Reference [1]
-- - Supporting document description : Text [0..1]
-- - External document location : Text [0..1]
-- - Attached document : Binary Object [0..1]

CREATE TABLE ADDITIONAL_SUPPORTING_DOCUMENTS (
    id SERIAL PRIMARY KEY,
    supporting_document_reference VARCHAR(255) NOT NULL,
    supporting_document_description TEXT,
    external_document_location TEXT,
    attached_document BYTEA,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INVOICE LINE
-- attribute
-- - Invoice line identifier : Identifier [1]
-- - Invoice line note : Text [0..1]
-- - Invoice line object identifier : Identifier [0..1]
-- - Invoiced quantity : Quantity [1]
-- - Invoiced quantity unit of measure code : Code [1]
-- - Invoice line net amount : Amount [1]
-- - Referenced purchase order line reference : Document Reference [0..1]
-- - Invoice line Buyer accounting reference : Text [0..1]
-- - INVOICE LINE PERIOD : INVOICE LINE PERIOD [0..1]
-- - INVOICE LINE ALLOWANCES : INVOICE LINE ALLOWANCES [0..*]
-- - INVOICE LINE CHARGES : INVOICE LINE CHARGES [0..*]
-- - PRICE DETAILS : PRICE DETAILS [1]
-- - LINE VAT INFORMATION : LINE VAT INFORMATION [1]
-- - ITEM INFORMATION : ITEM INFORMATION [1]

CREATE TABLE INVOICE_LINE (
    id SERIAL PRIMARY KEY,
    invoice_line_identifier VARCHAR(255) NOT NULL,
    invoice_line_note TEXT,
    invoice_line_object_identifier VARCHAR(255),
    invoiced_quantity NUMERIC NOT NULL,
    invoiced_quantity_unit_of_measure_code VARCHAR(3) NOT NULL,
    invoice_line_net_amount DECIMAL(10, 2) NOT NULL,
    referenced_purchase_order_line_reference VARCHAR(255),
    invoice_line_buyer_accounting_reference TEXT,
    invoice_id INT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INVOICE LINE PERIOD
-- attribute
-- - Invoice line period start date : Date [0..1]
-- - Invoice line period end date : Date [0..1]

CREATE TABLE INVOICE_LINE_PERIOD (
    id SERIAL PRIMARY KEY,
    invoice_line_period_start_date DATE,
    invoice_line_period_end_date DATE,
    invoice_line_id INT NOT NULL,
    FOREIGN KEY (invoice_line_id) REFERENCES INVOICE_LINE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INVOICE LINE ALLOWANCES
-- attribute
-- - Invoice line allowance amount : Amount [1]
-- - Invoice line allowance base amount : Amount [0..1]
-- - Invoice line allowance percentage : Percentage [0..1]
-- - Invoice line allowance reason : Text [0..1]
-- - Invoice line allowance reason code : Code [0..1]

CREATE TABLE INVOICE_LINE_ALLOWANCES (
    id SERIAL PRIMARY KEY,
    invoice_line_allowance_amount DECIMAL(10, 2) NOT NULL,
    invoice_line_allowance_base_amount DECIMAL(10, 2),
    invoice_line_allowance_percentage DECIMAL(3, 2),
    invoice_line_allowance_reason TEXT,
    invoice_line_allowance_reason_code INT,
    invoice_line_id INT NOT NULL,
    FOREIGN KEY (invoice_line_id) REFERENCES INVOICE_LINE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INVOICE LINE CHARGES
-- attribute
-- - Invoice line charge amount : Amount [1]
-- - Invoice line charge base amount : Amount [0..1]
-- - Invoice line charge percentage : Percentage [0..1]
-- - Invoice line charge reason : Text [0..1]
-- - Invoice line charge reason code : Code [0..1]

CREATE TABLE INVOICE_LINE_CHARGES (
    id SERIAL PRIMARY KEY,
    invoice_line_charge_amount DECIMAL(10, 2) NOT NULL,
    invoice_line_charge_base_amount DECIMAL(10, 2),
    invoice_line_charge_percentage DECIMAL(3, 2),
    invoice_line_charge_reason TEXT,
    invoice_line_charge_reason_code INT,
    invoice_line_id INT NOT NULL,
    FOREIGN KEY (invoice_line_id) REFERENCES INVOICE_LINE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRICE DETAILS
-- attribute
-- - Item net price : Unit Price Amount [1]
-- - Item price discount : Unit Price Amount [0..1]
-- - Item gross price : Unit Price Amount [0..1]
-- - Item price base quantity : Quantity [0..1]
-- - Item price base quantity unit of measure code : Code [0..1]

CREATE TABLE PRICE_DETAILS (
    id SERIAL PRIMARY KEY,
    item_net_price DECIMAL(10, 2) NOT NULL,
    item_price_discount DECIMAL(10, 2),
    item_gross_price DECIMAL(10, 2),
    item_price_base_quantity NUMERIC,
    item_price_base_quantity_unit_of_measure_code VARCHAR(3),
    invoice_line_id INT NOT NULL,
    FOREIGN KEY (invoice_line_id) REFERENCES INVOICE_LINE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- LINE VAT INFORMATION
-- attribute
-- - Invoiced item VAT category code : Code [1]
-- - Invoiced item VAT rate : Percentage [0..1]

CREATE TABLE LINE_VAT_INFORMATION (
    id SERIAL PRIMARY KEY,
    invoiced_item_vat_category_code INT NOT NULL,
    invoiced_item_vat_rate DECIMAL(3, 2),
    invoice_line_id INT NOT NULL,
    FOREIGN KEY (invoice_line_id) REFERENCES INVOICE_LINE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ITEM INFORMATION
-- attribute
-- - Item name : Text [1]
-- - Item description : Text [0..1]
-- - Item Sellers identifier : Identifier [0..1]
-- - Item Buyers identifier : Identifier [0..1]
-- - Item standard identifier : Identifier [0..1]
-- - Item classification identifier : Identifier [0..*]
-- - Item country of origin : Code [0..1]
-- - ITEM ATTRIBUTES : ITEM ATTRIBUTES [0..*]

CREATE TABLE ITEM_INFORMATION (
    id SERIAL PRIMARY KEY,
    item_name TEXT NOT NULL,
    item_description TEXT,
    item_sellers_identifier VARCHAR(255),
    item_buyers_identifier VARCHAR(255),
    item_standard_identifier VARCHAR(255),
    item_classification_identifier VARCHAR(255),
    item_country_of_origin VARCHAR(3),
    invoice_line_id INT NOT NULL,
    FOREIGN KEY (invoice_line_id) REFERENCES INVOICE_LINE(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ITEM ATTRIBUTES
-- attribute
-- - Item attribute name : Text [1]
-- - Item attribute value : Text [1]

CREATE TABLE ITEM_ATTRIBUTES (
    id SERIAL PRIMARY KEY,
    item_attribute_name TEXT NOT NULL,
    item_attribute_value TEXT NOT NULL,
    item_information_id INT NOT NULL,
    FOREIGN KEY (item_information_id) REFERENCES ITEM_INFORMATION(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);