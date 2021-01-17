<!-- hide script from old browsers. Backslash is used below when ending tags   (e.g. <\/select> <\/option> ...) within a script (with document.write) for proper validation of html formby www.w3.org, as explained in http://www.htmlhelp.com/tools/validator/problems.html


var j=0;
var linknome=Array();
var linkpagina=Array();

 j++;
linknome[j]="Home";
linkpagina[j]="index.html";

j++;
linknome[j]="About";
linkpagina[j]="about.html";

j++
linknome[j]="Participants";
linkpagina[j]="participants.html";

j++
linknome[j]="Talks";
linkpagina[j]="talks.html";

j++
linknome[j]="Schedule";
linkpagina[j]="schedule.html";

j++;
linknome[j]="Travel Info";
linkpagina[j]="travel.html";

j++;
linknome[j]="Poster";
linkpagina[j]="poster.html";

j++;
linknome[j]="Certificates";
linkpagina[j]="certificates.html";

document.write("<div class='menu'>");

  for (j in linknome)
  {
    if (j>1)
    {
      document.write("<hr>");
    }
    document.write("<a href="+linkpagina[j]+">"+linknome[j]+"<\/a>");  
  }

document.write("<\/div>");
// end hiding script from old browsers -->
