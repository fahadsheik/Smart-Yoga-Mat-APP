import React from 'react';
import { TouchableOpacity, Text, StyleSheet, ActivityIndicator, View } from 'react-native';
import { Bluetooth } from 'lucide-react-native';
import { colors } from '@/constants/colors';

type ConnectButtonProps = {
  isConnected: boolean;
  onPress: () => void;
  isLoading?: boolean;
};

export const ConnectButton = ({ isConnected, onPress, isLoading = false }: ConnectButtonProps) => {
  return (
    <TouchableOpacity 
      style={[
        styles.button,
        isConnected ? styles.disconnectButton : styles.connectButton
      ]}
      onPress={onPress}
      disabled={isLoading}
    >
      {isLoading ? (
        <ActivityIndicator size="small" color={isConnected ? colors.primary : colors.white} />
      ) : (
        <>
          <Bluetooth 
            size={20} 
            color={isConnected ? colors.primary : colors.white} 
          />
          <Text style={[
            styles.buttonText,
            isConnected ? styles.disconnectText : styles.connectText
          ]}>
            {isConnected ? 'Disconnect' : 'Connect to Mat'}
          </Text>
        </>
      )}
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  button: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 20,
    paddingVertical: 12,
    borderRadius: 12,
    minWidth: 180,
  },
  connectButton: {
    backgroundColor: colors.primary,
  },
  disconnectButton: {
    backgroundColor: colors.white,
    borderWidth: 1,
    borderColor: colors.primary,
  },
  buttonText: {
    marginLeft: 8,
    fontFamily: 'Inter-SemiBold',
    fontSize: 16,
  },
  connectText: {
    color: colors.white,
  },
  disconnectText: {
    color: colors.primary,
  },
});