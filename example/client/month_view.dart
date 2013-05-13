import "dart:html";

BodyElement get body => document.body;
LinkElement get switchToJsonLink => body.query("*[id='switchToJson']");

void main() {
  switchToJsonLink.onClick.listen( (ev) {
    window.location.href = window.location.pathname+"?accept=application/json"; 
  }, cancelOnError:true );
}