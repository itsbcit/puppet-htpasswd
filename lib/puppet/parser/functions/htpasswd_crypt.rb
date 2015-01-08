Puppet::Parser::Functions::newfunction(:htpasswd_crypt, :type => :rvalue, :doc => <<-EOF
This function takes one argument (plain_password) and returns a crypt() hashed password.
OPTIONAL: the 2-character salt can be passed as a second argument for verification.
EOF
) do |args|
  raise Puppet::ParseError, "Wrong number of arguments" if args.to_a.length < 1 || args.to_a.length > 2
  plain_password = args.to_a[0]
  raise Puppet::ParseError, "First argument must be a string, got #{plain_password.class}" unless plain_password.is_a?(String)

  # use the salt argument if passed
  if args.to_a.length == 2
    salt = args.to_a[1]
    raise Puppet::ParseError, "Second argument must be a string, got #{salt.class}" unless salt.is_a?(String)
    raise Puppet::ParseError, "Salt must be 2 characters, got #{salt.length}"       unless salt.length == 2
  else # generate a random salt
    salt_chars = ['.', '/']
    salt_chars.concat( ('0'..'9').to_a )
    salt_chars.concat( ('a'..'z').to_a )
    salt_chars.concat( ('A'..'Z').to_a )
    salt_chars.compact!

    salt = ''
    2.times { salt << salt_chars[ rand(salt_chars.size) ].to_s }
  end

  crypted_password = plain_password.crypt(salt)

  return crypted_password
end
