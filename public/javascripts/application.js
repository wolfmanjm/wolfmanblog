// Common JavaScript code across your application goes here.

$(document).ready(function() {
  $('.delete').click(function() {
    var answer = confirm('Are you sure?');
    return answer;
  });
});

$(document).ready(function() {
  $("a#leave_email").click(function(event){
     $("#guest_url").toggle();
     $("#guest_email").toggle();
     event.preventDefault();
  });
});

