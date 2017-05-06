CREATE OR REPLACE
FUNCTION SPLIT_VIRGOLE(p_list IN VARCHAR2, p_separatore in VARCHAR2)

	-- http://stackoverflow.com/questions/3819375/convert-comma-separated-string-to-array-in-pl-sql

	-- Esempi di uso: SELECT * FROM TABLE(SPLIT_VIRGOLE('AAA,BBB,CCC,D',','))
	--                SELECT * FROM  TABLE ( SPLIT_VIRGOLE('Bev;Tamiko;Lita;Salvador;Hortense;Alva;Elwood;Pablo;Oscar',';'))



	RETURN TYPE_TABLE_VARCHAR_255
AS
	l_string       VARCHAR2(32767) := p_list || p_separatore /*','*/ ;
    l_comma_index  PLS_INTEGER;
    l_index        PLS_INTEGER := 1;
    l_tab          TYPE_TABLE_VARCHAR_255 := TYPE_TABLE_VARCHAR_255();
BEGIN
	LOOP
      	l_comma_index := INSTR(l_string, p_separatore /* ',' */, l_index);
      	EXIT WHEN l_comma_index = 0;
      	l_tab.EXTEND;
      	l_tab(l_tab.COUNT) := SUBSTR(l_string, l_index, l_comma_index - l_index);
      	l_index := l_comma_index + 1;
    END LOOP;
	RETURN l_tab;  
	
END SPLIT_VIRGOLE;

/