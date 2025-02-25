import React, { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form'
import {
  FormErrorMessage,
  FormLabel,
  FormControl,
  Input,
  Box,
  Button,
  Text,
  FormHelperText,
} from '@chakra-ui/react'
import { fetchWithAbort } from '../utils/timedPromise'

function HelloWorld() {
  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
  const wsUrl = `${protocol}//${window.location.host}/ws`;

  const {
    handleSubmit,
    register,
    formState: { errors, isSubmitting },
  } = useForm()

  const [message, setMessage] = useState<string>('');
  const [buttonMessage, setButtonMessage] = useState<string>('');
  const [wsMessage, setWsMessage] = useState<string>('');
  const [ws, setWs] = useState<WebSocket | null>(null);

  const handleInputChange = (e: any) => setMessage(e.target.value)

  const sendToAPI = async (data: string) => {

    fetchWithAbort('/api/submit', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ data }),
    })
      .then((response: Response) => response.json())
      .then((responseData: any) => alert(responseData.message))
      .catch((error: Error) => alert(error));
  }

  useEffect(() => {
    let websocket: WebSocket;
    
    const connect = () => {
      websocket = new WebSocket(wsUrl);
      
      websocket.onopen = () => {
        console.log('Connected to WebSocket');
      };

      websocket.onmessage = (event: MessageEvent) => {
        setWsMessage(event.data);
      };

      websocket.onclose = () => {
        console.log('WebSocket closed, reconnecting...');
        // Reconnect after a short delay
        setTimeout(connect, 1000);
      };

      setWs(websocket);
    };

    connect();

    // Cleanup function
    return () => {
      websocket.close();
    };
  }, []); // Empty dependency array to run only once on mount

  const onSubmit = async (data: any) => {
    return await sendToAPI(data.messageText)
  };

  const sendButtonMessage = async () => {
    setButtonMessage(message);
  };

  const sendWebSocketMessage = () => {
    if (ws) {
      ws.send(message);
    }
  };


  const isError = message === ''

  return (
    <Box h='100%' p={4} maxW='sm' borderWidth='4px' borderColor='red' borderRadius='lg' overflow='hidden' w='100%'>
      <form onSubmit={handleSubmit(onSubmit)}>
        <FormControl isInvalid={isError}>
          <FormLabel htmlFor='messageText'>Message</FormLabel>
          <Input
            id='messageText'
            placeholder='message text'
            {...register('messageText', {
              required: 'This is required',
              minLength: { value: 4, message: 'Minimum length should be 4' },
            })}
            onChange={handleInputChange}
          />
          {!isError ? (
            <FormHelperText>
              Enter the message
            </FormHelperText>
          ) : (
            <FormErrorMessage>Message is required.</FormErrorMessage>
          )}
        </FormControl>
        <Button mt={4} colorScheme='teal' isLoading={isSubmitting} type='submit'>
          Submit
        </Button>
      </form>
      <Box h='100%' p={4} maxW='sm' borderWidth='4px' borderColor='red' borderRadius='sm' overflow='hidden' w='100%'>
        <Button onClick={sendButtonMessage} colorScheme='teal'>Send Button Message</Button>
        <p><Text>Button Message: {buttonMessage}</Text></p>
        <Button onClick={sendWebSocketMessage} colorScheme='teal'>Send WebSocket Message</Button>
        <p><Text>WebSocket Message: {wsMessage}</Text></p>
      </Box>
    </Box>
  );
}

export default HelloWorld;
