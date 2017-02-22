var countScroll = 52000;
$(document).ready(function() {
	$(window).scroll(function () {
		if ($(this).scrollTop() > countScroll) $('#load').click()
	});
});
