// ==================================================
// script for control searchbox
// last update: 2011-03-02 15:14:28 daiki
// ==================================================

function toggle_search_box(id)
{
    chbox = 'd_check_' + id;
    if ($(chbox).checked) {
	new Effect.Fade($(id), {
		from:0.4, // 開始時透明度
		to:1.0, // 終了時透明度
		// delay:0, // 開始までの秒数
		fps:60, // フレームレート
		duration: 0.5, // アニメーションする時間(秒)
		beforeStartInternal: function(effect) {
		    $(id).setStyle('background-color:#fefef0; color:#000000;');
		},
		afterFinishInternal: function(effect) {
		}
	});

    }
    else {
	new Effect.Fade($(id), {
		from:1.0, // 開始時透明度
		to:0.4, // 終了時透明度
		// delay:0, // 開始までの秒数
		fps:60, // フレームレート
		duration: 0.5, // アニメーションする時間(秒)
		beforeStartInternal: function(effect) {
		    $(id).setStyle('background-color:#999999; color:#666666;');
		},
		afterFinishInternal: function(effect) {
		}
	});
    }
}


function preset_search_params() {
    if (!($('d_check_search_keyword').checked) || ($F('d_query') == 'Free Word')) {
	$('d_query').value = '';
    }

    if (!($('d_check_search_time').checked)) {
	$('d_ts').value = '';
	$('d_te').value = '';
    }
    else {
	if ($F('d_ts') == 'YYYY-MM-DDThh:mm:ssZ') $('d_ts').value = '';
	if ($F('d_te') == 'YYYY-MM-DDThh:mm:ssZ') $('d_te').value = '';
    }

    if (!($('d_check_search_place').checked)) {
	$('d_slat').value = '';
	$('d_nlat').value = '';
	$('d_wlon').value = '';
	$('d_elon').value = '';
    }
    else {
	if ($F('d_slat') == 'e.g. -45' ) $('d_slat').value = '';
	if ($F('d_nlat') == 'e.g. 70'  ) $('d_nlat').value = '';
	if ($F('d_wlon') == 'e.g. -260') $('d_wlon').value = '';
	if ($F('d_elon') == 'e.g. 135' ) $('d_elon').value = '';
    }
}

function preset_search_params_sun() {
    if (!($('d_check_search_keyword2').checked) || ($F('d_query2') == 'Free Word')) {
	$('d_query2').value = '';
    }

    if (!($('d_check_search_time2').checked)) {
	$('d_ts2').value = '';
	$('d_te2').value = '';
    }
    else {
	if ($F('d_ts2') == 'YYYY-MM-DDThh:mm:ssZ') $('d_ts2').value = '';
	if ($F('d_te2') == 'YYYY-MM-DDThh:mm:ssZ') $('d_te2').value = '';
    }

    if (!($('d_check_search_place2').checked)) {
	$('d_slat2').value = '';
	$('d_nlat2').value = '';
	$('d_wlon2').value = '';
	$('d_elon2').value = '';
    }
    else {
	if ($F('d_slat2') == 'e.g. -45' ) $('d_slat2').value = '';
	if ($F('d_nlat2') == 'e.g. 70'  ) $('d_nlat2').value = '';
	if ($F('d_wlon2') == 'e.g. -260') $('d_wlon2').value = '';
	if ($F('d_elon2') == 'e.g. 135' ) $('d_elon2').value = '';
    }
}
