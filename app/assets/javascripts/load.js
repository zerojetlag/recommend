$(document).ready(function(){
  $('form#search').submit(function(){
    console.log($(this));
    var id = $(this).find('input[name=userid]').val();
    $.ajax({
        url:"http://books.nirvawolf.com/Recommendation?userid=" + id,
        type:'GET',
        success: function(data){
          var index = 0;
          var table = $('#recommend').find('ul');
          var html = "<li class='col-md-12'>";
          $.each(data['books'], function(){
            //html += "<tr data-toggle='tooltip' title='category code:"+data['books'][index]['categoryCode']+", acquire code: "+data['books'][index]['acquireCode']+", publisher: "+data['books'][index]['publisher']+"'>";
            if(index%3==0&&index!=0)
              html+='</li>';
            
            if(index%3==0&&index!=0)
              html+='<li class="col-md-12">';

            html += "<div class='book col-md-4'><a data-toggle='tooltip' data-original-title='"+ data['books'][index]['bookName'] +"' href='"+data['books'][index]['bookURL']+"'><img src='"+data['books'][index]['imageURL']+"' style='width:130px;height:180px;margin-top:10px' /></a></div>";
            
            // html += "<td>"+index+"</td>";
            // html += "<td>"+data['books'][index]['bookName']+"</td>";
            // html += "<td>"+data['books'][index]['author']+"</td>";
            // html += "<td>"+data['books'][index]['topic']+"</td>";
            // html += "</tr>";
            index += 1;
          });
          html+='</li>';
          table.html(html);
          $('a').tooltip();
        },
        dataType: "jsonp",
    });
    $.ajax({
        url:"http://books.nirvawolf.com/UserBooks?userid=" + id,
        type:'GET',
        success: function(data){
          var index = 0;
          var table = $('#books').find('ul');
          var html = "<li class='col-md-12'>";
          $.each(data['books'], function(){
             if(index%3==0&&index!=0)
              html+='</li>';
            
            if(index%3==0&&index!=0)
              html+='<li class="col-md-12">';
            
            html += "<div class='book col-md-4'><a data-toggle='tooltip' data-original-title='"+ data['books'][index]['bookName'] +"' href='"+data['books'][index]['bookURL']+"'><img src='"+data['books'][index]['imageURL']+"' style='width:130px;height:180px;margin-top:10px' /></a></div>";

            // html += "<tr data-toggle='tooltip' title='category code:"+data['books'][index]['categoryCode']+", acquire code: "+data['books'][index]['acquireCode']+", publisher: "+data['books'][index]['publisher']+"'>";
            // html += "<td>"+index+"</td>";
            // html += "<td>"+data['books'][index]['bookName']+"</td>";
            // html += "<td>"+data['books'][index]['author']+"</td>";
            // html += "<td>"+data['books'][index]['topic']+"</td>";
            // html += "</tr>";
            index += 1;
          });
          table.html(html);
          $('a').tooltip();
        },
        dataType: "jsonp",
    });
    return false;
  });
  if($('form#search').find('.form-control').val().length > 1){
    $('form#search').submit();
  }
});