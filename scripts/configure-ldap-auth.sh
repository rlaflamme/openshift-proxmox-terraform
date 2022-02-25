oc apply -f cm-ldap-ca-config-map.yaml
oc apply -f ldap_provider.yaml
oc adm policy add-cluster-role-to-user cluster-admin rlaflamme
oc create secret generic ldap-secret --from-literal=bindPassword=please -n openshift-config


