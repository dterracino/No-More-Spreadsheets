﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewQuote.aspx.cs" Inherits="ViewQuote" MasterPageFile="~/MasterPage.master"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript" src="ext/examples/ux/RowExpander.js"></script>
<script type="text/javascript" src="Data.aspx?view=Model&model=PricedProducts" ></script>
<script type="text/javascript" src="Data.aspx?view=Model&model=PricedPackages" ></script>
<script type="text/javascript" src="Data.aspx?view=ExtModelAndStore&model=QuoteItems&QuoteId=<%=this.quoteId %>" ></script>
<script type="text/javascript" src="pricing/js/Dialogs.js"></script>
<link rel="stylesheet" type="text/css" href="ext/icon_packs/fugue/css/fugue-pack.css" />
<script type="text/javascript">
    Ext.onReady(function(){
        /**
         * Get the cost of the record
         * @return the string of cost (both unit and total)
         */
        function InternalCostRenderer (val, b, record){
            return Ext.util.Format.currency (parseInt(record.data.Quantity)*parseFloat(record.data.SetupCost)) + "/"+ Ext.util.Format.currency (parseInt(record.data.Quantity)*parseFloat(val)) ;
        }

        function ProductDescription (val, b, record){
            var desc= "<b>"+val+ "</b><br/>"+record.data.Description;
            if ( record.data.Notes != null && record.data.Notes!='' && record.data.Notes!='<br>' ) 
                desc +="<br/><b>Notes:</b><br/>"+record.data.Notes;
            return desc;
        }

        /**  
         * Get the items selected in the quote item grid by the user
         * @return the array of selected row items
         */
        function GetSelectedQuoteItems(){
            return quoteItemsGrid.selModel.selected.items;
        }
	
        /** 
         * Get the number of selected items in the quote grid
         * @return number (int) of selected items
         */
        function GetNumSelectedQuoteItems(){
            return quoteItemsGrid.selModel.selected.length;
        }		
	 
        /**
         * Add up the cost and price of an array of products
         * @param parts (array) Array of product records
         * @return json
         */	
        function AddupCost( parts ){
            var totalCost = { setupcost: 0.0, setupprice: 0.0, recurringprice: 0.0, recurringcost:0.0 } ;
            for (var i in parts){
                totalCost.setupcost += parseFloat(parts[i].SetupCost);
                totalCost.recurringcost += parseFloat(parts[i].RecurringCost);
                totalCost.recurringprice += parseFloat(parts[i].RecurringPrice);
                totalCost.setupprice += parseFloat(parts[i].SetupPrice);
            }
            return totalCost;
        }
	
        /**
         * Update the price of the server configured in the current window
         * @return null
         */
        function UpdatePrice(){
            var form = this.ownerCt;
            var products=new Array();
            for ( var i in form.items.items ) {
                if ( form.items.items[i].alternateClassName=='Ext.form.ComboBox' ) { // is a drop-down
                    var cmp = form.items.items[i];
                    if (cmp.value !=null && cmp.valueModels.length > 0) 	
                        products.push(cmp.valueModels[0].data);
                }
            }
            // Calculate Costs
            var totalCost = AddupCost( products );
            form.getComponent('cost').setValue(Ext.util.Format.currency(totalCost.setupcost,'<%=this.html_currency_char%>')+" setup, "+Ext.util.Format.currency(totalCost.recurringcost,'<%=this.html_currency_char%>')+" recurring");
            form.getComponent('price').setValue(Ext.util.Format.currency(totalCost.setupprice,'<%=this.html_currency_char%>')+" setup, "+Ext.util.Format.currency(totalCost.recurringprice,'<%=this.html_currency_char%>')+" recurring");
        }		
	
        /**
         * Update the quote totals on the right hand side after any changes to the quote item store
         * new values are written directly to the corresponding labels.
         * @return null
         */
        function recalculateTotals (){
            var total12Cost = 0.0, total24Cost = 0.0, total36Cost = 0.0, totalRecurringPrice = 0.0;
            var total12InternalCost = 0.0, total24InternalCost = 0.0, total36InternalCost = 0.0;
            var totalSetupPrice = 0.0;
		
            for (var i = 0; i< Ext.data.StoreManager.lookup('QuoteItemsStore').data.length; i++){
                if (Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.GroupName !=  'Options') {
                    totalRecurringPrice+=parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.TotalRecurringPrice);
                    totalSetupPrice+=parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.TotalSetupPrice);
                    total12InternalCost+=((parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.Quantity) * parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.RecurringCost))*12) + (parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.Quantity) * parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.SetupCost));
                    total24InternalCost+=((parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.Quantity) * parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.RecurringCost))*24) + (parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.Quantity) * parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.SetupCost));
                    total36InternalCost+=((parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.Quantity) * parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.RecurringCost))*36) + (parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.Quantity) * parseFloat(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data.SetupCost));
                }
            }
		
            var pre = totalRecurringPrice * (1-Ext.getCmp('discountSlider').getValue()/100.0);
            totalRecurringPrice = pre - Ext.getCmp('writeinField').getValue();
            totalSetupPrice= totalSetupPrice * (1-Ext.getCmp('discountSliderSetup').getValue()/100.0);
            total24Price = pre * (1-Ext.getCmp('discountSlider24').getValue()/100.0) - Ext.getCmp('writeinField').getValue();
            total36Price = pre * (1-Ext.getCmp('discountSlider36').getValue()/100.0) - Ext.getCmp('writeinField').getValue();
            Ext.getCmp('setup_total').setValue (Ext.util.Format.currency(totalSetupPrice,'<%=this.html_currency_char%>'));
            Ext.getCmp('annual_1yr').setValue (Ext.util.Format.currency(totalRecurringPrice,'<%=this.html_currency_char%>'));
            Ext.getCmp('annual_2yr').setValue (Ext.util.Format.currency(total24Price,'<%=this.html_currency_char%>'));
            Ext.getCmp('annual_3yr').setValue (Ext.util.Format.currency(total36Price,'<%=this.html_currency_char%>'));
		
            // calculate 1 and 2 year margins.
            var in_12 = (totalRecurringPrice*12+totalSetupPrice);
            var in_24 = (total24Price*24+totalSetupPrice);
            var in_36 = (total36Price*36+totalSetupPrice);

            var per_12 = (in_12>0?Math.round((in_12 - total12InternalCost)/in_12*1000)/10:0); // JS doesn't round to percentage points, so div then multiply
            var per_24 = (in_24>0?Math.round((in_24 - total24InternalCost)/in_24*1000)/10:0);
            var per_36 = (in_36>0?Math.round((in_36 - total36InternalCost)/in_36*1000)/10:0);
		
            Ext.getCmp('margin_1yr').setValue (per_12+"%");
            Ext.getCmp('margin_2yr').setValue (per_24+"%");
            Ext.getCmp('margin_3yr').setValue (per_36+"%");
        }
	
        /** 
         * Does this value exist in this array
         * @param val (string) Value (needle)
         * @param list (array) List (haystack)
         * @return bool
         */
        function In(val, list){ // for some reason this isn't an inbuilt JS func?
            for (var i=0; i<list.length;i++)
                if (val==list[i]) return true;
            return false;
        }
	
        /**
         * Remove any selected items from the quote (after prompt)
         * @return null
         */
        function RemoveItems (){
            if (GetNumSelectedQuoteItems() < 1) return false;
            Ext.Msg.show({
                title:'Delete items?', msg: 'Are you sure you wish to delete the selected items?',
                buttons: Ext.Msg.OKCANCEL,
                fn: function(e){
                    if (e=='ok') {
                        var selections = GetSelectedQuoteItems();
                        for ( var i = 0 ; i < GetNumSelectedQuoteItems() ; i++)
                            Ext.data.StoreManager.lookup('QuoteItemsStore').remove(selections[i]);
                        recalculateTotals();
                    }
                },
                animEl: 'elId',
                icon: Ext.MessageBox.QUESTION
            });
        }

        /** 
         * Change the quantity of the selected quote items
         * @return null
         */
        function ChangeQuantity(){
            if (GetNumSelectedQuoteItems() < 1) return false;
            // Prompt for user data and process the result using a callback:
            Ext.Msg.prompt('Change Quantity', 'Please enter the new quantity:', function(btn, text){
                if (btn == 'ok'){
                    var new_total = parseInt ( text ) ;
                    if ( isNaN(new_total) ) {
                        Ext.Msg.alert('Invalid', 'Not a valid quantity.');
                        return;
                    }
                    // process text value and close...
                    var selections = GetSelectedQuoteItems();
                    for ( var i = 0 ; i < GetNumSelectedQuoteItems() ; i++) {
                        selections[i].set('Quantity', new_total);
                        selections[i].set('TotalRecurringPrice',selections[i].data.RecurringPrice * new_total );
                        selections[i].set('qi_totalsetupcost',selections[i].data.SetupPrice * new_total );
                        selections[i].commit();
                    }
                    recalculateTotals();
                }
            },this,false,GetSelectedQuoteItems()[0].data.Quantity);
        }
	
        /** 
         * Change the setupprice of the selected quote items
         * @return null
         */
        function ChangeSetup(){
            if (GetNumSelectedQuoteItems() < 1) return false;
            // Prompt for user data and process the result using a callback:
            Ext.Msg.prompt('Change Setup', 'Please enter the new setup amount:', function(btn, text){
                if (btn == 'ok'){
                    var new_total = parseFloat ( text ) ;
                    if ( isNaN(new_total) ) {
                        Ext.Msg.alert('Invalid', 'Not a valid quantity.');
                        return;
                    }
                    // process text value and close...
                    var selections = GetSelectedQuoteItems();
                    for ( var i = 0 ; i < GetNumSelectedQuoteItems() ; i++) {
                        selections[i].set('SetupPrice', new_total);
                        selections[i].set('TotalSetupPrice',selections[i].data.Quantity * new_total );
                        selections[i].commit();
                    }
                    recalculateTotals();
                }
            },this,false,GetSelectedQuoteItems()[0].data.SetupPrice);
        }
	
        /** 
         * Change the quantity of the selected quote items
         * @return null
         */
        function ChangePrice(){
            if (GetNumSelectedQuoteItems() < 1) return false;
            // Prompt for user data and process the result using a callback:
            Ext.Msg.prompt('Change Cost', 'Please enter the new amount:', function(btn, text){
                if (btn == 'ok'){
                    var new_total = parseFloat ( text ) ;
                    if ( isNaN(new_total) ) {
                        Ext.Msg.alert('Invalid', 'Not a valid quantity.');
                        return;
                    }
                    // process text value and close...
                    var selections = GetSelectedQuoteItems();
                    for ( var i = 0 ; i < GetNumSelectedQuoteItems() ; i++) {
                        selections[i].set('RecurringPrice', new_total);
                        selections[i].set('TotalRecurringPrice',selections[i].data.Quantity * new_total );
                        selections[i].commit();
                    }
                    recalculateTotals();
                }
            },this,false,GetSelectedQuoteItems()[0].get('RecurringPrice'));
        }
	
        /** 
         * Change the recurringcost of the selected quote items
         * @return null
         */
        function ChangeRecurringCost(){
            if (GetNumSelectedQuoteItems() < 1) return false;
            // Prompt for user data and process the result using a callback:
            Ext.Msg.prompt('Change Internal Cost', 'Please enter the new amount:', function(btn, text){
                if (btn == 'ok'){
                    var new_total = parseFloat ( text ) ;
                    if ( isNaN(new_total) ) {
                        Ext.Msg.alert('Invalid', 'Not a valid quantity.');
                        return;
                    }
                    // process text value and close...
                    var selections = GetSelectedQuoteItems();
                    for ( var i = 0 ; i < GetNumSelectedQuoteItems() ; i++) {
                        selections[i].set('RecurringCost', new_total);
                        selections[i].commit();
                    }
                    recalculateTotals();
                }
            },this,false,GetSelectedQuoteItems()[0].get('RecurringCost'));
        }
	
        /** 
         * Change the setupcost of the selected quote items
         * @return null
         */
        function ChangeSetupCost(){
            if (GetNumSelectedQuoteItems() < 1) return false;
            // Prompt for user data and process the result using a callback:
            Ext.Msg.prompt('Change Internal Cost', 'Please enter the new amount:', function(btn, text){
                if (btn == 'ok'){
                    var new_total = parseFloat ( text ) ;
                    if ( isNaN(new_total) ) {
                        Ext.Msg.alert('Invalid', 'Not a valid quantity.');
                        return;
                    }
                    // process text value and close...
                    var selections = GetSelectedQuoteItems();
                    for ( var i = 0 ; i < GetNumSelectedQuoteItems() ; i++) {
                        selections[i].set('SetupCost', new_total);
                        selections[i].commit();
                    }
                    recalculateTotals();
                }
            },this,false,GetSelectedQuoteItems()[0].get('RecurringCost'));
        }
	
        /**
         * Add notes to a quote item(s), prompt the user for the text and amend the records
         * @return null
         */
        function AddNotes(){
            // Prompt for user data and process the result using a callback:
            var val='';
            if (GetNumSelectedQuoteItems()>0)
                val = GetSelectedQuoteItems()[0].get('Notes');
            Ext.create('Ext.window.Window', {
                width: 668,
                title: "Notes",
                height:257,
                items : [
                {
                    xtype: "form",
                    height: 226,
                    frame: true,
                    hideBorders: true,
                    items: [
                        {
                            xtype: "htmleditor",
                            anchor: "100%",
                            fieldLabel: "Notes",
                            height: 150,
                            width: 200,
                            autoScroll: true,
                            enableAlignments: false,
                            enableLinks: false,
                            enableFont: false,
                            enableFontSize: false,
                            value: val
                        }
                    ],
                    buttons: [{
                        text : 'Set Note',
                        handler : function(){
                            // process text value and close...
                            var fields = this.ownerCt.ownerCt.getForm().getFields();
                            var text = fields.items[0].getValue();
                            var selections = GetSelectedQuoteItems();
                            for ( var i = 0 ; i < GetNumSelectedQuoteItems() ; i++) {
                                selections[i].set('Notes', text);
                                selections[i].commit();
                            }
                            this.ownerCt.ownerCt.ownerCt.hide();
                        }
                    }]
                }]
            }).show();
        }

        /**
         * Prompt the user for a product description and amend the product desc in the store
         * @return null
         */
        function EditDescription(){
            // Prompt for user data and process the result using a callback:
            var val='';
            if (GetNumSelectedQuoteItems()>0)
                val = GetSelectedQuoteItems()[0].get('Description');
			
            Ext.create('Ext.window.Window', {
                width: 668,
                title: "Description",
                height:257,
                items : [
                {
                    xtype: "form",
                    height: 226,
                    frame: true,
                    hideBorders: true,
                    items: [
                        {
                            xtype: "htmleditor",
                            anchor: "100%",
                            fieldLabel: "Notes",
                            height: 150,
                            width: 200,
                            autoScroll: true,
                            enableAlignments: false,
                            enableLinks: false,
                            enableFont: false,
                            enableFontSize: false,
                            value: val
                        }
                    ],
                    buttons: [{
                        text : 'Set Note',
                        handler : function(){
                            // process text value and close...
                            var text = this.ownerCt.ownerCt.form.items.items[0].getValue();
                            var selections = GetSelectedQuoteItems();
                            for ( var i = 0 ; i < GetNumSelectedQuoteItems() ; i++) {
                                selections[i].set('Description', text);
                                selections[i].commit();
                            }
                            this.ownerCt.ownerCt.ownerCt.hide();
                        }
                    }]
                }]
            }).show();
        }
	
        /** 
         * Move the selected quote items into a new group
         * Grouped Store functionality in ExtJs creates the group if it doesnt exist.
         * If the name of the new group exists, it will move those items into the group
         * @return null
         */
        function MoveGroup(){
            // Prompt for user data and process the result using a callback:
            Ext.Msg.prompt('Move Group', 'Please enter the group name:', function(btn, text){
                if (btn == 'ok'){
                    // process text value and close...
                    var num_selections = GetNumSelectedQuoteItems();
                    var selections = GetSelectedQuoteItems();
                    for ( var i = 0 ; i < num_selections; i++) {
                        selections[i].set('Index',GetNextIndexInGroup(text));
                        selections[i].set('GroupName', text);
                        selections[i].commit();
                    }
                    Ext.data.StoreManager.lookup('QuoteItemsStore').group('GroupName','ASC');
                    recalculateTotals();
                }
            },this, false);
        }
	
        /**
         * Change the product title of the selected quote item(s)
         * @return null
         */
        function ChangeTitle(){
            // Prompt for user data and process the result using a callback:
            Ext.Msg.prompt('Change Title', 'Please enter the title:', function(btn, text){
                if (btn == 'ok'){
                    // process text value and close...
                    var num_selections = GetNumSelectedQuoteItems();
                    var selections = GetSelectedQuoteItems();
                    for ( var i = 0 ; i < num_selections ; i++) {
                        selections[i].set('Title', text);
                        selections[i].commit();
                    }
                    recalculateTotals();
                }
            },this, false);
        }
	
        /**
         * Move the selected items into the 'Options' group, which is excluded from quote totals
         * @return null
         */
        function MakeOption(){
            var num_selections = GetNumSelectedQuoteItems();
            var selections = GetSelectedQuoteItems();
            for ( var i = 0 ; i < num_selections ; i++) {
                selections[i].set('Index',GetNextIndexInGroup('Options'));
                selections[i].set('GroupName', 'Options');
                selections[i].commit();
            }
            Ext.data.StoreManager.lookup('QuoteItemsStore').group('GroupName','ASC');
            recalculateTotals();
        }
	
        /**
         * Save this quote and its items into the database (via JSON/HTTP-POST)
         * Request is asyncronous. Don't wait for response.
         * @return null
         */
        function SaveQuote() {
            var data_array = Array();
            for ( var i = 0; i< Ext.data.StoreManager.lookup('QuoteItemsStore').data.length; i++ ) {
                data_array.push(Ext.data.StoreManager.lookup('QuoteItemsStore').data.items[i].data);
            }
            var data_string = Ext.JSON.encode(data_array);
            var quoteStatus = '';
            Ext.Ajax.request({
                url: 'SaveQuote.aspx',
                success: function(){ Ext.Msg.alert('Save quote', 'Quote saved successfully'); },
                failure: function(){ Ext.Msg.alert('Error', 'Failed to Save Quote'); },
                params: { 
                    quote_items: data_string, 
                    quote_id: <%=this.quoteId%>, 
                    discount_percent:Ext.getCmp('discountSlider').getValue() , 
                    discount_percent_24:Ext.getCmp('discountSlider24').getValue() ,
                    discount_percent_36:Ext.getCmp('discountSlider36').getValue() ,
                    discount_percent_setup:Ext.getCmp('discountSliderSetup').getValue() ,
                    discount_writein: Ext.getCmp('writeinField').getValue(), 
                    title: Ext.getCmp('quoteTitleField').getValue(),
                    customer : Ext.getCmp('quoteCustomerField').getValue(),
                    customerFixed : '<%=this.quote.CustomerId%>'
                    }
            });
        }
	
        /** 
         * Raise a call to the PDF generator (browser will display download dialog)
         * @return null
         */
        function PrintQuotePDF (){
            // TODO 
        }

	
        /** 
	     * Add a writein product to this quote, show the product configuration dialog
	     * @return null
	     */
        function AddSimpleComponent(){
            var h= function () { 
                var fp = this.ownerCt.ownerCt;
                var	form = fp.getForm();
                var fields = form.getFields();
                if (form.isValid()) {
                    // Add line item
                    var newQuoteItemRecord =  Ext.ModelManager.create(
                        {
                            Id: null,
                            ProductId: -1,
                            Title: fields.items[0].getValue(),
                            Description: fields.items[1].getValue(),
                            Quantity: 1,
                            SetupPrice : fields.items[11].getValue(),
                            SetupCost: fields.items[9].getValue(),
                            RecurringPrice: fields.items[12].getValue(),
                            RecurringCost: fields.items[10].getValue(),
                            TotalRecurringPrice: fields.items[12].getValue(),
                            TotalSetupPrice: fields.items[11].getValue(),
                            GroupName: fields.items[4].getValue(),
                            PartCode: fields.items[3].getValue(),
                            IsPackage:false,
                            SubGroup:fields.items[8].getValue()
                        }, 'QuoteItems'
                    );
                    Ext.data.StoreManager.lookup('QuoteItemsStore').add(newQuoteItemRecord);
                    recalculateTotals();
                }
                this.ownerCt.ownerCt.ownerCt.hide();
            };
            AddProductDialog(h,true);
        }
	
        /**
	     * What is the next index in the group (for ordering)
	     * @param groupName (string) The name of the group
	     * @return (int) The next index
	     */
        function GetNextIndexInGroup ( groupName ){
            // Get the sort index, find items in the group we're going to use.
            var i=0,maxIndex=0;
            while ( i < Ext.data.StoreManager.lookup('QuoteItemsStore').getCount() ) {
                var item = Ext.data.StoreManager.lookup('QuoteItemsStore').getAt(i);
                if (item.data.GroupName == groupName && item.data.Index > maxIndex)
                    maxIndex = item.data.Index;
                i++;
            }
            return maxIndex +1;
        }
	
        /**
	     * Get the position of the specified sortIndex and groupName in the grid.
	     * @return (int)|(undefined) the index, undefined if not found
	     */
        function GetIndexOf(sortIndex,groupName){
            var result = undefined;
            for( var i =0 ; i<Ext.data.StoreManager.lookup('QuoteItemsStore').getCount(); i++){
                if (Ext.data.StoreManager.lookup('QuoteItemsStore').getAt(i).data.GroupName==groupName && Ext.data.StoreManager.lookup('QuoteItemsStore').getAt(i).data.Index==sortIndex ) 
                    return i;
            }
            return result;
        }
	
        /**
	     * Get a list of the current groups in the quote
	     * @return (array) Array of single dimension strings
	     */
        function GetGroupNames(){
            var names = array();
            // Get an array of the names of the groups in a quote..
            for( var i =0 ; i<Ext.data.StoreManager.lookup('QuoteItemsStore').getCount(); i++){
                for ( var j=0; names.length; j++)
                    if (names[j] == Ext.data.StoreManager.lookup('QuoteItemsStore').getAt(i).get('GroupName')) 
                        names.push ( Ext.data.StoreManager.lookup('QuoteItemsStore').getAt(i).get('GroupName') );
            }
            return names();
        }
	
        /**
	     * Make sure none of the indexes are 0, if so change the index to be the next number in the group
	     * This makes sure any old or broken items get ordered correctly.
	     * @return null
	     */
        function FixIndexes(){
            for( var i =0 ; i<Ext.data.StoreManager.lookup('QuoteItemsStore').getCount(); i++){
                if (Ext.data.StoreManager.lookup('QuoteItemsStore').getAt(i).get('Index') == 0){
                    Ext.data.StoreManager.lookup('QuoteItemsStore').getAt(i).set('Index', GetNextIndexInGroup(Ext.data.StoreManager.lookup('QuoteItemsStore').getAt(i).get('GroupName')) ) ;
                    Ext.data.StoreManager.lookup('QuoteItemsStore').getAt(i).commit();
                }
            }
            Ext.data.StoreManager.lookup('QuoteItemsStore').sort('Index','ASC');
        }
	
        /**
	     * Move the selected item up in the grid, only within the group. 
	     * @return null
	     */
        function MoveUp(){
            // get selected item first.
            var num_selections = GetNumSelectedQuoteItems();
            if (num_selections != 1) { return false; }
            var selection = GetSelectedQuoteItems()[0];
            var prev_index = GetIndexOf(selection.data.Index-1, selection.data.GroupName);
            if (quoteItemsGrid.store.getAt(prev_index)) {
                // Move the last one down
                quoteItemsGrid.store.getAt(prev_index).set('Index', selection.data.Index ) ;
                quoteItemsGrid.store.getAt(prev_index).commit();
                // Move this one up
                selection.set('Index',selection.data.Index-1);
                selection.commit();
                // re-sort
                quoteItemsGrid.store.sort('Index','ASC');
            }
        }
	
        /**
	     * Move the selected quote item down in the group
	     * @return null
	     */
        function MoveDown(){
            // get selected item first.
            var num_selections = GetNumSelectedQuoteItems();
            if (num_selections != 1) { return false; }
            var selection = GetSelectedQuoteItems()[0];
            var prev_index = GetIndexOf(selection.data.Index+1, selection.data.GroupName);
            if (quoteItemsGrid.store.getAt(prev_index)) {
                // Move the last one up
                quoteItemsGrid.store.getAt(prev_index).set('Index', selection.data.Index ) ;
                quoteItemsGrid.store.getAt(prev_index).commit();
                // Move this one down
                selection.set('Index',selection.data.Index+1);
                selection.commit();
                // re-sort
                quoteItemsGrid.store.sort('Index','ASC');
            }
        }

        // create the Grid
        var quoteItemsGrid = Ext.create('Ext.grid.Panel', {
            region: 'center',
            store: 'QuoteItemsStore',
            columns: [
			    {id:'Quantity',header: 'Qty', width: 30, sortable: false, dataIndex: 'Quantity'},
			    {id:'Title',header: 'Item', width: 150, sortable: false, dataIndex: 'Title', renderer : ProductDescription, flex:1},
			    {header: 'Unit Setup Price', width: 90, sortable: false,  dataIndex: 'SetupPrice', renderer: Ext.util.Format.numberRenderer('0.00')},
			    {header: 'Setup Price', width: 90, sortable: false,  dataIndex: 'TotalSetupPrice', renderer: Ext.util.Format.numberRenderer('0.00')},
			    {header: 'Unit Price', width: 90, sortable:false, dataIndex: 'RecurringPrice', renderer: Ext.util.Format.numberRenderer('0.00')},
			    {header: 'Price', width: 90, sortable: false, dataIndex: 'TotalRecurringPrice', renderer: Ext.util.Format.numberRenderer('0.00')},
			    {id:'RecurringCost',header: 'Cost', width: 90, sortable:false, dataIndex: 'RecurringCost', renderer: InternalCostRenderer}
            ],
            selModel: new Ext.selection.RowModel({ mode: 'MULTI' }),
            tbar: {
                enableOverflow: true,
                items: [
				    {
				        xtype: 'buttongroup',
				        items : [
						    {xtype:'button', iconCls:'icon-fugue-arrow-090', handler: MoveUp},
						    {xtype:'button', iconCls:'icon-fugue-arrow-270', handler: MoveDown}
				        ]
				    },{
				        text: 'Item',
				        iconCls:'icon-fugue-sticky-note-text',
				        menu : {
				            items : [
							    {text:'Set <u><b>Q</b></u>uantity', iconCls:'icon-fugue-ui-slider', handler: ChangeQuantity},
							    {text:'Add <b><u>N</u></b>otes', iconCls:'icon-fugue-notebook', handler: AddNotes},
							    {text:'<u><b>M</b></u>ove Items', iconCls:'icon-fugue-zones-stack', handler: MoveGroup},
							    {text:'Fix Setup Cost', iconCls:'icon-fugue-currency-pound', handler: ChangeSetup},
							    {text:'Fix Price', iconCls:'icon-fugue-currency-pound', handler: ChangePrice},
							    {text:'Make Option', iconCls:'icon-fugue-edit-indent', handler: MakeOption},
							    {text:'Change Title', iconCls:'icon-fugue-ui-text-field', handler: ChangeTitle}
				            ]
				        }
				    },
				    {
				        text: 'Overrides',
				        iconCls:'icon-fugue-edit-signiture',
				        disabled: <%=(this.quote.Status=="closed" || this.quote.Status=="sold" || this.quote.Status=="expired"?"true":"false")%>,
				        menu : {
				            items : [
							    {text:'Fix Recurring Cost', iconCls:'icon-fugue-currency-pound', handler: ChangeRecurringCost},
							    {text:'Fix Setup Cost', iconCls:'icon-fugue-currency-pound', handler: ChangeSetupCost},
							    {text:'Writein', iconCls:'icon-fugue-edit-signiture', handler: AddSimpleComponent},
							    {text:'Edit Description', iconCls:'icon-fugue-edit-signiture', handler: EditDescription}
				            ]
				        }
				    },
                    {xtype:'tbfill'},
                    {xtype:'button', text:'Remove', iconCls:'icon-fugue-cross', handler: RemoveItems, disabled: <%=(this.quote.Status=="closed" || this.quote.Status=="sold" || this.quote.Status=="expired"?"true":"false")%>} 
                ]
            },
            features: [
                Ext.create('Ext.grid.feature.Grouping',{
                    enableGroupingMenu:true,
                    groupTextTpl: '{text}'
                })
            ],
            viewConfig: {
                listeners : { 
                        itemcontextmenu: function(view, rec, item,index,event,opt){
                            var xy=  event.xy; event.stopEvent();
                            menu = new Ext.menu.Menu({
                                items:[
                                    {text:'Set <u><b>Q</b></u>uantity', iconCls:'icon-fugue-ui-slider', handler: ChangeQuantity},
                                    {text:'Add <b><u>N</u></b>otes', iconCls:'icon-fugue-notebook', handler: AddNotes},
                                    {text:'<u><b>M</b></u>ove Items', iconCls:'icon-fugue-zones-stack', handler: MoveGroup},
                                    {text:'Fix Setup Cost', iconCls:'icon-fugue-currency-pound', handler: ChangeSetup},
                                    {text:'Fix Price', iconCls:'icon-fugue-currency-pound', handler: ChangePrice},
                                    {text:'Make Option', iconCls:'icon-fugue-edit-indent', handler: MakeOption},
                                    {text:'Change Title', iconCls:'icon-fugue-ui-text-field', handler: ChangeTitle}
                                ]
                            });
                            menu.showAt(xy);
                        },
                        drop: function(node, data) {
                            AddProductRecord(data.records[0]);
                        }
                },
                plugins: {
                    ptype: 'gridviewdragdrop',
                    dropGroup: 'quoteItemsDrop',
                    enableDrag:false
                }
            }
        });

        var componentGrid = new Ext.panel.Panel({
            layout:'accordion',
            region: 'west',
            width: 300,
            minSize: 200,
            maxSize: 600,
            tbar: [
			    {xtype:'textfield', flex:1, id:'search-field',enableKeyEvents:true, listeners: { keyup: function(f,e) { SearchProduct(Ext.getCmp('search-field').getValue());} } },
			    {xtype:'button', iconCls:'icon-fugue-funnel', handler: function() { SearchProduct(Ext.getCmp('search-field').getValue()); } },
			    {xtype:'button', iconCls:'icon-fugue-cross', handler: function(){ ClearSearchProduct();Ext.getCmp('search-field').setValue(''); } } 
            ],
            loader: {
                url: 'QuoteService.svc/QuotePanelComponents?QuoteId=<%=this.quoteId%>',
                renderer: 'component',
                autoLoad: true
            }
        });
        var totalsPanel = new Ext.FormPanel({ 
            frame:true,
            region: 'east',
            width: 250,
            defaults: {labelWidth: 60},
            items:[
			    {
			        xtype:'textfield',
			        id:'quoteTitleField',
			        value :"<%=this.quote.Title%>",
			        disabled: <%=(this.quote.Status=="closed" || this.quote.Status=="sold" || this.quote.Status=="expired"?"true":"false")%>,
			        fieldLabel: 'Title'
			    },
			    {
			        xtype:'textfield',
			        id:'quoteCustomerField',
			        value: <%=(String.IsNullOrEmpty("\""+this.quote.CustomerName+"\"")?this.quote.CustomerName:"\"\"")%>,
			        fieldLabel: 'Customer',
			        disabled: true
			    },
			    {
			        xtype:"fieldset",
			        title:"Annual Prices",
			        items:[
					    {
					        id: 'setup_total',
					        xtype:"displayfield",
					        fieldLabel:"Setup",
					        labelSeperator: '<%=this.html_currency_char%>',
					        value: '<%=this.html_currency_char%>0.00'
					    },
					    {
					        xtype: 'fieldcontainer',
					        fieldLabel: '1Yr',
					        layout: 'hbox',
					        defaults: { flex: 1, hideLabel: true },
					        defaultType:'displayfield',
					        items: [
						      {
						          id: 'annual_1yr',
						          value: '<%=this.html_currency_char%>0.00'
						      },
						      {
						          id:'margin_1yr',
						          value: '0%'
						      }
					        ]
					    },
					    {
					        xtype: 'fieldcontainer',
					        fieldLabel: '2Yr',
					        layout: 'hbox',
					        defaults: { flex: 1, hideLabel: true },
					        defaultType:'displayfield',
					        items: [
							    {
							        id: 'annual_2yr',
							        value: '<%=this.html_currency_char%>0.00'
							    },
							    {
							        id:'margin_2yr',
							        value: '0%'
							    }
					        ]
					    },
					    {
					        xtype: 'fieldcontainer',
					        fieldLabel: '3Yr',
					        layout: 'hbox',
					        defaults: { flex: 1, hideLabel: true },
					        defaultType:'displayfield',
					        items: [
							    {
							        id: 'annual_3yr',
							        value: '<%=this.html_currency_char%>0.00'
							    },
							    {
							        id:'margin_3yr',
							        value: '0%'
							    }
					        ]
					    }
			        ]
			    },
			    {
			        xtype:"fieldset",
			        disabled: <%=(this.quote.Status=="closed" || this.quote.Status=="sold" || this.quote.Status=="expired"?"true":"false")%>,
			        title:"Discount",
			        items:
					    [
						    {
						        xtype: 'fieldcontainer',
						        fieldLabel: 'Overall %',
						        layout:'hbox',
						        defaults: { flex: 1, hideLabel: true },
						        items: [
								    {
								        xtype: 'sliderfield',
								        id:'discountSlider',
								        value :<%=this.quote.DiscountPercent%>,
								        tipText: function(slider){
								            recalculateTotals () ; 
								            Ext.getCmp('dv').setValue( String(slider.value)+"%" );
								            return String(slider.value) + '%';
								        },
								        increment: 1,
								        minValue: 0,
								        maxValue: 30
								    },
								    {
								        id:'dv',
								        xtype:"displayfield",
								        value: '<%=this.quote.DiscountPercent%>%',
						            width: 50, flex:0
						    }
					    ]
			    },{
			        xtype: 'fieldcontainer',
			        fieldLabel: '2yr %',
			        layout: 'hbox',
			        defaults: { flex: 1, hideLabel: true },
			        items: [
                        {
                            xtype: 'sliderfield',
                            id:'discountSlider24',
                            value :<%=this.quote.DiscountPercent24%>,
                            tipText: function(slider){
                                recalculateTotals () ; 
                                Ext.getCmp('dv_24').setValue( String(slider.value)+"%" );
                                return String(slider.value) + '%';
                            },
                            increment: 1,
                            minValue: 0,
                            maxValue: 30											
                        },
                        {
                            id:'dv_24',
                            xtype:"displayfield",
                            value: '<%=this.quote.DiscountPercent24%>%',
			                width: 50, flex:0
			            }
                    ]       
        },{
            xtype: 'fieldcontainer',
            fieldLabel: '3yr %',
            layout: 'hbox',
            defaults: { flex: 1, hideLabel: true },
            items: [
                {
                    xtype: 'sliderfield',
                    id:'discountSlider36',
                    value :<%=this.quote.DiscountPercent36%>,
                    tipText: function(slider){
                        recalculateTotals () ; 
                        Ext.getCmp('dv_36').setValue( String(slider.value)+"%" );
                        return String(slider.value) + '%';
                    },
                    increment: 1,
                    minValue: 0,
                    maxValue: 30
                },
                {
                    id:'dv_36',
                    xtype:"displayfield",
                    value: '<%=this.quote.DiscountPercent36%>%',
                    width: 50, flex:0
                }
            ]
        },{
            xtype: 'fieldcontainer',
            fieldLabel: 'Setup %',
            layout: 'hbox',
            defaults: { flex: 1, hideLabel: true },
            items: [
                {
                    xtype: 'sliderfield',
                    id:'discountSliderSetup',
                    maxValue: 100,
                    value :<%=this.quote.DiscountPercentSetup%>,
                    tipText: function(slider){
                        recalculateTotals () ; 
                        Ext.getCmp('dv_setup').setValue( Ext.getCmp('discountSliderSetup').getValue()+"%" );
                        return String(slider.value) + '%';
                    },
                    increment: 1,
                    minValue: 0
                },
                {
                    id:'dv_setup',
                    xtype:"displayfield",
                    value: '<%=this.quote.DiscountPercentSetup%>%',
                    width: 50, flex:0
                }
            ]
        },
        {
            xtype:'numberfield',
            id:'writeinField',
            value :<%=this.quote.DiscountWritein%>,
            labelWidth: 70,
            fieldLabel: 'Writein <%=this.html_currency_char%>',
            listeners : {
                change : function ( slider, newValue ) {	
                    recalculateTotals () ;
                }
            },
            minValue : 0,
            decimalPrecision: 2,
            allowNegative: false
        }
        ]				
        }
        ],
        buttons : [
            { text:'<u><b>P</b></u>rint PDF ', handler: PrintQuotePDF , iconCls:'icon-fugue-printer', id:'printButton' },
            { text: '<u><b>S</b></u>ave Quote', iconCls: 'icon-fugue-disk-black', handler: SaveQuote}
        ]
        });

        new Ext.Viewport({
            layout: 'border',
            monitorResize: true,
            items: [
			    componentGrid, 
			    quoteItemsGrid, 
			    totalsPanel
            ],
            renderTo: document.body
        });

        var formPanelDropTargetEl =  quoteItemsGrid.body.dom;
        var formPanelDropTarget = Ext.create('Ext.dd.DropTarget',formPanelDropTargetEl, {
            ddGroup     : 'quoteItemsDDGroup',
            notifyEnter : function(ddSource, e, data) {	
                //Add some flare to invite drop.
                quoteItemsGrid.body.stopAnimation();
                quoteItemsGrid.body.highlight();
            },
            notifyDrop  : function(ddSource, e, data){
                // Dropping products into the quote
                var selectedRecord = ddSource.dragData.records[0];
                if (data.view.panel.modelType == "PricedProducts") // add generic product
                    AddProductRecord(selectedRecord);
                else if (data.view.panel.modelType == "PricedPackages") // package editor
                    PackageWizard ( selectedRecord ) ;
            }
        });

        function AddProductRecord(selectedRecord){
            var d = selectedRecord.data;
            var newQuoteItemRecord = Ext.ModelManager.create(
		    {
		        Id: null,
		        QuoteId: parseInt(<%=this.quoteId%>),
		        ProductId: parseInt(d.Id),
		        Title: d.Title,
		        Description: (d.Description?d.Description:''),
		        Quantity: 1,
		        SetupPrice: parseFloat(d.SetupPrice),
		        RecurringPrice: parseFloat(d.RecurringPrice),
		        TotalRecurringPrice: parseFloat(d.RecurringPrice),
		        TotalSetupPrice: parseFloat(d.SetupPrice),
		        SetupCost: parseFloat(d.SetupCost),
		        RecurringCost: parseFloat(d.RecurringCost),
		        GroupName: d.Group,
                SubGroup: d.SubGroup,
		        Index: GetNextIndexInGroup( d.Group ),
		        Partcode: d.Partcode,
		        IsPackage: false
		    }, 'QuoteItems'
		    );
            Ext.data.StoreManager.lookup('QuoteItemsStore').add(newQuoteItemRecord);
            recalculateTotals();
            return true;
        }
        function PackageWizard (selectedRecord){
            var d = selectedRecord.data;
            Ext.create('Ext.window.Window', {
                width: 668,
                title: "Package",
                height:257,
                items : [
                {
                    xtype: "form",
                    height: 226,
                    frame: true,
                    hideBorders: true,
                    loader: {
                        url: 'QuoteService.svc/PackageComponents?PackageId='+selectedRecord.data.Id+'&PricelistId=<%=this.quote.PricelistId%>',
                        renderer: 'component',
                        autoLoad: true
                    },
                    buttons: [{
                        text : 'Add Package',
                        handler : function(){
                            var form = this.ownerCt.ownerCt;
                            var config = new Array();
                            var setupPrice = 0.0;
                            var setupCost = 0.0;
                            var recurringCost = 0.0;
                            var recurringPrice = 0.0;

                            for (var i = 0 ; i < form.items.length; i++){
                                if ( form.items.items[i].lastSelection[0] ) {
                                    var selectedRec = form.items.items[i].lastSelection[0].data ;
                                    if ( selectedRecord.data.InheritCost )
                                    {
                                        setupCost += parseFloat(selectedRec.SetupCost);
                                        recurringCost += parseFloat(selectedRec.RecurringCost);
                                    }
                                    if ( selectedRecord.data.InheritPrice ) 
                                    {
                                        setupPrice += parseFloat(selectedRec.setupPrice);
                                        recurringPrice += parseFloat(selectedRec.RecurringPrice);
                                    }

                                    config.push( { field: form.items.items[0].fieldLabel, product : selectedRec }  );
                                }
                            }
                            if ( !selectedRecord.data.InheritCost )
                            {
                                setupCost = parseFloat(selectedRecord.data.SetupCost);
                                recurringCost = parseFloat(selectedRecord.data.RecurringCost);
                            }
                            if ( !selectedRecord.data.InheritPrice ) 
                            {
                                setupPrice = parseFloat(selectedRecord.data.setupPrice);
                                recurringPrice = parseFloat(selectedRecord.data.RecurringPrice);
                            }
                            var newQuoteItemRecord = Ext.ModelManager.create(
		                    {
		                        Id: null,
		                        QuoteId: parseInt(<%=this.quoteId%>),
		                        Title: d.Title,
		                        Description: (d.Description?d.Description:''),
		                        Quantity: 1,
		                        SetupPrice: parseFloat(d.SetupPrice),
		                        RecurringPrice: parseFloat(d.RecurringPrice),
		                        TotalRecurringPrice: parseFloat(d.RecurringPrice),
		                        TotalSetupPrice: parseFloat(d.SetupPrice),
		                        SetupCost: parseFloat(d.SetupCost),
		                        RecurringCost: parseFloat(d.RecurringCost),
		                        GroupName: d.Group,
		                        SubGroup: d.SubGroup,
		                        Index: GetNextIndexInGroup( d.Group ),
		                        Partcode: d.Partcode,
		                        IsPackage: true,
		                        PackageId: parseInt(d.Id),
		                        PackageConfigJson: Ext.JSON.encode(config),
                                PackageConfigNative: config
		                    }, 'QuoteItems'
		                    );
                            Ext.data.StoreManager.lookup('QuoteItemsStore').add(newQuoteItemRecord);
                            recalculateTotals();
                            // process options
                            this.ownerCt.ownerCt.ownerCt.hide();
                        }
                    }]
                }]
            }).show();
            return true;
        }
        // Setup keyboard shortcuts
        new Ext.KeyMap(document, {key: 'q',shift: true,ctrl:true,stopEvent:true,	fn: ChangeQuantity});
        new Ext.KeyMap(document, {key: 'n',shift: true,ctrl:true,stopEvent:true,	fn: AddNotes});
        new Ext.KeyMap(document, {key: 'm',shift: true,ctrl:true,stopEvent:true, fn: MoveGroup});
        new Ext.KeyMap(document, {key: 's',shift: true,ctrl:true,stopEvent:true,	fn: SaveQuote});
        new Ext.KeyMap(document, {key: 'p',shift: true,ctrl:true,stopEvent:true,	fn: PrintQuotePDF});
    });
</script>
</asp:Content>