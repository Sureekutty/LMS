/*configuration for piday to ristrict future dates */

var picker = new Pikaday({
    field: document.getElementById('recieptDate'),
    format: 'DD/MM/YYYY',
    //minDate: new Date(),
    maxDate: new Date(),
    onSelect: function() {
  //console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});

var picker = new Pikaday({
    field: document.getElementById('recieptMonth'),
    format: 'MM/YYYY',
    //maxDate: new Date(),
    onSelect: function() {
    	
 // console.log(this.getMoment().format('MM/YYYY'));
    }
});


var picker = new Pikaday({
    field: document.getElementById('month'),
    format: 'MM/YYYY',
    minDate: new Date(),
   // maxDate: new Date(),
    onSelect: function() {
    	
  //console.log(this.getMoment().format('MM/YYYY'));
    }
});

/*var picker = new Pikaday({
    field: document.getElementById('monthproces'),
    format: 'MM/YYYY',
    minDate: new Date(),
    
   // maxDate: new Date(),
    onSelect: function() {
    	
  console.log(this.getMoment().format('MM/YYYY'));
    }
});*/
/*configuration for chosen-select */

var picker = new Pikaday({
    field: document.getElementById('recieptDate'),
    format: 'DD/MM/YYYY',
    //minDate: new Date(),
    maxDate: new Date(),
    onSelect: function() {
 // console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});


var config = {
		'.chosen-select' : {},
		'.chosen-select-deselect'  : {allow_single_deselect:true},
		'.chosen-select-no-single' : {disable_search_threshold:6},
		'.chosen-select-no-results': {no_results_text:'No results  found!'},
		'.chosen-select-width': {width:"95%"}
		}
		for (var selector in config) {
		$(selector).chosen(config[selector]);
		}