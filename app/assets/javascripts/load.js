$(document).ready(function(){
  // $('form#search').submit(function(){
  //   console.log($(this));
  //   var id = $(this).find('input[name=userid]').val();
  //   $.ajax({
  //       url:"http://books.nirvawolf.com/Recommendation?userid=" + id,
  //       type:'GET',
  //       success: function(data){
  //         var index = 0;
  //         var table = $('#recommend').find('tbody');
  //         var html = "";
  //         $.each(data['books'], function(){
  //           html += "<tr data-toggle='tooltip' title='category code:"+data['books'][index]['categoryCode']+", acquire code: "+data['books'][index]['acquireCode']+", publisher: "+data['books'][index]['publisher']+"'>";
  //           html += "<td>"+index+"</td>";
  //           html += "<td>"+data['books'][index]['bookName']+"</td>";
  //           html += "<td>"+data['books'][index]['author']+"</td>";
  //           html += "<td>"+data['books'][index]['topic']+"</td>";
  //           html += "</tr>";
  //           index += 1;
  //         });
  //         table.html(html);
  //         $('tr').tooltip();
  //       },
  //       dataType: "jsonp",
  //   });
  //   $.ajax({
  //       url:"http://books.nirvawolf.com/UserBooks?userid=" + id,
  //       type:'GET',
  //       success: function(data){
  //         var index = 0;
  //         var table = $('#books').find('tbody');
  //         var html = "";
  //         $.each(data['books'], function(){
  //           html += "<tr data-toggle='tooltip' title='category code:"+data['books'][index]['categoryCode']+", acquire code: "+data['books'][index]['acquireCode']+", publisher: "+data['books'][index]['publisher']+"'>";
  //           html += "<td>"+index+"</td>";
  //           html += "<td>"+data['books'][index]['bookName']+"</td>";
  //           html += "<td>"+data['books'][index]['author']+"</td>";
  //           html += "<td>"+data['books'][index]['topic']+"</td>";
  //           html += "</tr>";
  //           index += 1;
  //         });
  //         table.html(html);
  //         $('tr').tooltip();
  //       },
  //       dataType: "jsonp",
  //   });
  //   return false;
  // });
});