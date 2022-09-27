select * 
from prescription


--1 a. Which prescriber had the highest total number of claims 
--(totaled over all drugs)? Report the npi and the total number of claims.
--answer david coffey NPI = 1912011792 4583 claims 

Select scrib.npi, 
scrib.nppes_provider_last_org_name AS last_name,
scrib.nppes_provider_first_name AS first_name,
total_Claim_count AS scrip_count
from prescription AS scrip
inner join prescriber AS scrib 
on scrip.npi = scrib.npi
order by scrip_count DESC;

--1 b.  Repeat the above, but this time report the nppes_provider_first_name, 
--nppes_provider_last_org_name,  specialty_description, and the total number of claims.
--**NEED To find out why there are dup names how to drill down to one name**

Select distinct scrib.npi, 
scrib.nppes_provider_first_name AS first_name,
scrib.nppes_provider_last_org_name AS last_name,
scrib.specialty_description AS Spec_desc,
scrip.total_claim_count AS total_claim_Count
from prescription AS scrip
inner join prescriber AS scrib 
on scrip.npi = scrib.npi
order by total_claim_count DESC;

--2. a. Which specialty had the most total number of claims (totaled over all drugs)?
--answer Family Practice 
select 
prescriber.specialty_description,
sum (prescription.total_claim_count) as claim
from prescriber 
inner join prescription
using (npi) 
GROUP BY Specialty_description
order by claim DESC;


--b. Which specialty had the most total number of claims for opioids?
--answer Fmily practice 

select specialty_description, drug_name, generic_name, total_claim_count, drug.opioid_drug_flag
from prescriber
INNER JOIN prescription
USING (NPI)
INNER JOIN drug
USING (drug_name)
where drug.opioid_drug_flag = 'Y'
ORDER BY total_claim_count DESC;

--3. a. Which drug (generic_name) had the highest total drug cost?
--answer INSULIN FLARGINE 
select generic_name, SUM(total_drug_cost)
from prescription
inner join drug
using (drug_name)
GROUP BY generic_name
order by sum desc
limit 1;

--b. Which drug (generic_name) has the hightest total cost per day? **Bonus: 
--Round your cost per day column to 2 decimal places. Google ROUND to see how this works.
--ANSWER c1 esterase inhibitor 3495.22
select generic_name, round (Sum (total_drug_cost) / SUM (total_day_supply),2) as daily_cost 
from prescription
inner join drug
using (drug_name)
group by generic_name
order by daily_cost DESC;

--4. a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 
--opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have 
--antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.
--ANSWER 


select *
From Drug
