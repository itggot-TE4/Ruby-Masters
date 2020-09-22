function clear_field(self){
    self.parentElement.children[0].value = "";
}

function show_popup(){
    var popup = document.querySelector('main.school_popup');
    var wrapper = document.querySelector('.wrapper');

    wrapper.classList.toggle('blurred');
    popup.classList.toggle('hidden');
}

function show_teacher_popup(){
    console.log('hej')
    var popup = document.querySelector('main.teacher_popup');
    var wrapper = document.querySelector('.wrapper');

    wrapper.classList.toggle('blurred');
    popup.classList.toggle('hidden');   
}

function group_popup(){
    // console.log('123')
    var parent = document.querySelector("main.group_popup");
    parent.classList.toggle('hidden');
}