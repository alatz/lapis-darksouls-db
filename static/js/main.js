 //jquery ui autocomplete function
    $(function(){
        //Function activated when 3 characters have been typed. Clicking on item follows a link.
        $(".autocomplete").autocomplete({
            appendTo: ".rightheader",
                //source: "http://www.darksoulsdatabase.com/search",
                source: "/search",
                minLength: 3,
                select: function(event, ui)
                {
                    window.location.href = ui.item.value;
                    event.preventDefault();
                }
        });
    });

    //Converts text to lower-case
    $( ".autocomplete" ).on( "autocompletefocus", function( event, ui ) {
        this.value = ui.item.label;
        this.value = this.value.toLowerCase();
        event.preventDefault();
    } );

    //Clicking on the filter class toggles a ul element. Basically a dropdown menu.
    $(".filter").click(function() {
        $(".ulfilter").toggle();
        event.preventDefault();
    });

    //Clicking on any other part of the document will close dropdown menu.
    $(document).click(function(e) {
        var target = e.target;
        if (!$(target).is('.filter') && !$(target).parents().is('.filter')) {
            $('.ulfilter').hide();
        }
    });

    //Static labels function
    $(document).ready(function() {
        if($('.stickycontainer')[0]) {
            var stickyLabelTop = $('.stickycontainer').offset().top + 50;
            var minWindowWidth = 890;

            var stickyLabel = function() {
                var scrollTop = $(window).scrollTop();
                var windowWidth = $(window).width();

                if(scrollTop > stickyLabelTop && windowWidth > minWindowWidth) {
                    $('.stickycontainer').addClass('sticky');
                    $('.stickyplaceholder').css({display: 'block'});
                    //replaces long svg labels with shorter versions
                    $('.svg').css({display: 'none'});
                    $('.svgabrv').css({display: 'block'});
                } else {
                    $('.stickycontainer').removeClass('sticky');
                    $('.stickyplaceholder').css({display: 'none'});
                    ////replaces short svg labels with longer versions
                    $('.svg').css({display: 'block'});
                    $('.svgabrv').css({display: 'none'});
                }
        };

        stickyLabel();
        $(window).scroll(function() {
            stickyLabel();
        });
    }
    });

    $(document).ready(function() {
        if($('.sticky_weapon_legend')[0]) {
            var stickyWeaponLegendTop = $('.sticky_weapon_legend').offset().top + 20;
            var minWindowWidth = 890;

            var stickyWeaponLegend = function() {
                var scrollTop = $(window).scrollTop();
                var windowWidth = $(window).width();

                if(scrollTop > stickyWeaponLegendTop && windowWidth > minWindowWidth) {
                    $('.sticky_weapon_legend').addClass('sticky');
                    $('.sticky_weapon_legend_placeholder').css({display: 'block'});
                } else {
                    $('.sticky_weapon_legend').removeClass('sticky');
                    $('.sticky_weapon_legend_placeholder').css({display: 'none'});
                }
            };

            stickyWeaponLegend();
            $(window).scroll(function() {
                stickyWeaponLegend();
            });
        }
    });
