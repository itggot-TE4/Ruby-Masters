function clear_field(self){
    self.parentElement.children[0].value = "";
}

function show_popup(){
    var popup = document.querySelector('main.school_popup');
    var wrapper = document.querySelector('.wrapper');

    wrapper.classList.toggle('blurred');
    popup.classList.toggle('hidden');
}