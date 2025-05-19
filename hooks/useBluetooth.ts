import { useState } from 'react';

// Simulated Bluetooth hook since we can't actually connect to hardware
export function useBluetooth() {
  const [isConnected, setIsConnected] = useState(false);
  const [isConnecting, setIsConnecting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  
  const connect = async () => {
    setIsConnecting(true);
    setError(null);
    
    // Simulate connection delay
    try {
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      // Simulate a successful connection (90% success rate)
      const success = Math.random() < 0.9;
      
      if (success) {
        setIsConnected(true);
      } else {
        setError('Connection failed. Please try again.');
      }
    } catch (err) {
      setError('Unexpected error occurred.');
    } finally {
      setIsConnecting(false);
    }
  };
  
  const disconnect = async () => {
    setIsConnecting(true);
    
    // Simulate disconnection delay
    try {
      await new Promise(resolve => setTimeout(resolve, 1000));
      setIsConnected(false);
    } catch (err) {
      setError('Error disconnecting from device.');
    } finally {
      setIsConnecting(false);
    }
  };
  
  return {
    isConnected,
    isConnecting,
    error,
    connect,
    disconnect,
  };
}