$(document).ready(() => {
    $(".cancel").on("click", "", function () {
        $(".flex-container").slideUp(350);
        $(".flex-container").fadeOut(350);
        $.post('http://wrp-reportui/close  ', JSON.stringify({}));
    })
    $(".submit").on("click", "", function () {
        let title = $('#title').val();
        let description = $('#description').val();
        let clips = $('#clips').val();
        if (title && description != "") {
            $.post('http://wrp-reportui/submit  ', JSON.stringify({
                title: title,
                description: description,
                clips: clips
            }));
        }
        $.post('http://wrp-reportui/close  ', JSON.stringify({}));
        $(".flex-container").slideUp(350);
        $(".flex-container").fadeOut(350);
    }) 
})

$(function () {
    window.addEventListener('message', function (event) {
        let data = event.data;
        if (data.show == true) {
            $('#title').val("");
            $('#description').val("");
            $('#clips').val("");
            $(".flex-container").slideDown(350);
            $(".flex-container").fadeIn(350);
        }
    });
});