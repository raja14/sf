public with sharing class Form_PDFReviewController {
    
    Form_SectionDTOs.FieldSetMetaObjectResponseWrapper fieldSetMetaObjectResponse;
    
    Component.Apex.OutPutPanel vFComponents;    //OWNI DCCN POS FQF FMAF FMAF WHBK
    
    public Form_PDFReviewController(String accountFormId,String fiscalYear){
        
        Form_SectionService sectionService=new Form_SectionService();
        fieldSetMetaObjectResponse=sectionService.getAllFormDataByAccountFormIdAndFiscalYear(accountFormId,fiscalYear);
      
    }
    
    public Form_PDFReviewController(){
        
        
        String accountFormId=ApexPages.currentPage().getParameters().get('accountFormId');
        String fiscalYear=ApexPages.currentPage().getParameters().get('fiscalYear');
        system.debug('accountForm id passed is');
        system.debug(accountFormId);
        
        system.debug('fiscal year passed is');
        system.debug(fiscalYear);
        
        Form_SectionService sectionService=new Form_SectionService();
        fieldSetMetaObjectResponse=sectionService.getAllFormDataByAccountFormIdAndFiscalYear(accountFormId,fiscalYear);        
        		
              
        
    }
    
    public Component.Apex.OutputPanel buildSectionHeader(Form_SectionDTOs.SectionWrapperClass section){
        
        
        Component.Apex.OutPutPanel outPanel = new Component.Apex.OutPutPanel();
        outPanel.layout='block';
        outPanel.styleClass='panel-heading menu-level-'+section.level;
        
       // show text-left panel-heading menu-level-1 inactive collapsed cForm_Review
        Component.Apex.OutputText outText = new Component.Apex.OutputText();
		outText.value = '<div class="icon '+(section.status == 'VERIFIED'?'icon-verified-status':(section.status == 'COMPLETE'?'icon-complete-status':'icon-incomplete-status'))+'"></div><div class="section-heading">'+section.label+ '</div>';
		outText.escape = false;
        
        outPanel.childComponents.add(outText);
        
        return outPanel;
        
        
        
    }
    
    private Map<Id,FORM_Field_Response__c> getFieldResponsesByFieldId(String sectionFieldSetId){
        
        List<FORM_Field_Response__c> fieldResponseList=fieldSetMetaObjectResponse.fieldResponseBySectionFieldSet.get(sectionFieldSetId);
        Map<Id,FORM_Field_Response__c> fieldResponseByFieldId=new Map<Id,FORM_Field_Response__c>();
        
        if(fieldResponseList != null && fieldResponseList.size()>0){
        	
            for(FORM_Field_Response__c aFieldResponse:fieldResponseList){
            
                
                fieldResponseByFieldId.put(aFieldResponse.FORM_Field__c,aFieldResponse);
            
            }
        
        }
        
        
        
        return fieldResponseByFieldId;
        
        
    }
    
    
    private Map<String,FORM_Field_Response__c> getFieldResponsesByFieldName(String sectionFieldSetId,String fieldSetName){
        
        List<FORM_Field_Response__c> fieldResponseList=fieldSetMetaObjectResponse.fieldResponseBySectionFieldSet.get(sectionFieldSetId);
        Map<String,FORM_Field_Response__c> fieldResponseByName=new Map<String,FORM_Field_Response__c>();
        
        if(fieldResponseList != null && fieldResponseList.size()>0){
        	List<Form_MetaDTOs.FieldWrapperClass> fieldsList=fieldSetMetaObjectResponse.fieldsByTypeMap.get(fieldSetName); 
            Map<Id,Form_MetaDTOs.FieldWrapperClass> fieldMapById=new Map<Id,Form_MetaDTOs.FieldWrapperClass>();

            for(Form_MetaDTOs.FieldWrapperClass aFieldWrapperClass:fieldsList){
                
                fieldMapById.put(aFieldWrapperClass.id,aFieldWrapperClass);
            }
            
            
        	for(FORM_Field_Response__c aFieldResponse:fieldResponseList){
            
                Form_MetaDTOs.FieldWrapperClass fieldWrapperClass=fieldMapById.get(aFieldResponse.FORM_Field__c);
                fieldResponseByName.put(fieldWrapperClass.name,aFieldResponse);
            
            }
        
        }
        
        
        
        return fieldResponseByName;
        
    }
    
    private String getFieldValueAsString(Object fieldValue){
        
        if(fieldValue == null){
            
            return '';
        }
        
        
        if(fieldValue instanceof String){
            
            return (String)fieldValue;
        }    
        if(fieldValue instanceof Date){
            
            return ((Date)fieldValue).format();
            
        }
        if(fieldValue instanceof Integer){
            
            return String.valueOf(((Integer)fieldValue));       
        }
        if(fieldValue instanceof Long){
            
            return String.valueOf(((Long)fieldValue));       
        }
        if(fieldValue instanceof Decimal){
            
            return ((Decimal)fieldValue).toPlainString();
            
        }
        if(fieldvalue instanceof Boolean){
            
            return String.valueof((Boolean)fieldvalue);
        }
        
        
        return '#ERROR';
        
        
        
        
        
        
        
    }
    
    private String getFieldFromObject(Map<String,Object> fieldDataObjectMap,String fieldName){
        
        
        if(fieldDataObjectMap == null ||  fieldName == null){
            
            
            return '';
        }
        
      
        if(fieldDataObjectMap != null && fieldName.indexOf('.') <0){
            
            
			return  getFieldValueAsString(fieldDataObjectMap.get(fieldName)); 
        }else{
            
            
                   return getFieldFromObject((Map<String,Object>)fieldDataObjectMap.get(fieldName.substring(0,fieldName.indexOf('.'))),fieldName.substring(fieldName.indexOf('.')+1));     
            
        }
        
        
    }
    
    private String getConvertedFieldValueIfRequired(String fieldValue,Map<String,Object> fieldMetaMap){
        
        
        String changedFieldValue=fieldValue;
        
        if(fieldMetaMap.get('fieldType') != null && (((String)fieldMetaMap.get('fieldType')).equals('currency') || ((String)fieldMetaMap.get('fieldType')).equals('outputCurrency') )){
            
            
            if(String.isNotBlank(fieldValue)){
            
            if(fieldValue.indexOf('.')> 0){
                //it is double
               changedFieldValue= Math.ceil((Double.valueOf(fieldValue))).format();
              //  changedFieldValue=(Long.valueOf(fieldValue)).format();
            }else{
                
                
                changedFieldValue=(Long.valueOf(fieldValue)).format();
            }
            
            }
            /*String currencyFormat=fieldMetaMap.get('format') != null?(String)fieldMetaMap.get('format'):null;
            if(String.isBlank(currencyFormat)){
                
                currencyFormat='$#,###';
            }
            List<String> formatList=new List<String>();
            formatList.add(currencyFormat);
            changedFieldValue=String.format(changedFieldValue,formatList);*/
        } else if(fieldMetaMap.get('executeFunction') != null) {
            String executeFunction = (String) fieldMetaMap.get('executeFunction');
            if(String.isNotBlank(executeFunction) && executeFunction.equals('wrapText')) {
                changedFieldValue = wrapText(fieldValue);
            }
            
        } else if(fieldMetaMap.get('transformConfig') != null){
            
            List<Object> transFormConfigList=(List<Object>)fieldMetaMap.get('transformConfig');
            Map<String,Object> transformConfigMap;
            for(Object aTransFormConfig:transFormConfigList){
                transformConfigMap=(Map<String,Object>)aTransFormConfig;
                String whenValue=(String)transformConfigMap.get('whenValue');
                if(fieldValue.equals(whenValue)){
                    
                    changedFieldValue=(String)transformConfigMap.get('value');
                    break;
                    
                }
                
                
                
            }
            
            
            
        }
        
        else if(fieldMetaMap.get('formatterForBoolean') != null && ((String)fieldMetaMap.get('formatterForBoolean')).equals('YESNO')) {
            
            if(fieldValue.equals('true')){
                
                changedFieldValue='Yes';
            }
            else if(fieldValue.equals('false')){
                
                changedFieldValue='No';
            }
            
        }
        
        
        
        
        
        return changedFieldValue;
        
        
        
        
    }
    
    private String wrapText(String fieldValue) {
        Integer maxLengthAllowed = Form_Constants.MAX_LINE_LENGTH_FOR_PDF_CARD;
        String modifiedValue = '';
        if(String.isNotBlank(fieldValue) && fieldValue.length() > maxLengthAllowed) {
            modifiedValue = splitTextIntoSpans(fieldValue, modifiedValue);
        } else {
        	return fieldValue;
        }
        return modifiedValue;
    }
    
    private String splitTextIntoSpans(String fieldValue, String modifiedValue) {
        Integer maxLengthAllowed = Form_Constants.MAX_LINE_LENGTH_FOR_PDF_CARD;
        if(fieldValue.length() > maxLengthAllowed) {
            modifiedValue = modifiedValue + fieldValue.subString(0,maxLengthAllowed) + '<br>';
            fieldValue = fieldValue.subString(maxLengthAllowed);   
            modifiedValue = splitTextIntoSpans(fieldValue, modifiedValue);
        } else {
            return modifiedValue + fieldValue;    
        }
        return modifiedValue;
    }
    
    private String getFieldValue(Map<String, Object> fieldDataMap,Map<String,Object> fieldMetaMap){
        
        
        system.debug('field Data Map is');
        system.debug(fieldDataMap);
        
        system.debug('field Meta data is');
        system.debug(fieldMetaMap);
        
        String fieldName=(String)fieldMetaMap.get('fieldName');
        
        String fieldValue='';
        
        if(fieldName != null && fieldName.indexOf(',')>-1){
            
            String[] fieldNameList=fieldName.split(',');
            for(String aFieldName:fieldNameList){
                
                fieldValue=fieldValue+getFieldFromObject(fieldDataMap,aFieldName)+' ';
                
                
            }
            
            fieldValue=fieldValue.trim();
        }else{
            
           fieldValue=getFieldFromObject(fieldDataMap,fieldName);
            
           }
        
       /* if(field.hideOnConfig != null){
            
            
            
            
        }*/
        
        
        return fieldValue;
        
    }
    
    private  Component.Apex.OutputPanel  buildMatrixLayout(Form_MetaDTOs.FieldSetWrapperClass sectionFieldSet){
        
        system.debug('building matrx layout ');
        system.debug(sectionFieldSet.type);
        
        Map<String,Object> gridAttributeMap=(Map<String,Object>)((Map<String,Object>)sectionFieldSet.config).get('gridDataAttributes');
        String recordType=(String)gridAttributeMap.get('recordType');
        
         Component.Apex.OutputPanel outPutPanel=new Component.Apex.OutputPanel();
        	outPutPanel.layout='block';
        Object dataObject=fieldSetMetaObjectResponse.objectsBySectionFieldSetMap.get(recordType);
        system.debug('data object for fieldset ');
        system.debug(dataObject);
        
         if(dataObject != null) {
        
             List<Object> objectList=(List<Object>)dataObject;
             String headerText=(String)((Map<String,Object>)sectionFieldSet.layoutConfig).get('headerText');
             headerText='<div class="static-text">'+headerText+'</div>' ;
             
             Map<String,Object> matrixLayout=(Map<String,Object>)((Map<String,Object>)sectionFieldSet.layoutConfig).get('matrixLayout');
             Map<String,Object> colConfig=(Map<String,Object>)matrixLayout.get('colConfig');
             
            String columnNameMappingField=(String)colConfig.get('fieldName');
             
             List<Object> rowHeaders=(List<Object>)matrixLayout.get('rowHeader');
             
             List<Object> elements=(List<Object>)matrixLayout.get('elementConfig');
             
             Boolean isRowTotalRequired=false;
             Boolean isColumnTotalRequired=false;
             Map<String,String> calucationFieldMap=new Map<String,String>();
             
             Map<String,Object> matrixConfig=(Map<String,Object>)matrixLayout.get('matrixConfig');
             
             if(matrixConfig != null){
             
             	isColumnTotalRequired=matrixConfig.get('columnTotal') != null?(Boolean)matrixConfig.get('columnTotal'):false;
            
             
             Map<String,Object> rowTotalConfig=(Map<String,Object>)matrixConfig.get('rowTotalConfig');
                 
                 if(rowTotalConfig != null){
             
             	isRowTotalRequired=rowTotalConfig.get('rowTotal') != null?(Boolean)rowTotalConfig.get('rowTotal'):false;
             
             	String calculationFieldNamesOnRowTotal=(String)rowTotalConfig.get('calculatedField');
             
             	List<String> calculationFieldNamesOnRowTotalList=calculationFieldNamesOnRowTotal.split(',');
             	for(String aCalucationFieldName: calculationFieldNamesOnRowTotalList){
                 
                	 calucationFieldMap.put(aCalucationFieldName,aCalucationFieldName);
                 
             	}
          	}
             
         }
             
             
             
             String matrixHtml='<div><table class="gridTable slds-max-medium-table--stacked-horizontal"><thead class="tableHeader"><tr>';
             
             for(Object rowObject:rowHeaders){
                 
                 Map<String,Object> rowFieldMap=(Map<String,Object>)rowObject;
                 
                 matrixHtml=matrixHtml+'<th>'+ (String)rowFieldMap.get('label')+'</th>';
                 
                 
             }
             matrixHtml=matrixHtml+'</tr>';
             
             Map<Integer,Double> columnByTotalMap=new Map<Integer,Double>();
             String fieldValue='';
             
             Integer columnIndex=0;
             Integer rowIndex=0;
             Double totalRowSum=0;
             for(Object anObject:objectList){
            
                 columnIndex=0;
                 Map<String, Object> dataObjectFieldsMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(anObject));
                  
                 matrixHtml=matrixHtml+'<tr><td class="matrix-header-col">'+(String)dataObjectFieldsMap.get(columnNameMappingField)+'</td>';
                 Double currentRowTotal=0;
             		    
              		for(Object aFieldMetaObject:elements){
                        
                        Map<String,Object> fieldMetaMap=(Map<String,Object>)aFieldMetaObject; 
                        
                        boolean isCalculatedField=fieldMetaMap.get('isCalculatedField') != null?(Boolean)fieldMetaMap.get('isCalculatedField'):false;
                        
                        String fieldCssClass=fieldMetaMap.get('cssClass') != null?(' '+(String)fieldMetaMap.get('cssClass')):'';
                        
                        if(!isCalculatedField){
                        
                        	fieldValue=getFieldValue(dataObjectFieldsMap,fieldMetaMap);
                            
                            matrixHtml=matrixHtml+'<td class="'+fieldCssClass+'" >'+ getConvertedFieldValueIfRequired(fieldValue,fieldMetaMap)+'</td>';
                            String fieldName=(String)fieldMetaMap.get('fieldName');
                            system.debug('field value being converted to double is '+fieldValue);
                            if(calucationFieldMap.get(fieldName) != null){
                                currentRowTotal=Double.valueOf(currentRowTotal)+(String.isNotBlank(fieldValue)?Double.valueOf(fieldValue):0);
                            }
                            
                            
                            
                         
                        
                        if(columnByTotalMap.get(columnIndex) != null){
                            
                            columnByTotalMap.put(columnIndex,(columnByTotalMap.get(columnIndex)+(String.isNotBlank(fieldValue)?Double.valueOf(fieldValue):0)));
                            
                        }else{
                            
                            
                            columnByTotalMap.put(columnIndex,(String.isNotBlank(fieldValue)?Double.valueOf(fieldValue):0));
                        }
                        
                      	 columnIndex++;
                        } 
                 	}
                 totalRowSum=totalRowSum+currentRowTotal;
                 if(isRowTotalRequired){
                    System.debug('currentRowTotal value is : '+ currentRowTotal);
                    matrixHtml=matrixHtml+'<td class="matrix-total-col">'+(currentRowTotal.longValue()).format()+'</td>'; 
                 }
                 
                 matrixHtml=matrixHtml+'</tr>';
                 rowIndex++;
           	
        		}
             
             
             if(isColumnTotalRequired){
             	matrixHtml=matrixHtml+'<tr><td class="matrix-header-col matrix-total-col">Totals</td>';
             	List<Integer> colIndexList=new List<Integer>(columnByTotalMap.keySet());
             	colIndexList.sort();
             	for(Integer aColumnIndex:colIndexList){
                 
					matrixHtml=matrixHtml+'<td class="matrix-total-col">'+(Math.ceil((columnByTotalMap.get(aColumnIndex))).longValue()).format()+'</td>' ;               
                 }
             }
             
             if(isRowTotalRequired){
                     
                    matrixHtml=matrixHtml+'<td class="matrix-total-col ">'+(totalRowSum.longValue()).format()+'</td>'; 
                 }
             
             
             matrixHtml=matrixHtml+'</tr></table></div>';
            Component.Apex.OutputText matrixContent = new Component.Apex.OutputText();
			matrixContent.value = headerText+matrixHtml;
			matrixContent.escape = false;
        
        	outputPanel.childComponents.add(matrixContent);
         } else {
             System.debug(' No data for Matrix '+ sectionFieldSet.type);
             Component.Apex.OutputPanel noResponsePanel = buildNoResponsePanel();
             outputPanel.childComponents.add(noResponsePanel);
         }
        
        return outputPanel;
        
    }
    
    private Component.Apex.OutputPanel buildNoResponsePanel() {
    	Component.Apex.OutputPanel noResponsePanel = new Component.Apex.OutputPanel();
        noResponsePanel.layout='block';
        noResponsePanel.styleClass='response';
        
        Component.Apex.OutputText outputText = new Component.Apex.OutputText();
        outputText.value = 'No Response was recorded for the Section';
        outputText.escape = false;
		outputText.styleClass = 'comment';
        
        noResponsePanel.childComponents.add(outputText);
        
        return noResponsePanel;
    }
    
    private Component.Apex.OutputPanel buildLenderProfileInfo(Form_MetaDTOs.FieldSetWrapperClass sectionFieldSet){
        
        Component.Apex.OutputPanel lenderProfileInfoPanel=new Component.Apex.OutputPanel();
        Object dataObject=fieldSetMetaObjectResponse.objectsBySectionFieldSetMap.get(sectionFieldSet.type);
        ECRM_AccountDTOs.AccountWrapper  accountWrapper=(ECRM_AccountDTOs.AccountWrapper)dataObject;
        
        Map<String, Object> dataObjectFieldsMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(accountWrapper));
        
        system.debug('layout config for lender profile info is');
        system.debug(sectionFieldSet.layoutConfig);
      	Map<String,Object> layoutConfigMap=(Map<String,Object>)sectionFieldSet.layoutConfig;
        String staticText=layoutConfigMap.get('staticText') != null?(String)layoutConfigMap.get('staticText'):null;
        Map<String,Object> gridLayout=(Map<String,Object>)layoutConfigMap.get('gridLayout');
        
        List<Object> rowsList=(List<Object>)gridLayout.get('rows');
        Component.Apex.OutputText outputText =new Component.Apex.OutputText();
        
        String htmlText=staticText != null?'<div class="statci-text">'+staticText+'</div>':'';
        Map<String,Object> fieldMetaMap;
        
       
        
        
        
        htmlText=htmlText+'<table class="card-table">';
        for(Object aFieldsListRow:rowsList){
            
            List<Object> fieldsList=(List<Object>)aFieldsListRow;
            htmlText=htmlText+'<tr class="table-card-row">';
            
            for(Object aFieldMetaObject: fieldsList){
                
                fieldMetaMap=(Map<String,Object>)aFieldMetaObject;
                String fieldName=(String)fieldMetaMap.get('field');
                system.debug('field Name is ::'+fieldName);
                system.debug('dataObjectFieldsMap is ::'+dataObjectFieldsMap);
                htmlText=htmlText+'<td class="table-card-column table-card-col-label">'+(String)fieldMetaMap.get('label')+'</td><td class="table-card-column">'+getFieldValueAsString(dataObjectFieldsMap.get(fieldName))+'</td>';
                
                
            }
            
            htmlText=htmlText+'</tr>';
            
        }
        htmlText=htmlText+'</table>';
        outputText.value=htmlText;
        outputText.escape=false;
        lenderProfileInfoPanel.childComponents.add(outputText);
        
        
        
        List<Object> addressList=new List<Object>();
        addressList.add(accountWrapper.mailingAddress);
        addressList.add(accountWrapper.physicalAddress);
        List<Component.Apex.OutputPanel> addressCards=buildCardLayout(sectionFieldSet,addressList);
        
        Component.Apex.OutputPanel addressPanel=new Component.Apex.OutputPanel();
        addressPanel.layout='block';
        for(Component.Apex.OutputPanel anAdressCard: addressCards){
        	addressPanel.childComponents.add(anAdressCard);
        }
        
        lenderProfileInfoPanel.childComponents.add(addressPanel);
        
        return lenderProfileInfoPanel;
        
        
        
    }
    
    private List<Component.Apex.OutputPanel> buildCardLayout(Form_MetaDTOs.FieldSetWrapperClass sectionFieldSet){
        
        return buildCardLayout(sectionFieldSet,null);
    }
    
    private List<Component.Apex.OutputPanel> buildCardLayout(Form_MetaDTOs.FieldSetWrapperClass sectionFieldSet,Object dataObject){
        System.debug('Section Type name '+ sectionFieldSet.name);
        if(dataObject == null){
        
        	dataObject=fieldSetMetaObjectResponse.objectsBySectionFieldSetMap.get(sectionFieldSet.type);
        }
        system.debug('data Object is');
        system.debug(dataObject);
        
        
        List<Component.Apex.OutputPanel> cardsContainerList=new List<Component.Apex.OutputPanel>();
        
            
        if(dataObject != null){
        	System.debug('In side Data object '+ sectionFieldSet.name);
            List<Object> objectList=(List<Object>)dataObject;
            Component.Apex.OutputPanel cardContainer=null;
             Component.Apex.OutputPanel card=null;
            Component.Apex.OutputPanel cardOuter = null;
            Component.Apex.OutputPanel cardRow=null;
            Component.Apex.OutputText outputText =null;
             Integer cardCount=0;
            
            
            if(objectList != null && objectList.size() > 0) {
                for(Object anObject:objectList) {
            
            		Map<String, Object> dataObjectFieldsMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(anObject));
                
                	system.debug('data Objects fields Map');
                   system.debug(dataObjectFieldsMap);
                	system.debug('fieldSet.layoutConfig is after serua');
                    system.debug(JSON.serialize(sectionFieldSet.layoutConfig));
                
                
                    //Form_SectionDTOs.FieldLayoutConfig fieldLayoutConfig=(Form_SectionDTOs.FieldLayoutConfig)JSON.deserialize(JSON.serialize(fieldSet.layoutConfig),Form_SectionDTOs.FieldLayoutConfig.class);			                	
                   //List<Form_SectionDTOs.Field> fieldsList=fieldLayoutConfig.fieldsConfig;
                   //
                   
                List<Object> fieldsList=(List<Object>)((Map<String,Object>)sectionFieldSet.layoutConfig).get('fieldsConfig');
                
                 
                 system.debug('fieldsList is');
                system.debug(fieldsList);
                
                
                 if(math.mod(cardCount,2) ==0){
                
                	cardContainer=new Component.Apex.OutputPanel();
					cardContainer.styleClass='card-container';
                	cardContainer.layout='block';
                     cardsContainerList.add(cardContainer);
                
                 }        
                	cardOuter = new Component.Apex.OutputPanel();
                	cardOuter.layout = 'block';
                	cardOuter.styleClass='card-outer';
                        
                	 card=new Component.Apex.OutputPanel();
                     card.layout='block';
                     card.styleClass='card';
                
                	//cardOuter.childComponents.add(card);
                
                	for(Object aFieldMap: fieldsList){
                    
                        Map<String,Object> fieldMap=(Map<String,Object> )((Map<String,Object> )aFieldMap).get('field');
                        
                        system.debug('field Map is');
                        system.debug(fieldMap);
                        cardRow=new Component.Apex.OutputPanel();
                     	cardRow.layout='block';
                        cardRow.styleClass='card-row';
                        
                        outputText = new Component.Apex.OutputText();
                        
                        String fieldCssClass=fieldMap.get('cssClass') != null?(' '+(String)fieldMap.get('cssClass')):'';
                        String fieldType=fieldMap.get('fieldType') != null?(String)fieldMap.get('fieldType'):'';
                        system.debug('hide on config is ::'+fieldMap.get('hideOnConfig'));
                        boolean isDisplayField=true;
                        Map<String,Object> hideOnConfigMap=fieldMap.get('hideOnConfig') != null?(Map<String,Object>)fieldMap.get('hideOnConfig'):null;
                        if(hideOnConfigMap != null){
                            String hideOnFieldName=hideOnConfigMap.get('field') != null?(String)hideOnConfigMap.get('field'):'';
                            String hideOnFieldConfiguredValue=hideOnConfigMap.get('value') != null?(String)hideOnConfigMap.get('value'):'';
                            system.debug('hideOnFieldName*****'+hideOnFieldName);
                            system.debug('hideOnValue*****'+hideOnFieldConfiguredValue);
                            if(String.isNotBlank(hideOnFieldName) && String.isNotBlank(hideOnFieldConfiguredValue)){
                           		String hideOnFieldAcutalValue=getFieldFromObject(dataObjectFieldsMap,hideOnFieldName);
                                	if(String.isNotBlank(hideOnFieldAcutalValue) && hideOnFieldAcutalValue.equals(hideOnFieldConfiguredValue)){
                                    
                                    	isDisplayField=false;
                                	}
                                
                                }
                        }
                        
                        
                        system.debug('fieldType class is');
                        system.debug(fieldType);
                        if(String.isNotBlank(fieldType) && fieldType.equals('header')){
                        
                        		outputText.value='<div class="card-header"><div>'+getConvertedFieldValueIfRequired(getFieldValue(dataObjectFieldsMap,fieldMap),fieldMap)+'</div></div>';
                        }else{
                            if(isDisplayField){
								outputText.value = '<div class=\'card-row-div\'>'+(String)fieldMap.get('label')+'</div><div class="card-row-div'+fieldCssClass+'">'+getConvertedFieldValueIfRequired(getFieldValue(dataObjectFieldsMap,fieldMap),fieldMap)+'</div>';
                            }
                        }
                        
                        //outputText.value = '<div>test</div><div>test2</div>';
						outputText.escape = false;
                        
                        system.debug('output text value is');
                        system.debug(outputText.value);
                        if(isDisplayField){
                        	cardRow.childComponents.add(outputText);
                        	card.childComponents.add(cardRow);
                        }
                    
                    
                	}
                
                    cardContainer.childComponents.add(card);
                    cardCount++;
                          
                        
               }
            } else {
                // For approved affiliates, list is coming empty in case of no records
                Component.Apex.OutputPanel noResponsePanel = buildNoResponsePanel();
             	cardsContainerList.add(noResponsePanel);
            }
            
        } else {
            System.debug('In Else condition for section '+ sectionFieldSet);
             Component.Apex.OutputPanel noResponsePanel = buildNoResponsePanel();
             cardsContainerList.add(noResponsePanel);
        }
        
        
        
        
        
        return cardsContainerList;
        
    }
    
    
    private Component.Apex.OutputPanel buildGenericFieldSet(Form_MetaDTOs.FieldSetWrapperClass sectionFieldSet){
        
        
            Component.Apex.OutputPanel outPutPanel=new Component.Apex.OutputPanel();
        	outPutPanel.layout='block';
        
        	Map<Id,FORM_Field_Response__c> fieldResponseByFieldId=getFieldResponsesByFieldId(sectionFieldSet.id);
        
        
        	List<Form_MetaDTOs.FieldWrapperClass> fieldsList=fieldSetMetaObjectResponse.fieldsByTypeMap.get(sectionFieldSet.name); 
        	fieldsList.sort();
        	Component.Apex.OutputText outputText = new Component.Apex.OutputText();
        
           String htmlText='';
           String checkBoxCssClass='checkbox-deselected';
        	boolean isSelected=false;
        
       		for(Form_MetaDTOs.FieldWrapperClass aFieldWrapperClass: fieldsList){
            
                
                if(aFieldWrapperClass.type.equals('MUL')){
                
                     
		      		isSelected=false;
                    checkBoxCssClass='checkbox-deselected';
                    if(fieldResponseByFieldId.get(aFieldWrapperClass.id) != null && String.isNotBlank(fieldResponseByFieldId.get(aFieldWrapperClass.id).FORM_Response_Value__c)){
                    	isSelected=Boolean.valueOf((fieldResponseByFieldId.get(aFieldWrapperClass.id).FORM_Response_Value__c));
                    }
                    if(isSelected){
                        
                        checkBoxCssClass='checkbox-selected';
                    }
                    
               	  	htmlText =htmlText+'<div><div class="'+checkBoxCssClass+'"></div><div class="checkbox-label">'+aFieldWrapperClass.label+'</div></div>';
			   		
                }else if(aFieldWrapperClass.type.equals('TXA')){ //text area
                    
                    
                    	
                    if(fieldResponseByFieldId.get(aFieldWrapperClass.id) != null && String.isNotBlank(fieldResponseByFieldId.get(aFieldWrapperClass.id).FORM_Response_Value__c)){
                        
                        htmlText =htmlText+'<div class="response"><div>'+aFieldWrapperClass.label+'</div><div class="comment">'+fieldResponseByFieldId.get(aFieldWrapperClass.id).FORM_Response_Value__c+'</div></div>';
                        
                        
                    }


                    
                    
                }
                
        
           
            
            
            
       }
        outputText.value=htmlText;
        outputText.escape = false;
        outputPanel.childComponents.add(outputText);
        
        
        
        
        return outputPanel;
        
        
    }
    
    
    private List<Component.Apex.OutputPanel> buildQuestionAnswerFieldSet(Form_MetaDTOs.FieldSetWrapperClass sectionFieldSet){
        
        
        List<Component.Apex.OutputPanel> outPutPanelList=new List<Component.Apex.OutputPanel>();
        
        Component.Apex.OutputPanel outPutPanel=new Component.Apex.OutputPanel();
        outPutPanel.layout='block';
        outPutPanel.styleClass='question-text-review';
        
        Component.Apex.OutputText contentText = new Component.Apex.OutputText();
        if(sectionFieldSet.contents != null){
			contentText.value = sectionFieldSet.contents.get('text');
        }
		contentText.escape = false;

        
        outputPanel.childComponents.add(contentText);
        
        outPutPanelList.add(outputPanel);
        
      //  outPutPanel=new Component.Apex.OutputPanel();
      //  outPutPanel.layout='block';
        
        
        Map<String,FORM_Field_Response__c> responseMapByFieldName=getFieldResponsesByFieldName(String.valueOf(sectionFieldSet.id),sectionFieldSet.name);
        
        FORM_Field_Response__c answerFieldResponse=responseMapByFieldName.get('answer');
        FORM_Field_Response__c commentFieldResponse=responseMapByFieldName.get('comment');
        Component.Apex.OutputPanel answerOutPutPanelWrapper=null;
        Component.Apex.OutputPanel commentOutPutPanelWrapper=null;
        
        system.debug('answerFieldResponse for fieldSet');
        
        system.debug(sectionFieldSet);
        system.debug(answerFieldResponse);
        
        Component.Apex.OutputPanel responsePanelWrapper=null;
        
        if(answerFieldResponse != null && String.isNotBlank(answerFieldResponse.FORM_Response_Value__c)){
            
            responsePanelWrapper=new Component.Apex.OutputPanel();
            responsePanelWrapper.layout='block';
            responsePanelWrapper.styleClass='response';
            answerOutPutPanelWrapper=new Component.Apex.OutputPanel();
        	answerOutPutPanelWrapper.layout='block';
            
            Component.Apex.OutputPanel answerOutPutPanel=new Component.Apex.OutputPanel();
        	answerOutPutPanel.layout='block';
        	
        	Component.Apex.OutputText outputText = new Component.Apex.OutputText();
			outputText.value = 'Response';
			outputText.escape = false;
            
            answerOutPutPanel.childComponents.add(outputText);
            
            answerOutPutPanelWrapper.childComponents.add(answerOutPutPanel);
            
            
            answerOutPutPanel=new Component.Apex.OutputPanel();
        	answerOutPutPanel.layout='block';
            answerOutPutPanel.styleClass='answer';
        	
        	outputText = new Component.Apex.OutputText();
			outputText.value =answerFieldResponse.FORM_Response_Value__c ;
			outputText.escape = false;
            answerOutPutPanel.childComponents.add(outputText);
            answerOutPutPanelWrapper.childComponents.add(answerOutPutPanel);
            
            responsePanelWrapper.childComponents.add(answerOutPutPanelWrapper);
            
            
            
        }
        if(commentFieldResponse != null &&  String.isNotBlank(commentFieldResponse.FORM_Response_Value__c)){
            
            if(responsePanelWrapper == null){
                
                responsePanelWrapper=new Component.Apex.OutputPanel();
            	responsePanelWrapper.layout='block';
                responsePanelWrapper.styleClass='response';
                
            }
            
            commentOutPutPanelWrapper=new Component.Apex.OutputPanel();
        	commentOutPutPanelWrapper.layout='block';
            commentOutPutPanelWrapper.styleClass='medium-space-top';
            
            Component.Apex.OutputPanel commentOutPutPanel=new Component.Apex.OutputPanel();
        	commentOutPutPanel.layout='block';
        	
        	Component.Apex.OutputText outputText = new Component.Apex.OutputText();
			outputText.value = 'Comment';
			outputText.escape = false;
            
            commentOutPutPanel.childComponents.add(outputText);
            
            commentOutPutPanelWrapper.childComponents.add(commentOutPutPanel);
            
            
            commentOutPutPanel=new Component.Apex.OutputPanel();
        	commentOutPutPanel.layout='block';
            commentOutPutPanel.styleClass='comment';
        	
        	outputText = new Component.Apex.OutputText();
			outputText.value =commentFieldResponse.FORM_Response_Value__c ;
			outputText.escape = false;
            commentOutPutPanel.childComponents.add(outputText);
            commentOutPutPanelWrapper.childComponents.add(commentOutPutPanel);
            responsePanelWrapper.childComponents.add(commentOutPutPanelWrapper);
                        
            
            
        }
        if(responsePanelWrapper != null){
            
            outPutPanelList.add(responsePanelWrapper);
        }else{
            
            system.debug('in no response recorded section');
            system.debug(sectionFieldSet);
            
            Map<String,Object> configMap=(Map<String,Object>)sectionFieldSet.config; 
            
            boolean isHideButtons=configMap.get('hideButtons')  != null?(Boolean)configMap.get('hideButtons'):false;
            
            system.debug(answerFieldResponse);
             system.debug(commentFieldResponse);
            system.debug('hide buttons');
            system.debug(isHideButtons);            
            if(((answerFieldResponse == null || String.isBlank(answerFieldResponse.FORM_Response_Value__c))  && !isHideButtons) || (isHideButtons && (commentFieldResponse == null  || String.isBlank(commentFieldResponse.FORM_Response_Value__c)))){
                responsePanelWrapper=new Component.Apex.OutputPanel();
            	responsePanelWrapper.layout='block';
            	responsePanelWrapper.styleClass='response';
                
                Component.Apex.OutputText outputText = new Component.Apex.OutputText();
				outputText.value = 'No response recorded';
				outputText.escape = false;
                
                responsePanelWrapper.childComponents.add(outputText);
                outPutPanelList.add(responsePanelWrapper);

                
                
            }
            
            
        }
        
		
        
        
        
 		
        
        
        
        
        return outPutPanelList;
        
        
    }
    
    
    
    private  List<Component.Apex.OutputPanel> buildFieldSetPdfContent(List<Form_MetaDTOs.FieldSetWrapperClass> fieldSetList){
        
        fieldSetList.sort();
        List<Component.Apex.OutputPanel> outPanelList=new List<Component.Apex.OutputPanel>();
        for(Form_MetaDTOs.FieldSetWrapperClass aFieldSet:fieldSetList){
            
            
            if(aFieldSet.type == 'YSNO'){
                
                
                outPanelList.addAll(buildQuestionAnswerFieldSet(aFieldSet));
                
            }else if(Form_Constants.FORM_CARD_FIELD_SET_TYPES.contains(aFieldSet.type)){
                
                outPanelList.addAll(buildCardLayout(aFieldSet));
                
                //buildCardLayout(aFieldSet);
                
            }else if(aFieldSet.type.equals(Form_Constants.MATRIX_FIELD_SET_TYPE)){
                
                
					outPanelList.add(buildMatrixLayout(aFieldSet));                
            }else if(Form_Constants.MULTI_CHECK_OPTION_FIELD_SET_TYPES.contains(aFieldSet.type)){
                
                outPanelList.add(buildGenericFieldSet(aFieldSet));
                
                
            }else if(aFieldSet.type.equals(Form_Constants.LENDER_PROFILE_INFO_FIELD_SET_TYPE)){
                
                outPanelList.add(buildLenderProfileInfo(aFieldSet));
                
                
            }
            
            
        }
        
        
        
        
       return outPanelList;       
        
        
    }
    



    private void buildPDFContent(Component.Apex.OutPutPanel outerPanel,List<Form_SectionDTOs.SectionWrapperClass> sectionsList){
        
        
        
        
        
        
        
        for(Form_SectionDTOs.SectionWrapperClass aSection:sectionsList){
            
            
            outerPanel.childComponents.add(buildSectionHeader(aSection));
            
            
            if(aSection.childSections != null && aSection.childSections.size()>0){
                
                buildPDFContent(outerPanel,aSection.childSections);
                
            }
            else{
                
                List<Component.Apex.OutputPanel> fieldsetOutPutPanelList=buildFieldSetPdfContent(aSection.fieldSetList);
                
                for(Component.Apex.OutputPanel aOutPutPanel:fieldsetOutPutPanelList){
                    outerPanel.childComponents.add(aOutPutPanel);
                    
                  }
                
                
                //must be fieldset
                
            }
            
            
        }
        
        
        
    }
    
    
    public Component.Apex.OutPutPanel getVFComponents() {
        

		Component.Apex.OutPutPanel outerPanel = new Component.Apex.OutPutPanel();
        outerPanel.layout='block';
        
        List<Form_SectionDTOs.SectionWrapperClass> sectionsList=fieldSetMetaObjectResponse.sectionWrapperList;
        
        buildPDFContent(outerPanel,sectionsList);
        
        return outerPanel;

    }

}
