import React from 'react';
import logo from './logo.svg';
import './App.css';
import HelloWorld from './components/HelloWorld';
import { ChakraProvider } from '@chakra-ui/react'

function App() {
  return (
    <ChakraProvider>
      <div className="App" style={{
        margin: 'auto',
        width: '100%'
      }}>
        <HelloWorld />
      </div>
    </ChakraProvider>
  );
}

export default App;
