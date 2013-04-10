# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


# Display invitation form and send a post request

$ -> 
  $(".share a").button().click -> 
    a = this
    $("#invitation_form").attr "title", "Share '" + $(a).attr("folder_name") + "' with others" 
    $(".ui-dialog-title").text "Share '" + $(a).attr("folder_name") + "' with others"
    $("#folder_id").val $(a).attr("folder_id")
    
    $("#invitation_form").dialog
      height: 300
      width: 510
      modal: true
      buttons:
        Share: -> 
          post_url = $("#invitation_form form").attr("action")
          $.post post_url, $("#invitation_form form").serialize(), null, "script"
          false 
        Cancel: ->
          $(this).dialog "close"
      close: ->
        $("#message").val ""
        $("#email_addresses").val ""