$("div.team").hover(function(){
	id = $(this).data("teamid");
	$(this).addClass("highlight");
	$("div.team[data-teamid=" + id + "]").addClass("highlight");
	$("div.team.win[data-teamid=" + id + "]").addClass("highlight").closest(".teamContainer").children(".connector").addClass("highlight").children(".connector").addClass("highlight");
}, function() {
	$(this).removeClass("highlight");
	$("div.team[data-teamid=" + id + "]").removeClass("highlight");
	$("div.team.win[data-teamid=" + id + "]").removeClass("highlight").closest(".teamContainer").children(".connector").removeClass("highlight").children(".connector").removeClass("highlight");
});

