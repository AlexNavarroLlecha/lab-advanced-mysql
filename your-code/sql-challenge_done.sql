# Challenge 1

SELECT ta.au_id, ta.title_id, ROUND(t.advance * royaltyper / 100, 2) as Advance, ROUND(t.price * s.qty * t.royalty / 100 * royaltyper / 100, 2) as Royalty
FROM titleauthor as ta
INNER JOIN sales as s
ON s.title_id = ta.title_id
INNER JOIN titles as t
ON t.title_id = ta.title_id;

#

SELECT title_id , au_id, SUM(salesRoyalty) as summed_royalties, Advance 
FROM (
	SELECT ta.au_id, t.title_id, ROUND(t.advance * ta.royaltyper / 100, 2) as Advance, ROUND(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100, 2) as salesRoyalty
	FROM titleauthor as ta
	INNER JOIN sales as s
	ON s.title_id = ta.title_id
	INNER JOIN titles as t
	ON t.title_id = ta.title_id
) as author_royalties
GROUP BY au_id, title_id, Advance;

#

SELECT au_id, (Advance + summed_royalties) as profits 

FROM (
	SELECT title_id , au_id, SUM(salesRoyalty) as summed_royalties, Advance 
	
	FROM (
		SELECT ta.au_id, ta.title_id, ROUND(t.advance * ta.royaltyper / 100, 2) as Advance, ROUND(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100, 2) as salesRoyalty
		FROM titleauthor as ta
		INNER JOIN sales as s
		ON s.title_id = ta.title_id
		INNER JOIN titles as t
		ON t.title_id = ta.title_id
	) as author_royalties
	
	GROUP BY au_id, title_id, Advance
) as author_profits

GROUP BY au_id, profits
ORDER BY profits DESC;


#Challenge 2

CREATE TEMPORARY TABLE challenge2_step1
SELECT ta.au_id, ta.title_id, ROUND(t.advance * ta.royaltyper / 100, 2) as Advance, ROUND(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100, 2) as salesRoyalty
FROM titleauthor as ta
INNER JOIN sales as s
ON s.title_id = ta.title_id
INNER JOIN titles as t
ON t.title_id = ta.title_id;

CREATE TEMPORARY TABLE challenge2_step2
SELECT title_id , au_id, SUM(salesRoyalty) as summed_royalties, Advance 
FROM challenge2_step1
GROUP BY au_id, title_id, Advance;

SELECT au_id, (Advance + summed_royalties) as profits 
FROM challenge2_step2
GROUP BY au_id, profits
ORDER BY profits DESC;


#Challenge 3

create table [if not exists] profits(
au_id int AUTO_INCREMENT,
profit varchar(255) NOT NULL,
PRIMARY KEY (task_id)
)  ENGINE=INNODB;