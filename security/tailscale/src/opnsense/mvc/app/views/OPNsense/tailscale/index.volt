<script>

    $(document).ready(function () {



        $("#saveAct").click(function () {
            $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
            saveFormToEndpoint(url = "/api/tailscale/settings/set", formid = 'frm_GeneralSettings', callback_ok = function () {
                ajaxCall(url = "/api/tailscale/service/reload", sendData = {}, callback = function (data, status) {
                    updateServiceControlUI('tailscale');
                    $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
                });
            });
        });



        let data_get_map = {'frm_GeneralSettings': "/api/tailscale/settings/get"};
        mapDataToFormUI(data_get_map).done(function (data) {
            updateServiceControlUI('tailscale');
            $('.selectpicker').selectpicker('refresh');
        });

    });
</script>

<div class="alert alert-info hidden" role="alert" id="responseMsg">

</div>

<div class="col-md-12">
    {{ partial("layout_partials/base_form",['fields':generalForm,'id':'frm_GeneralSettings']) }}
</div>

<div class="col-md-12">
    <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b><i id="saveAct_progress"></i>
    </button>
</div>

