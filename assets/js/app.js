function updateArchiveMonthHeaders() {
  $("#archive .months > li").each(function() {
    var el = $(this),
      offset = el.offset();
      scrollTop = $(window).scrollTop(),
      floatingHeader = $(".floating-header", this);

    var containerBottom = offset.top + el.height();

    if ((scrollTop > offset.top) && (scrollTop < containerBottom)) {
      var headerBottom = floatingHeader.offset().top + floatingHeader.outerHeight(true);
      var currentHeaderTop = parseInt(floatingHeader.css('top'));

      if (headerBottom > containerBottom) {
        floatingHeader.css('top', currentHeaderTop + containerBottom - headerBottom );
      } else {
        if (containerBottom - scrollTop < floatingHeader.outerHeight(true)) {//(containerBottom - headerBottom < floatingHeader.outerHeight(true)) {
          floatingHeader.css('top', currentHeaderTop + containerBottom - headerBottom);
        } else {
          floatingHeader.css('top', '0');
        }
      }

      floatingHeader.css({"visibility": "visible"});
    } else {
      floatingHeader.css({"visibility": "hidden"});
    }
  });
}

var initArchive = function() {
  var clonedHeader;

  $("#archive .months > li").each(function() {
    clonedHeader = $("h4", this);
    clonedHeader
      .before(clonedHeader.clone())
      .addClass('floating-header');
  });

  $(window)
    .scroll(updateArchiveMonthHeaders)
    .trigger('scroll');
}

var initSite = function() {
  var $mainMenu = $('div.menu');
  $('#menu_button').click(function() {$mainMenu.toggle(); return false;});
  $(window).resize(function() {$mainMenu.toggle($(window).width() >= 768);});
}

$(initSite);
