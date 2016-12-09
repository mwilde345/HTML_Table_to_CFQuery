function htmlQuery(htmlString){
		var data = htmlString;
		var headers = arraynew(1);
		var types = arraynew(1);
		var structArray = arraynew(1);
		data = rereplace(data,"(?m)[\n\t\r]","","all");
	  data = rereplace(data,"(</tr>.*?<tr.*?>)|(<table.*?tr.*?>)|(</tr></table>)","%newRow%","all");
		var htmlData = ListToArray(data,"%newRow%",false,true);
		for(var row in htmlData){
			if(refindnocase("^(<th.*/th>$)",row)){
				var cleanHeaderRow = rereplace(row,"(^<th>)|(</th>$)","","all"); //to prevent empty top and bottom spots in the array we are about to create
				cleanHeaderRow = rereplace(cleanHeaderRow,"(</th><th>)","%newColumn%","all");
				var headerRow = listToArray(cleanHeaderRow,"%newColumn%",true,true);
				//loop through header row and replace empty column names with col_# to prevent them from being lost in queryNew()
				for(var i = 1; i<=arraylen(headerRow); i++){
					if(!len(headerRow[i])){
						headerRow[i] = "Col_"&i;
					}
				}
				for(var header in headerRow){
					arrayappend(headers,header);
					arrayappend(types,"varchar");
				}
			}
			if(refindnocase("(^<td.*/td>$)",row)){
				var cleanDataRow = rereplace(row,"(^<td>)|(</td>$)","","all"); //to prevent empty top and bottom spots in the array we are about to create
				cleanDataRow = rereplace(cleanDataRow,"(</td><td>)","%newColumn%","all");
				var dataRow = listToArray(cleanDataRow,"%newColumn%",true,true);
				var rowStruct = structNew();
				for(i = 1; i<=arraylen(dataRow); i++){
					rowStruct[headers[i]] = dataRow[i];
				}
				arrayappend(structArray,rowStruct);
			}
		}
		var outputQuery = queryNew(arraytolist(headers),arraytolist(types),structArray);
		return outputQuery;
	}
