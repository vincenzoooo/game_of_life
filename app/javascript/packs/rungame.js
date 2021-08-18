$('#game-start').on('click', function(){
    $(this).prop('disabled', true);
    run_game()
});

function run_game(next){
    if(next === false){
        $("#game-start").prop('disabled', false);
        return;
    }
    $.ajax({
        beforeSend: function ( xhr ) {
            xhr.setRequestHeader( 'X-CSRF-Token', get_csrf_token() );
        },
        url: "/game/run",
        type: "post",
        data: {game_board: $('#game').val()},
        success: function(data) {
            if(data.html != false) {
                $('#board_game').html(data.html);
            }
            setTimeout(
                function () { run_game(data.html) },
                1000 // delay in ms
            );
        }
    })
}

function get_csrf_token(){
    return $( 'meta[name="csrf-token"]' ).attr( 'content' );
}