CREATE TABLE tDealRelation
(DealRelationID numeric(15, 0),
RelType tinyint,
ParentID numeric(15, 0),
ChildID numeric(15, 0));

CREATE NONCLUSTERED INDEX XIE2tDealRelation
ON tDealRelation(RelType, ChildID);
CREATE NONCLUSTERED INDEX XIE3tDealRelation
ON tDealRelation(ParentID, ChildID);
CREATE NONCLUSTERED INDEX XIE4tDealRelation
ON tDealRelation(ChildID, RelType, ParentID);
CREATE UNIQUE NONCLUSTERED INDEX XPKtDealRelation
ON tDealRelation(RelType, ParentID, ChildID);

INSERT INTO tDealRelation
VALUES (1001, 2, 101, 103),
		(1002, 2, 102, 105),
		(1003, 2, 103, 106),
		(1004, 2, 104, 107),
		(1005, 2, 105, 108),
		(1006, 2, 106, 110),
		(1007, 2, 107, 111),
		(1008, 2, 111, 112);

CREATE TABLE #A
(DealID numeric(15, 0),
ParentCnt int,
ChildCnt int);

INSERT INTO #A
VALUES (106, 0, 0),
		(107, 0, 0),
		(108, 0, 0),
		(109, 0, 0);

WITH RecursiveChildCTE AS (
    SELECT ParentID, ChildID
    FROM tDealRelation WITH (INDEX(XPKtDealRelation))
    WHERE RelType = 2
    UNION ALL
    SELECT dr.ParentID, cte.ChildID
    FROM tDealRelation dr WITH (INDEX(XPKtDealRelation))
    INNER JOIN RecursiveChildCTE cte ON dr.ChildID = cte.ParentID
)
UPDATE #A
SET ChildCnt = (
    SELECT COUNT(DISTINCT ChildID)
    FROM RecursiveChildCTE
    WHERE ParentID = #A.DealID
);

WITH RecursiveParentCTE AS (
    SELECT ChildID, ParentID
    FROM tDealRelation WITH (INDEX(XPKtDealRelation))
    WHERE RelType = 2
    UNION ALL
    SELECT cte.ChildID, dr.ParentID
    FROM tDealRelation dr WITH (INDEX(XPKtDealRelation))
    INNER JOIN RecursiveParentCTE cte ON dr.ChildID = cte.ParentID
)
UPDATE #A
SET ParentCnt = (
    SELECT COUNT(DISTINCT ParentID)
    FROM RecursiveParentCTE
    WHERE ChildID = #A.DealID
);

SELECT * FROM #A;

-- DROP TABLE #A
-- DROP TABLE tDealRelation