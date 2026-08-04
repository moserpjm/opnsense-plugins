<script type="text/javascript">
    $( document ).ready(function() {
        mapDataToFormUI({'frmAuthentication':"/api/tailscale/authentication/get"}).done(function(data) {
            updateServiceControlUI('tailscale');
        });

        $("#reconfigureAct").SimpleActionButton({
            onPreAction: function() {
                const dfObj = new $.Deferred();
                saveFormToEndpoint("/api/tailscale/authentication/set", 'frmAuthentication', function () { dfObj.resolve(); }, true, function () { dfObj.reject(); });
                return dfObj;
            },
                onAction: function(data, status) {
                updateServiceControlUI('tailscale');
            }
        });

        $("#resetAct").click(function() {
            stdDialogConfirm(
                '{{ lang._('Confirmation Required') }}',
                '{{ lang._('Stop and disable Tailscale and remove the node state? The node registers as a new device once Tailscale is enabled again.') }}',
                '{{ lang._('Yes') }}', '{{ lang._('Cancel') }}',
                function() {
                    $("#resetMessage").hide();
                    $("#resetAct_progress").addClass("fa fa-spinner fa-pulse");
                    ajaxCall(url = "/api/tailscale/service/reset", sendData = {},
                        callback = function(data, status) {
                            $("#resetAct_progress").removeClass("fa fa-spinner fa-pulse");
                            let failed = status != "success" || data['status'] != 'ok';
                            $("#resetMessage")
                                .removeClass("alert-info alert-danger")
                                .addClass(failed ? "alert-danger" : "alert-info")
                                .html(data['message'] ? data['message'] : '{{ lang._('Unable to reset the node state.') }}')
                                .show();
                            updateServiceControlUI('tailscale');
                        }
                    );
                }
            );
        });

    });
</script>
<div class="content-box">
    {{ partial("layout_partials/base_form",['fields':authenticationForm,'id':'frmAuthentication']) }}
</div>
<section class="page-content-main">
    <div class="content-box">
        <div class="col-md-12">
            <br/>
            <div id="tailscaleChangeMessage" class="alert alert-info" style="display: none" role="alert">
                {{ lang._('After changing settings, please remember to apply them') }}
            </div>
            <button class="btn btn-primary" id="reconfigureAct"
                    data-endpoint='/api/tailscale/service/reconfigure'
                    data-label="{{ lang._('Apply') }}"
                    data-error-title="{{ lang._('Error reconfiguring Tailscale') }}"
                    type="button"
            ></button>
            <button class="btn btn-default" id="resetAct" type="button">
                {{ lang._('Reset') }} <i id="resetAct_progress"></i>
            </button>
            <br/><br/>
            <div id="resetMessage" class="alert" style="display: none" role="alert"></div>
        </div>
    </div>
</section>
