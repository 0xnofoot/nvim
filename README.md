the nvim config

if you use MacOS and you need code with swift to develop the IOS App,
you need mkdir ./tool/swift and install some tool to it:

1.codelldb: install the codelldb-x86_64-darwin.vsix to debug the swift code.
    link: https://github.com/vadimcn/codelldb/releases

2.swiftlint: brew install swiftlint to forced syntax checking.
    link: brew install swiftlint

3.xcode-build-server: install it and make a link to /usr/local/bin/, it will parse the XCode Project and make sourcekit easy to use. 
    link: https://github.com/SolaWing/xcode-build-server

if you don't develop IOS App with swift,
you can delete some content in ./default_config/__machine_specific_default.lua which with sourcekit and lldb,
and you can delete the lsp config for swfit too.

when you first open nvim after clone it, you may crush your nvim because your network,
make sure you can connect github to install plugins for nvim.
