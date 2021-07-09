# How to install

This resource runs by using only the `index.html` file in the UI. In order to make this magic happen, we need to compile and build our UI into a single `dist` folder. The steps below show how to do this easily.

1) Make sure [NPM](https://www.npmjs.com/get-npm) is installed.
2) Check to see NPM is installed by running `npm -v` in a CMD.
3) Install Yarn by running `npm install -g yarn` in a CMD and run `yarn -v` to check if it has installed.
4) Start a CMD in the same location as this file, and run `yarn install` to install the necessary tools needed to build the UI. A `node_modules` folder should have been created.
5) Run `yarn run build` to build the UI files for the resource. This creates the `dist` folder with the necessary build files to run the UI.
6) Start the resource by putting `ensure diamondblackjackoriginal` in the `server.cfg`.
7) Enjoy!
