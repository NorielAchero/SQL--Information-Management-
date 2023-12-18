CREATE TABLE PROOUCT (prodCode VARCHAR(6) NOT NULL,
                        description VARCHAR (28),
                        unit VARCHAR (3),
                        PRIMARY KEY(prodCode)):
CALL SYSPROC.ADMIN_CMD('DESCRIBE TABLE PRODUCT'):


SELECT *
FROM PRODUCT;

ALTER TABLE PRODUCT
ADD CONSTRAINT unit_ck CHECK (unit in ('pc','ea','pkg','mtr','1tr'));

INSERT INTO PRODUCT (prodCode, description, unit)
VALUES  ('PS0003', 'Cisco Virt Hardware' , 'pcs'),
        ('PC0002', 'Dell 745 Opti Desk', 'pg').
        ('PA0001', 'MS 0c Business 2013', 'pk'),
        ('AM0001', 'MS Wireless Mouse', 'pcs'),
        ('AD0001', 'Toshiba Canvio 1 TB', 'eac');


CREATE TABLE PRICEHIST(oftDate DATE NOT NULL,
                    prodCode VARCHAR(6) NOT NULL,
                    unitPrice DECIMAL(10,2) CONSTRAINT UNITP_CK CHECK(unitPrice > 0),
                    PRIMARY KEY (effDate, prodCode),
                    FOREIGN KEY (prodCode) REFERENCES PRODUCT);

CALL SYSPROC.ADMIN_CMD('DESCRIBE TABLE PRICEHIST');

INSERT INTO PRICEHIST (effDate, prodCode, unitPrice)
VALUES  ('2010-05-15', 'N80083', '199'),
        ('2010-05-15', 'NB0984','279'),
        ('2010-85-15', '1NB0905', '350') ;


SELECT *
FROM PRICEHIST;

INSERT INTO PRICEHIST
VALUES('2011-02-01', 'P50983', '123.55');

INSERT INTO PRICEHIST
VALUES('2011-02-01', 'NB0005', '-1.85');

