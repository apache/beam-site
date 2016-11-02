$(document).ready(function(){
    // Adding Navigation on top of code blocks, to show supported languages.
    var langSwitcherNav = "<div class=\"language-switcher col-sm-offset-10 col-sm-2\"> \
        <ul class=\"nav nav-tabs nav-justified\"> \
            <li class=\"active\" data-lang=\"java\"><a>Java</a></li> \
            <li data-lang=\"python\"><a>Python</a></li> \
        </ul> \
    </div>";
    $("div.language-java").before(langSwitcherNav);

    // Attaching on click listener, to li elements.
    $(".language-switcher ul li").click(function(el){
        // Making language preferences presistance, for user.
        localStorage.setItem('langPref', $(this).data("lang"));
        switchLanguage();
    })

    // Performing language switch operation.
    var switchLanguage = function() {
        var langPref = localStorage.getItem('langPref') || 'java';
        var langToHide = (langPref === 'java')? 'python': 'java';

        // Adjusting active elements in navigation header.
        $(".language-switcher li").removeClass('active').each(function(){
            if($(this).data("lang") === langPref) {
                $(this).addClass('active');
            }
        });

        // Swapping visibility of code blocks.
        $(".language-"+langToHide).hide();
        $(".language-"+langPref).show();
    }

    // Invoking on page boot.
    switchLanguage();
})