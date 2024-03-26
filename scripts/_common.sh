#!/bin/bash

#=================================================
# CONFIG PANEL SETTERS
#=================================================

apply_permissions() {
    set -o noglob # Disable globbing to avoid expansions when passing * as value.
    declare values="list$role"
    newValues="${!values}" # Here we expand the dynamic variable we created in the previous line. ! Does the trick
    newValues="${newValues//\"}"
    usersArray=(${newValues//,/ }) # Split the values using comma (,) as separator.

    if [ -n "$newValues" ]
    then
        #ynh_systemd_action --service_name="$app" --action=stop
        # Get all entries between "permissions:" and "relay:" keys, remove the role part, remove commented parts, format it with newlines and clean whitespaces and double quotes.
        allDefinedEntries=$(awk '/permissions:/{flag=1; next} /relaybot:/{flag=0} flag' "$install_dir/config.yaml" | sed "/: $role/d" | sed -r 's/: (admin|user|relaybot|full|puppeting)//' | tr -d '[:blank:]' | sed '/^#/d' | tr -d '\"' | tr ',' '\n' )
        # Delete everything from the corresponding role to insert the new defined values. This way we also handle deletion of users.
        sed -i "/permissions:/,/relaybot:/{/: $role/d;}" "$install_dir/config.yaml"
        # Ensure that entries with value surrounded with quotes are deleted too. E.g. "users".
        sed -i "/permissions:/,/relaybot:/{/: \"$role\"/d;}" "$install_dir/config.yaml"
      	for user in "${usersArray[@]}"
            do
              if grep -q -x "${user}" <<< "$allDefinedEntries"
              then
                ynh_print_info "User $user already defined in another role."
              else
                sed -i "/permissions:/a \        \\\"$user\": $role" "$install_dir/config.yaml" # Whitespaces are needed so that the file can be correctly parsed
              fi
        done
    fi
    set +o noglob

    ynh_print_info "Users with role $role added in $install_dir/config.yaml"
}


set__listrelaybot() {
  role="relaybot"
  ynh_app_setting_set --app=$app --key=listrelaybot --value="$listrelaybot"
  apply_permissions
  ynh_store_file_checksum --file="$install_dir/config.yaml"
}

set__listuser() {
  role="user"
  ynh_app_setting_set --app=$app --key=listuser --value="$listuser"
  apply_permissions
  ynh_store_file_checksum --file="$install_dir/config.yaml"
}

set__listpuppeting() {
  role="puppeting"
  ynh_app_setting_set --app=$app --key=listpuppeting --value="$listpuppeting"
  apply_permissions
  ynh_store_file_checksum --file="$install_dir/config.yaml"
}

set__listfull() {
  role="full"
  ynh_app_setting_set --app=$app --key=listfull --value="$listfull"
  apply_permissions
  ynh_store_file_checksum --file="$install_dir/config.yaml"
}

set__listadmin() {
  role="admin"
  ynh_app_setting_set --app=$app --key=listadmin --value="$listadmin"
  apply_permissions
  ynh_store_file_checksum --file="$install_dir/config.yaml"
}

#=================================================
# COMMON VARIABLES
#=================================================

#=================================================
# PERSONAL HELPERS
#=================================================

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
