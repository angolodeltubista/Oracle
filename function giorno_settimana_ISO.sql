CREATE OR REPLACE
FUNCTION GIORNO_SETTIMANA_ISO
(	
	IN_GIORNO	DATE,	     -- Giorno da verificare
	IN_TIPO     VARCHAR2     -- Può valere ISO oppure AMERICA, restituisce 
)                            -- per ISO     Lunedì 1 ...  Sabato 6 Domenica 7 
                             -- per AMERICA Lunedì 2 ...  Sabato 7 Domenica 1     [Notazione di TimeCard!]   
                             -- Indipendentemente da  NLS_TERRITORY e NLS_DATE_LANGUAGE, non come succede con TO_CHAR(Date,'D')           
return varchar2 is   

	WK_NUMERO_GIORNO  VARCHAR2(1);   
    PROCEDURA TB_LOG.CD_PROCEDURA%TYPE := 'GIORNO_SETTIMANA_ISO';
    
BEGIN        

	-- Usata in sostituzione della TO_CHAR( Data, 'D') che dipende da  NLS_TERRITORY
	-- Se sul sistema NLS_TERRITORY=AMERICA il numero 1 è DOMENICA mentre sui client NLS_TERRITORY=ITALY il numero 1 è LUNEDI
	-- Questa funzione ritorna SEMPRE 1 per Lunedì e 7 per Domenica
	
	-- Sul DB di TimeCard usiamo sempre la notazione AMERICA quindi si deve togliere 1 al valore.
	
       
    IF IN_GIORNO IS NULL  THEN
    	RETURN '? Giorno' ;
    END IF;   

    IF IN_TIPO IS NULL  THEN
    	RETURN '? Tipo ISO/AMERICA' ;
    END IF;   

    IF IN_TIPO <> 'ISO' AND IN_TIPO <> 'AMERICA' THEN
    	RETURN '? Tipo ISO/AMERICA' ;
    END IF;             
    
    -- Day of week (1-7) and NLS settings
    -- 
    -- https://community.oracle.com/thread/2207756?tstart=0 
    
    -- What exactly does trunc(date, 'IW')?
    -- http://stackoverflow.com/questions/32603365/what-exactly-does-truncdate-iw
    
    --
    --          Do you just want an expression that, given a DATE, will return an integer (1 for Monday, ..., 7 for Sunday), independent of NLS settings?
    --			If so:  1 + TRUNC (dt)  - TRUNC (dt, 'IW')
		
    IF IN_TIPO = 'ISO' THEN                                                                      
        -- Restituisce Lun (1) Mar (2) .... Sab (6) Dom (7)
    	SELECT 1 + TRUNC (IN_GIORNO)  - TRUNC (IN_GIORNO, 'IW') INTO WK_NUMERO_GIORNO FROM DUAL;
    END IF; 
    
    IF IN_TIPO = 'AMERICA' THEN    
       -- Restituisce Lun (2) Mar (3) .... Sab (7) Dom (1)
    	SELECT 2 + TRUNC (IN_GIORNO)  - TRUNC (IN_GIORNO, 'IW') INTO WK_NUMERO_GIORNO FROM DUAL;    
    	IF WK_NUMERO_GIORNO = '8' THEN 
    		WK_NUMERO_GIORNO := '1'  ;
    	END IF ;
    END IF;
    
    
    RETURN WK_NUMERO_GIORNO;
	
	   	
END GIORNO_SETTIMANA_ISO;

/
