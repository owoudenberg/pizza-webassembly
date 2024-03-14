# Step 1: setting up the environment

The first thing you should install (assuming you have Node set up already) is a package called http-server.

`npm install http-server`

# Step 2: creating your first WebAssembly module

Creating the actual WASM file takes just a few seconds. Run the following command from your console:

wasm-tools parse add.wat -o add.wasm

# Step 3: run your WASM file from a browser

To start the server, run this command in your console:

`http-server`

After the server starts, it will print into the console the address you can use to access your site (in my case it’s http://127.0.0.1:8080). Upon loading it, there should be no error, and you should be able to try out the fib function in your browser’s console, like this:

