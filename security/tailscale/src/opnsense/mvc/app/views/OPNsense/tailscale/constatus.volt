<script>

    $(document).ready(function () {

        function refreshConStatus() {
            $("#refreshAct_progress").addClass("fa fa-spinner fa-pulse");

            ajaxCall(url = "/api/tailscale/service/upDownStatus", sendData = {}, callback = function (data, status) {
                if (data['updown'] == "UP") {
                    $("#setUpAct").prop('disabled', true);
                    $("#setDownAct").prop('disabled', false);
                    $("#peers").prop('hidden', false);
                } else if (data['updown'] == "DOWN") {
                    $("#setUpAct").prop('disabled', false);
                    $("#setDownAct").prop('disabled', true);
                    $("#peers").prop('hidden', true);
                } else {
                    $("#setUpAct").prop('disabled', true);
                    $("#setDownAct").prop('disabled', true);
                    $("#peers").prop('hidden', true);
                }
                $("#updown").html(data['updown']);
                $("#constatustxt").html(data['status']);
                $("#refreshAct_progress").removeClass("fa fa-spinner fa-pulse");
            });
        }

        $("#refreshAct").click(function () {
            refreshConStatus();
        });

        $("#setUpAct").click(function () {
            $("#setUp_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url = "/api/tailscale/service/setup", sendData = {}, callback = function (data, status) {
                setTimeout(function () {
                    refreshConStatus();
                    $("#setUp_progress").removeClass("fa fa-spinner fa-pulse");
                }, 3000);

            });
        });

        $("#setDownAct").click(function () {
            $("#setDown_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url = "/api/tailscale/service/setdown", sendData = {}, callback = function (data, status) {
                setTimeout(function () {
                    refreshConStatus();
                    $("#setDown_progress").removeClass("fa fa-spinner fa-pulse");
                }, 500);

            });
        });

        $("#service_status_container").click(function () {
            setTimeout(function () {
                refreshConStatus();
            }, 2000);
        });


        refreshConStatus();
        updateServiceControlUI('tailscale');

    });
</script>
<div class="col-md-12">
    <h2>Tailscale Connection</h2>
    <span id="updown"></span>
</div>
<div class="col-md-12">
    <button class="btn" id="setUpAct" type="button"><b>{{ lang._('Set UP') }}</b><i id="setUp_progress"></i></button>
    <button class="btn" id="setDownAct" type="button"><b>{{ lang._('Set DOWN') }}</b><i id="setDown_progress"></i>
    </button>
</div>

<div class="col-md-12">
    <h2>{{ lang._('Status Output') }}</h2>
    <section id="constatustxt" class="col-xs-11">
    </section>
</div>

<div class="col-md-12">
    <button class="btn" id="refreshAct" type="button"><b>{{ lang._('Refresh') }}</b><i id="refreshAct_progress"></i>
    </button>
</div>
