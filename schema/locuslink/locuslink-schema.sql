CREATE SEQUENCE locusset_pk_seq;
CREATE TABLE locusset (
    locusset_id          INTEGER         DEFAULT (NEXTVAL ( 'locusset_pk_seq' )) PRIMARY KEY
);


CREATE SEQUENCE locus_pk_seq;
CREATE TABLE locus (
    locus_id             INTEGER         DEFAULT (NEXTVAL ( 'locus_pk_seq' )) PRIMARY KEY,
    locusid              INT             ,
    locus_confirmed      VARCHAR(3)      ,
    locus_type           VARCHAR(53)     ,
    organism             VARCHAR(12)     ,
    status               VARCHAR(11)     ,
    official_symbol      VARCHAR(9)      ,
    official_gene_name   VARCHAR(128)    ,
    summary              TEXT            ,
    maplink              VARCHAR(28)     ,
    pmid                 TEXT            ,
    current_locusid      INT             ,
    locusset_id          INTEGER         ,
    FOREIGN KEY          (locusset_id)    REFERENCES locusset(locusset_id) ON DELETE CASCADE
);


CREATE SEQUENCE transcript_pk_seq;
CREATE TABLE transcript (
    transcript_id        INTEGER         DEFAULT (NEXTVAL ( 'transcript_pk_seq' )) PRIMARY KEY,
    nm                   VARCHAR(21)     ,
    np                   VARCHAR(18)     ,
    product              VARCHAR(124)    ,
    assembly             VARCHAR(44)     ,
    transvar             TEXT            ,
    locus_id             INTEGER         ,
    FOREIGN KEY          (locus_id)       REFERENCES locus(locus_id) ON DELETE CASCADE
);


CREATE SEQUENCE cdd_pk_seq;
CREATE TABLE cdd (
    cdd_id               INTEGER         DEFAULT (NEXTVAL ( 'cdd_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    domain               VARCHAR(254)    ,
    domain_acc           VARCHAR(13)     ,
    num                  INT             ,
    score                VARCHAR(12)     ,
    transcript_id        INTEGER         ,
    FOREIGN KEY          (transcript_id)  REFERENCES transcript(transcript_id) ON DELETE CASCADE
);


CREATE SEQUENCE contig_pk_seq;
CREATE TABLE contig (
    contig_id            INTEGER         DEFAULT (NEXTVAL ( 'contig_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    contig_acc           VARCHAR(12)     ,
    u1                   INT             ,
    u3                   INT             ,
    u4                   INT             ,
    strand               VARCHAR(1)      ,
    chr_num              VARCHAR(2)      ,
    src                  VARCHAR(15)     ,
    locus_id             INTEGER         ,
    FOREIGN KEY          (locus_id)       REFERENCES locus(locus_id) ON DELETE CASCADE
);


CREATE SEQUENCE evidence_pk_seq;
CREATE TABLE evidence (
    evidence_id          INTEGER         DEFAULT (NEXTVAL ( 'evidence_pk_seq' )) PRIMARY KEY,
    evid                 VARCHAR(52)     ,
    xr                   VARCHAR(21)     ,
    locus_id             INTEGER         ,
    FOREIGN KEY          (locus_id)       REFERENCES locus(locus_id) ON DELETE CASCADE
);


CREATE SEQUENCE xm_pk_seq;
CREATE TABLE xm (
    xm_id                INTEGER         DEFAULT (NEXTVAL ( 'xm_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    acc                  VARCHAR(9)      ,
    gi                   INT             ,
    evidence_id          INTEGER         ,
    FOREIGN KEY          (evidence_id)    REFERENCES evidence(evidence_id) ON DELETE CASCADE
);


CREATE SEQUENCE xp_pk_seq;
CREATE TABLE xp (
    xp_id                INTEGER         DEFAULT (NEXTVAL ( 'xp_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    acc                  VARCHAR(9)      ,
    gi                   INT             ,
    evidence_id          INTEGER         ,
    FOREIGN KEY          (evidence_id)    REFERENCES evidence(evidence_id) ON DELETE CASCADE
);


CREATE SEQUENCE accession_pk_seq;
CREATE TABLE accession (
    accession_id         INTEGER         DEFAULT (NEXTVAL ( 'accession_pk_seq' )) PRIMARY KEY,
    type                 VARCHAR(7)      ,
    preferred_symbol     VARCHAR(6)      ,
    preferred_gene_name  VARCHAR(5)      ,
    summary              TEXT            ,
    locus_id             INTEGER         ,
    FOREIGN KEY          (locus_id)       REFERENCES locus(locus_id) ON DELETE CASCADE
);


CREATE SEQUENCE accnum_pk_seq;
CREATE TABLE accnum (
    accnum_id            INTEGER         DEFAULT (NEXTVAL ( 'accnum_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    acc                  VARCHAR(9)      ,
    gi                   INT             ,
    accession_id         INTEGER         ,
    FOREIGN KEY          (accession_id)   REFERENCES accession(accession_id) ON DELETE CASCADE
);


CREATE SEQUENCE prot_pk_seq;
CREATE TABLE prot (
    prot_id              INTEGER         DEFAULT (NEXTVAL ( 'prot_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    acc                  VARCHAR(9)      ,
    gi                   INT             ,
    accession_id         INTEGER         ,
    FOREIGN KEY          (accession_id)   REFERENCES accession(accession_id) ON DELETE CASCADE
);


CREATE SEQUENCE alias_symbol_pk_seq;
CREATE TABLE alias_symbol (
    alias_symbol_id      INTEGER         DEFAULT (NEXTVAL ( 'alias_symbol_pk_seq' )) PRIMARY KEY,
    symbol               VARCHAR(20)     ,
    locus_id             INTEGER         ,
    accession_id         INTEGER         ,
    FOREIGN KEY          (accession_id)   REFERENCES accession(accession_id) ON DELETE CASCADE
);


CREATE SEQUENCE preferred_product_pk_seq;
CREATE TABLE preferred_product (
    preferred_product_id INTEGER         DEFAULT (NEXTVAL ( 'preferred_product_pk_seq' )) PRIMARY KEY,
    product              VARCHAR(124)    ,
    locus_id             INTEGER         ,
    accession_id         INTEGER         ,
    FOREIGN KEY          (accession_id)   REFERENCES accession(accession_id) ON DELETE CASCADE
);


CREATE SEQUENCE sts_pk_seq;
CREATE TABLE sts (
    sts_id               INTEGER         DEFAULT (NEXTVAL ( 'sts_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    sts_acc              VARCHAR(12)     ,
    chr_num              VARCHAR(2)      ,
    unk                  INT             ,
    src                  VARCHAR(15)     ,
    type                 VARCHAR(7)      ,
    symbol               VARCHAR(20)     ,
    locus_id             INTEGER         ,
    accession_id         INTEGER         ,
    FOREIGN KEY          (accession_id)   REFERENCES accession(accession_id) ON DELETE CASCADE
);


CREATE SEQUENCE comp_pk_seq;
CREATE TABLE comp (
    comp_id              INTEGER         DEFAULT (NEXTVAL ( 'comp_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    comp_acc             INT             ,
    symbol2              VARCHAR(14)     ,
    locusacc2            INT             ,
    chr_num1             VARCHAR(2)      ,
    symbol1              VARCHAR(9)      ,
    src                  VARCHAR(15)     ,
    chr_num2             VARCHAR(2)      ,
    map_pos2             VARCHAR(14)     ,
    locus_id             INTEGER         ,
    accession_id         INTEGER         ,
    FOREIGN KEY          (accession_id)   REFERENCES accession(accession_id) ON DELETE CASCADE
);


CREATE SEQUENCE url_pk_seq;
CREATE TABLE url (
    url_id               INTEGER         DEFAULT (NEXTVAL ( 'url_pk_seq' )) PRIMARY KEY,
    button               VARCHAR(11)     ,
    link                 VARCHAR(78)     ,
    unigene              VARCHAR(9)      ,
    maplink              VARCHAR(28)     ,
    pmid                 TEXT            ,
    locus_id             INTEGER         ,
    FOREIGN KEY          (locus_id)       REFERENCES locus(locus_id) ON DELETE CASCADE
);


CREATE SEQUENCE map_pk_seq;
CREATE TABLE map (
    map_id               INTEGER         DEFAULT (NEXTVAL ( 'map_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    map_loc              VARCHAR(16)     ,
    link                 VARCHAR(78)     ,
    code                 VARCHAR(1)      ,
    locus_id             INTEGER         ,
    url_id               INTEGER         ,
    FOREIGN KEY          (url_id)         REFERENCES url(url_id) ON DELETE CASCADE
);


CREATE SEQUENCE phenotype_pk_seq;
CREATE TABLE phenotype (
    phenotype_id         INTEGER         DEFAULT (NEXTVAL ( 'phenotype_pk_seq' )) PRIMARY KEY,
    phenotype_data       VARCHAR(76)     ,
    locus_id             INTEGER         ,
    url_id               INTEGER         ,
    FOREIGN KEY          (url_id)         REFERENCES url(url_id) ON DELETE CASCADE
);


CREATE SEQUENCE phenotype_id_pk_seq;
CREATE TABLE phenotype_id (
    phenotype_id_id      INTEGER         DEFAULT (NEXTVAL ( 'phenotype_id_pk_seq' )) PRIMARY KEY,
    phenotype_id_data    INT             ,
    locus_id             INTEGER         ,
    url_id               INTEGER         ,
    FOREIGN KEY          (url_id)         REFERENCES url(url_id) ON DELETE CASCADE
);


CREATE SEQUENCE grif_pk_seq;
CREATE TABLE grif (
    grif_id              INTEGER         DEFAULT (NEXTVAL ( 'grif_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    grif_pmid            INT             ,
    descr                VARCHAR(255)    ,
    locus_id             INTEGER         ,
    url_id               INTEGER         ,
    FOREIGN KEY          (url_id)         REFERENCES url(url_id) ON DELETE CASCADE
);


CREATE SEQUENCE sumfunc_pk_seq;
CREATE TABLE sumfunc (
    sumfunc_id           INTEGER         DEFAULT (NEXTVAL ( 'sumfunc_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    descr                VARCHAR(255)    ,
    src                  VARCHAR(15)     ,
    locus_id             INTEGER         ,
    url_id               INTEGER         ,
    FOREIGN KEY          (url_id)         REFERENCES url(url_id) ON DELETE CASCADE
);


CREATE SEQUENCE go_pk_seq;
CREATE TABLE go (
    go_id                INTEGER         DEFAULT (NEXTVAL ( 'go_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    aspect               VARCHAR(24)     ,
    term                 VARCHAR(81)     ,
    evcode               VARCHAR(2)      ,
    go_acc               VARCHAR(10)     ,
    src                  VARCHAR(15)     ,
    unk                  INT             ,
    locus_id             INTEGER         ,
    url_id               INTEGER         ,
    FOREIGN KEY          (url_id)         REFERENCES url(url_id) ON DELETE CASCADE
);


CREATE SEQUENCE extannot_pk_seq;
CREATE TABLE extannot (
    extannot_id          INTEGER         DEFAULT (NEXTVAL ( 'extannot_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    aspect               VARCHAR(24)     ,
    term                 VARCHAR(81)     ,
    evcode               VARCHAR(2)      ,
    src                  VARCHAR(15)     ,
    unk                  INT             ,
    locus_id             INTEGER         ,
    url_id               INTEGER         ,
    FOREIGN KEY          (url_id)         REFERENCES url(url_id) ON DELETE CASCADE
);


CREATE SEQUENCE ng_pk_seq;
CREATE TABLE ng (
    ng_id                INTEGER         DEFAULT (NEXTVAL ( 'ng_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    acc                  VARCHAR(9)      ,
    u1                   INT             ,
    u3                   INT             ,
    u4                   INT             ,
    locus_id             INTEGER         ,
    FOREIGN KEY          (locus_id)       REFERENCES locus(locus_id) ON DELETE CASCADE
);


CREATE SEQUENCE xg_pk_seq;
CREATE TABLE xg (
    xg_id                INTEGER         DEFAULT (NEXTVAL ( 'xg_pk_seq' )) PRIMARY KEY,
    defline              TEXT            ,
    acc                  VARCHAR(9)      ,
    gi                   INT             ,
    evidence_id          INTEGER         ,
    FOREIGN KEY          (evidence_id)    REFERENCES evidence(evidence_id) ON DELETE CASCADE
);


CREATE SEQUENCE alias_prot_pk_seq;
CREATE TABLE alias_prot (
    alias_prot_id        INTEGER         DEFAULT (NEXTVAL ( 'alias_prot_pk_seq' )) PRIMARY KEY,
    protsym              VARCHAR(135)    ,
    locus_id             INTEGER         ,
    accession_id         INTEGER         ,
    FOREIGN KEY          (accession_id)   REFERENCES accession(accession_id) ON DELETE CASCADE
);


CREATE SEQUENCE dbxref_pk_seq;
CREATE TABLE dbxref (
    dbxref_id            INTEGER         DEFAULT (NEXTVAL ( 'dbxref_pk_seq' )) PRIMARY KEY,
    db_descr             VARCHAR(66)     ,
    db_link              VARCHAR(76)     ,
    locus_id             INTEGER         ,
    FOREIGN KEY          (locus_id)       REFERENCES locus(locus_id) ON DELETE CASCADE
);


CREATE SEQUENCE ecnum_pk_seq;
CREATE TABLE ecnum (
    ecnum_id             INTEGER         DEFAULT (NEXTVAL ( 'ecnum_pk_seq' )) PRIMARY KEY,
    ecnum_data           VARCHAR(9)      ,
    locus_id             INTEGER         ,
    url_id               INTEGER         ,
    FOREIGN KEY          (url_id)         REFERENCES url(url_id) ON DELETE CASCADE
);


CREATE SEQUENCE chr_pk_seq;
CREATE TABLE chr (
    chr_id               INTEGER         DEFAULT (NEXTVAL ( 'chr_pk_seq' )) PRIMARY KEY,
    chr_data             VARCHAR(1)      ,
    locus_id             INTEGER         ,
    accession_id         INTEGER         ,
    FOREIGN KEY          (accession_id)   REFERENCES accession(accession_id) ON DELETE CASCADE
);


CREATE SEQUENCE omim_pk_seq;
CREATE TABLE omim (
    omim_id              INTEGER         DEFAULT (NEXTVAL ( 'omim_pk_seq' )) PRIMARY KEY,
    omim_data            INT             ,
    locus_id             INTEGER         ,
    url_id               INTEGER         ,
    FOREIGN KEY          (url_id)         REFERENCES url(url_id) ON DELETE CASCADE
);


