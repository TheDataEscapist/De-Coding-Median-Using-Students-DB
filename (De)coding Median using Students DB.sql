/*Making the database default*/
use students_db;

/*METHOD 1 - The traditional statistical method

Step 1: Defining a variable n to get the total number of students*/
SET @n := (select count(mtest) from students);

/*Step 2: Defining another variable as MedianValue to get the mid-value(s)*/
SET @MedianValue := (select round(if(@n mod 2 = 0, (@n/2 + (@n/2+1))/2, (@n+1)/2), 1)
					 from students
					 limit 1);

/*Step 3: Finding the median by arranging the data in descending order*/
select round(avg(mtest), 1) as Median
from (select mtest, row_number() over (order by mtest desc) as Position
	  from students
	  where mtest is not null) as TempTable
where Position IN (ceil(@MedianValue), floor(@MedianValue));


/*METHOD 2 - The shortcut method*/

SET @RowIndex := -1;	
	
select round(avg(mtest), 1) as Median
from (select mtest, @RowIndex := @RowIndex + 1 as Rno
	  from students
	  where mtest is not null
	  order by mtest asc) as TempTable	
where Rno IN (ceil(@RowIndex/2), floor(@RowIndex/2));