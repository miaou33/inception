# INCEPTION

## NGINX

The `ssl_prefer_server_ciphers` directive specifies whether the server should use its own cipher suite preferences over that of the client during the SSL/TLS handshake.

When set to `on`, the server's cipher suite preference will take precedence.
When set to `off`, the server will respect the client's cipher suite preference if it is compatible with the server's configuration.
For older protocols like SSLv3 and TLSv1, setting `ssl_prefer_server_ciphers` to `on` was often recommended as a best practice for security. This allowed the server administrators to control which cipher suites were selected, ideally choosing the most secure ones that both the server and client supported. This was important for mitigating certain types of attacks or ensuring strong encryption.

However, for modern TLS versions (1.2 and 1.3), clients are generally expected to have good cipher preferences, and the ciphers themselves have been designed with various security improvements. Therefore, many now recommend setting `ssl_prefer_server_ciphers` to `off` to allow for protocol flexibility and to enable features like forward secrecy by allowing the client to choose a compatible cipher suite that also meets their needs.
