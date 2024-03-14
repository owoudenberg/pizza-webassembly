WebAssembly
    .instantiateStreaming(fetch('add.wasm'), importObject)
    .then(({ instance }) => {
         console.log(instance.exports.add(40, 2)); 
    });
