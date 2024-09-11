require 'puppet/resource_api'

# rubocop:disable Metrics/LineLength

Puppet::ResourceApi.register_type(
  name: 'puppet_ds',
  docs: <<-EOS,
@summary Manages the Directory Services config in PE
@example
    puppet_ds { 'https://pe-201921-master.puppetdebug.vlan:4433':
      ensure                              => 'present',
      base_dn                             => 'ou=mathematicians,dc=example,dc=com',
      connect_timeout                     => 30,
      disable_ldap_matching_rule_in_chain => true,
      display_name                        => 'ldap.forumsys.com',
      group_lookup_attr                   => 'ou',
      group_member_attr                   => 'member',
      group_name_attr                     => 'name',
      group_object_class                  => 'ou',
      help_link                           => 'http://techsmruti.com/online-ldap-test-server/',
      hostname                            => 'ldap.forumsys.com',
      login                               => 'cn=read-only-admin,dc=example,dc=com',
      password                            => 'password',
      port                                => 636,
      search_nested_groups                => true,
      ssl                                 => true,
      ssl_hostname_validation             => true,
      ssl_wildcard_validation             => false,
      start_tls                           => false,
      user_display_name_attr              => 'displayName',
      user_email_attr                     => 'mail',
      user_lookup_attr                    => 'uid',
      user_rdn                            => 'uid',
    }

This must be applied to the Master which has RBAC running on it as it will use the agent's certs to auth.
EOS
  features: [],
  attributes: {
    ensure: {
      type:    'Enum[present, absent]',
      desc:    'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type:      'String',
      desc:      'URI of the console to manage, including port i.e. https://mymaster.company.com:4433',
      behaviour: :namevar,
    },
    force: {
      type: 'Optional[Boolean]',
      desc: 'Force will skip validation and force application of the config',
      behaviour: :parameter,
      default: false,
    },
    base_dn: {
      type: 'String',
      desc: '',
    },
    connect_timeout: {
      type: 'Integer',
      desc: 'The number of seconds that PE attempts to connect to the directory server before timing out. Ten seconds is fine in the majority of cases. If you are experiencing timeout errors, make sure the directory service is up and reachable, and then increase the timeout if necessary',
      default: 60,
    },
    disable_ldap_matching_rule_in_chain: {
      type: 'Boolean',
      desc: 'Select Yes to turn off the LDAP matching rule that looks up the chain of ancestry for an object until it finds a match. For organizations with a large number of group memberships, matching rule in chain can slow performance.',
      default: false,
    },
    display_name: {
      type: 'String',
      desc: 'The name that you provide here is used to refer to the external directory service anywhere it is used in the PE console. For example, when you view a remote user in the console, the name that you provide in this field is listed in the console as the source for that user. Set any name of your choice.',
    },
    group_lookup_attr: {
      type: 'String',
      desc: 'The value used to import groups into PE',
      default: 'cn',
    },
    group_member_attr: {
      type: 'String',
      desc: 'Tells PE how to find which users belong to which groups. This is the name of the attribute in the external directory groups that indicates who the group members are.',
      default: 'member',
    },
    group_name_attr: {
      type: 'String',
      desc: 'The attribute that stores the display name for groups. This is used for display purposes only.',
      default: 'name',
    },
    group_object_class: {
      type: 'String',
      desc: 'The name of an object class that all groups have',
      default: 'group',
    },
    group_rdn: {
      type: 'Optional[String]',
      desc: 'The group RDN that you set here is concatenated with the base DN to form the search base when looking up a group',
    },
    help_link: {
      type: 'Optional[String]',
      desc: 'If you supply a URL here, a "Need help logging in?" link is displayed on the login screen. The href attribute of this link is set to the URL that you provide',
    },
    hostname: {
      type: 'String',
      desc: 'The FQDN of the directory service to which you are connecting',
    },
    login: {
      type: 'Optional[String]',
      desc: 'The distinguished name (DN) of the directory service user account that PE uses to query information about users and groups in the directory server',
    },
    password: {
      type: 'Optional[String]',
      desc: 'The lookup user\'s password',
    },
    port: {
      type: 'Integer',
      desc: 'The port that PE uses to access the directory service. The port is generally 389, unless you choose to connect using SSL, in which case it is generally 636',
      default: 636,
    },
    search_nested_groups: {
      type: 'Boolean',
      desc: 'Select true to search for groups that are members of an external directory group. For organizations with a large number of nested group memberships, searching nested groups can slow performance',
      default: false,
    },
    ssl: {
      type: 'Boolean',
      desc: 'Whether to use SSL to connect, StartTLS and SSL are mutually exclusive',
      default: true,
    },
    ssl_hostname_validation: {
      type: 'Boolean',
      desc: 'Select Yes to verify that the Directory Services hostname used to connect to the LDAP server matches the hostname on the SSL certificate. This option is not available when you choose to connect to the external directory using plain text.',
      default: true,
    },
    ssl_wildcard_validation: {
      type: 'Boolean',
      desc: 'Select Yes to allow a connection to a Directory Services server with a SSL certificates that use a wildcard (*) specification. This option is not available when you choose to connect to the external directory using plain text.',
      default: false,
    },
    start_tls: {
      type: 'Boolean',
      desc: 'Whether to use StartTLS to connect, StartTLS and SSL are mutually exclusive',
      default: false,
    },
    type: {
      type: 'Optional',
      desc: 'This is undocumented, not sure what it is for',
      default: nil,
    },
    user_display_name_attr: {
      type: 'String',
      desc: 'The directory attribute to use when displaying the user\'s full name in PE',
      default: 'displayName',
    },
    user_email_attr: {
      type: 'String',
      desc: 'The directory attribute to use when displaying the user\'s email address in PE',
      default: 'mail',
    },
    user_lookup_attr: {
      type: 'String',
      desc: 'This is the directory attribute that the user uses to log in to PE. For example, if you specify sAMAccountName as the user login attribute, Harold logs in with the username "harold11" because sAMAccountName=harold11 in the example directory service entry provided above',
      default: 'sAMAccountName',
    },
    user_rdn: {
      type: 'Optional[String]',
      desc: 'The user RDN that you set here is concatenated with the base DN to form the search base when looking up a user. For example, if you specify ou=users for the user RDN, and your base DN setting is ou=Puppet,dc=example,dc=com, PE finds users that have ou=users,ou=Puppet,dc=example,dc=com in their DN',
    },
    id: {
      type: 'Optional[String]',
      desc: '',
    },
    cert_chain: {
      type: 'Optional[String]',
      desc: '',
    },
    creation_date: {
      type: 'Optional[String]',
      desc: '',
    },
  },
)
# rubocop:enable Metrics/LineLength
