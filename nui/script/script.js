$(function () {
    window.addEventListener("message", function (event) {
        var item = event.data;
        console.log("Kommt JS");

        if (item.type == "openNui") {
            console.log("Häää");
            var playersData = item.playersData;
            playersData.forEach(function(player) {
                var playerBox = $('<div class="player_box"></div>');

                var profile = $('<div class="profile"></div>');
                var icon = $('<iconify-icon icon="solar:user-broken"></iconify-icon>');
                profile.append(icon);
                playerBox.append(profile);

                var ul = $('<ul></ul>');
                var playerName = $('<h1>' + player.playerName + '</h1>');
                var playerPhone = $('<h2>' + player.playerPhone + '</h2>'); // Textwert hinzugefügt
                ul.append(playerName);
                ul.append(playerPhone);
                playerBox.append(ul);

                var indicator = $('<span class="indicator" data-phone="' + player.playerPhone + '"><iconify-icon icon="bi:app-indicator"></iconify-icon></span>');
                indicator.click(function() {
                    var phoneNumber = $(this).data('phone');
                    copyToClipboard(phoneNumber);
                    $.post(
                        "https://GMD_Joblists/numberNotify",
                        JSON.stringify({
                          name: playerName.text(), // playerName bleibt unverändert
                          number: playerPhone.text() // playerPhone wird als String umgewandelt
                        })
                      );
                    console.log('Telefonnummer ' + phoneNumber + ' wurde in den Zwischenspeicher kopiert!');
                });
                playerBox.append(indicator);

                $('.container_content').append(playerBox);
            });

            document.body.style.display = "block"; 
        }
    });


    function copyToClipboard(text) {
        var input = $('<input>');
        $('body').append(input);
        input.val(text).select();
        document.execCommand('copy');
        input.remove();
    }

    // Event-Listener für den Exit-Button
    $(".exit_btn").click(function () {
        document.body.style.display = "none"; // Verstecke den Body
        $('.container_content').empty(); // Leere das UL mit der Klasse 'container_content'
        $.post("https://GMD_Joblists/escape", JSON.stringify({}));
    });
});
