<form id='{$form.name}' name='{$form.name}'>
<script src="{$js_url}/cookies.js"></script>
<script src="{$js_url}/grouping.js"></script>
<div style="padding-left:25px;padding-right:40px;">
{include file="system_appbuilder_btn.tpl.html"}
	<table><tr><td>
		{if $form.icon !='' }
		<div class="form_icon"><img  src="{$form.icon}" border="0" /></div>
		{/if}
		<div style="float:left; width:600px;">
		<h2>
		{$form.title}
		</h2> 
		<p class="form_desc">{$form.description}</p>
		</div>
	</td></tr></table>
{if $actionPanel or $searchPanel }	
	<div class="form_header_panel">	
		<div class="action_panel" >
			{foreach item=elem from=$searchPanel}
				{if $elem.type=='InputDateRangePicker'} {$elem.element}{/if} 
			{/foreach}
		
			{foreach item=elem from=$actionPanel}
			    	{$elem.element}
			{/foreach}
		</div>
		<div class="search_panel" >		
			{foreach item=elem from=$searchPanel}
				{if $elem.type!='InputDateRangePicker'}
					{if $elem.label} {$elem.label} {/if} {$elem.element}
				{/if}
			{/foreach}
		</div>
	</div>	
{/if}	
<div class="from_table_container">
<!-- table start -->
<table border="0" cellpadding="0" cellspacing="0" class="form_table" id="{$form.name}_data_table">
	<thead>		
     {foreach item=cell key=elems_name from=$dataPanel.elems}	
     	{if $cell.type=='ColumnStyle'}
     		{assign var=row_style_name value=$elems_name}
     	{else}
			{if $cell.type=='RowCheckbox'}
				{assign var=th_style value="text-align:left;padding-left:10px;"}
			{else}
				{assign var=th_style value=""}
			{/if}
			{if $elems_name != 'fld_description'}
         <th onmouseover="this.className='hover'" 
			onmouseout="this.className=''"
				nowrap="nowrap" style="{$th_style}"
			>{$cell.label}</th>	 
			{/if}
		{/if}
     {/foreach}
	</thead>				


{assign var=group_counter value=0}    
{foreach item=row key=group_name from=$form.dataGroup}
	<tbody >
		<tr class="group_selector">
		<td colspan="{$dataPanel.elems|@count}" >
			<a href="javascript:;" id="{$form.name}_group_{$group_name}_switcher"
			onclick="switch_datasheet('{$form.name}_group_{$group_name}')"
				class="shrink"		 		
			>{t}Group: {/t}{$group_name}</a>
		</td>
		</tr>
	</tbody>
	<tbody id="{$form.name}_group_{$group_name}">
	<!--  Group: {$group_name} -->
 		{assign var=row_counter value=0}    
     	{foreach item=row from=$form.dataGroup.$group_name.data}

     	 {if $row.$row_style_name != ''}
     	 	{assign var=row_style value=$dataPanel.data.$row_counter.$row_style_name}
     	 {else}
     	 	{assign var=row_style value=''}
     	 {/if}
                  
          {if $row_counter is odd}
		   <tr id="{$form.name}-{$form.dataGroup.$group_name.ids[$row_counter]}" 
		   			style="{$row_style}"
		   			class="odd"  normal="odd" select="selected"
					onmouseover="if(this.className!='selected')this.className='hover'" 
					onmouseout="if(this.className!='selected')this.className='odd'"  
					onclick="Openbiz.CallFunction('{$form.name}.SelectRecord({$form.dataGroup.$group_name.ids[$row_counter]})');">
          {else}
			<tr id="{$form.name}-{$form.dataGroup.$group_name.ids[$row_counter]}"
					style="{$row_style}" 
					class="even"  normal="even" select="selected"
					onmouseover="if(this.className!='selected')this.className='hover'" 
					onmouseout="if(this.className!='selected')this.className='even'" 
					onclick="Openbiz.CallFunction('{$form.name}.SelectRecord({$form.dataGroup.$group_name.ids[$row_counter]})');">
         {/if}
		         {assign var=col_counter value=0}    
         		{foreach key=name item=cell key=cell_name from=$row}
		         	{if $col_counter eq 0}
		         		{assign var=col_class value=' class="row_header" '}    
		         	{else}
		         		{assign var=col_class value=' '}
		         	{/if}
		         	{if $cell_name != $row_style_name && $cell_name !='fld_description'}
			            {if $cell != ''}            	
			              <td {$col_class} nowrap="nowrap" >{$cell}</td>
			            {else}
			              <td {$col_class} nowrap="nowrap" >&nbsp;</td>
			            {/if}
		            {/if}
		            {assign var=col_counter value=$col_counter+1}
		         {/foreach}         
		{assign var=row_counter value=$row_counter+1}
		</tr>
		{if $row.fld_description}
		<tr>
			<td nowrap="nowrap" style="background-image:none;background-color:#FAFAFA;"></td>
			<td nowrap="nowrap" style="background-image:none;background-color:#FAFAFA;text-align:right;">
				<img border="0" src="{$resource_url}/collab/worklog/images/icon_worklog_arrow.png" style="padding-right:5px;" />
			</td>
			<td colspan="3" style="background-image:none;background-color:#FAFAFA;">			
			{$row.fld_description}<br/>			
		</tr>
		{/if}		
     	{/foreach}			
	</tbody>
	<script>load_default_status('{$form.name}_group_{$group_name}');</script>
	{assign var=group_counter value=$group_counter+1}
{/foreach}
</table>
<!-- table end -->
</div>	

<!-- status switch  -->
<script>
{if $form.status eq 'Enabled'}
{elseif $form.status eq 'Disabled'}
$('{$form.name}_data_table').fade({literal}{ duration: 0.5, from: 1, to: 0.35 }{/literal});
{/if}
</script>
	<div class="form_footer_panel">
		<div class="ajax_indicator">
			<div id='{$form.name}.load_disp' style="display:none" >
				<img src="{$image_url}/form_ajax_loader.gif"/>
			</div>
		</div>
		<div class="navi_panel">

{if $navPanel}
   {foreach item=elem from=$navPanel}
   		{if $elem.label} <label style="width:68px;">{$elem.label}</label>{/if}
    	{$elem.element}
   {/foreach}
{/if}			
		
		</div>		
	</div>
	<div class="v_spacer"></div>
</div>
</form>