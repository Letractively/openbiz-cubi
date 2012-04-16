<?php 
class ConfDataTableWizardForm extends EasyFormWizard
{

	public function getActiveRecord($recId=null)
    {
        if ($this->m_ActiveRecord != null)
        {
            if($this->m_ActiveRecord['Id'] != null)
            {
                return $this->m_ActiveRecord;
            }
        }

        if ($recId==null || $recId=='')
            $recId = BizSystem::clientProxy()->getFormInputs('_selectedId');
        if ($recId==null || $recId=='')
            return null;
        $this->m_RecordId = $recId;
		$rec=array();
        
		$rec = $this->fetchTableInfo($recId);
        
		$this->m_DataPanel->setRecordArr($rec);
        $this->m_ActiveRecord = $rec;
        return $rec;
    }	
	
    public function fetchTableInfo($tableName)
    {
    	$dbConnForm = BizSystem::getObject("appbuilder.builder.ConfDBConnWizardForm");
		$dbRec = $dbConnForm->getActiveRecord();
		$dbName = $dbRec['NAME'];
		$db = BizSystem::instance()->getDBConnection($dbname);
		$tableInfos = $db->fetchAssoc("SHOW TABLE STATUS WHERE Name='$tableName'");
		return $tableInfos[0];
    }
    
    
	public function fetchDataSet()
	{
		$dbConnForm = BizSystem::getObject("appbuilder.builder.ConfDBConnWizardForm");
		$dbRec = $dbConnForm->getActiveRecord();
		$dbName = $dbRec['NAME'];
		$db = BizSystem::instance()->getDBConnection($dbname);
    	$tblCols = $db->listTables();
    	
		try
    	{
    		$tableInfos = $db->fetchAssoc("SHOW TABLE STATUS");
    		foreach($tableInfos as $tableInfo)
	    	{
	    		$tableInfo["Id"] = $tableInfo['Name'];
	    		$result[] = $tableInfo;
	    	}
    	}
    	catch(Exception $e){
	    	foreach($tblCols as $tableName)
	    	{
	    		$tableInfo=array(
	    			"Name"=>$tableName,
	    		);
	    		$tableInfo["Id"] = $tableInfo['Name'];
	    		$result[] = $tableInfo;
	    	}	
    	}
    	
		if(!$this->m_RecordId){
				$this->m_RecordId=$result[0]["Name"];
		}
    	return $result;
	}
	
}
?>