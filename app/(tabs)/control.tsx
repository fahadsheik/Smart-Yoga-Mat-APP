import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Platform } from 'react-native';
import { Activity, CirclePlay as PlayCircle, Pause } from 'lucide-react-native';
import Animated, { useSharedValue, useAnimatedStyle, withTiming, withRepeat, Easing } from 'react-native-reanimated';
import { SafeAreaView } from 'react-native-safe-area-context';
import { colors } from '@/constants/colors';
import { useBluetooth } from '@/hooks/useBluetooth';

export default function ControlScreen() {
  const { isConnected } = useBluetooth();
  const [activeMode, setActiveMode] = useState<'warmup' | 'relaxation' | null>(null);

  // Animation values
  const pulseValue = useSharedValue(1);
  const glowValue = useSharedValue(0);

  if (activeMode) {
    pulseValue.value = withRepeat(
      withTiming(1.1, { duration: 2000, easing: Easing.inOut(Easing.ease) }),
      -1,
      true
    );
    
    glowValue.value = withRepeat(
      withTiming(1, { duration: 2000, easing: Easing.inOut(Easing.ease) }),
      -1,
      true
    );
  }

  const pulseStyle = useAnimatedStyle(() => {
    return {
      transform: [{ scale: activeMode ? pulseValue.value : 1 }],
    };
  });

  const glowStyle = useAnimatedStyle(() => {
    return {
      opacity: activeMode ? 0.8 * glowValue.value : 0,
    };
  });

  const handleModeToggle = (mode: 'warmup' | 'relaxation') => {
    if (activeMode === mode) {
      setActiveMode(null); // Turn off if already active
    } else {
      setActiveMode(mode);
    }
  };

  return (
    <SafeAreaView edges={['top']} style={styles.safeArea}>
      <View style={styles.container}>
        <Text style={styles.screenTitle}>Mat Control</Text>

        {!isConnected ? (
          <View style={styles.notConnectedContainer}>
            <Text style={styles.notConnectedText}>Please connect to your ZenMat first</Text>
            <TouchableOpacity style={styles.connectButton}>
              <Text style={styles.connectButtonText}>Go to Connect</Text>
            </TouchableOpacity>
          </View>
        ) : (
          <ScrollView contentContainerStyle={styles.scrollContent}>
            <View style={styles.statusContainer}>
              <View style={styles.statusIndicator}>
                <View style={[
                  styles.statusDot, 
                  { backgroundColor: isConnected ? colors.success : colors.error }
                ]} />
                <Text style={styles.statusText}>
                  {isConnected ? 'Connected to ZenMat' : 'Disconnected'}
                </Text>
              </View>
              
              <Text style={styles.statusDetails}>
                Bluetooth signal strength: Excellent
              </Text>
              <Text style={styles.statusDetails}>
                Battery: 87%
              </Text>
            </View>

            {/* Animated Mat Control Area */}
            <View style={styles.matControlArea}>
              <Animated.View style={[styles.matOutline, pulseStyle]}>
                <Animated.View style={[styles.matGlow, glowStyle]} />
                
                <View style={[
                  styles.matStatus,
                  activeMode === 'warmup' && styles.matStatusWarmup,
                  activeMode === 'relaxation' && styles.matStatusRelaxation
                ]}>
                  {activeMode ? (
                    <Activity size={24} color={colors.white} />
                  ) : null}
                  
                  <Text style={styles.matStatusText}>
                    {activeMode === 'warmup' 
                      ? 'Warm-Up Mode' 
                      : activeMode === 'relaxation'
                        ? 'Relaxation Mode'
                        : 'Ready'}
                  </Text>
                </View>
              </Animated.View>
            </View>

            <View style={styles.controlsContainer}>
              <TouchableOpacity
                style={[
                  styles.controlButton,
                  styles.warmupButton,
                  activeMode === 'warmup' && styles.activeButton,
                ]}
                onPress={() => handleModeToggle('warmup')}
              >
                {activeMode === 'warmup' ? (
                  <Pause size={30} color={colors.white} />
                ) : (
                  <PlayCircle size={30} color={colors.white} />
                )}
                <Text style={styles.controlButtonText}>
                  {activeMode === 'warmup' ? 'Stop Warm-Up' : 'Start Warm-Up'}
                </Text>
                <Text style={styles.controlDescription}>
                  Gentle heating to prepare your muscles for yoga
                </Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={[
                  styles.controlButton,
                  styles.relaxationButton,
                  activeMode === 'relaxation' && styles.activeButton,
                ]}
                onPress={() => handleModeToggle('relaxation')}
              >
                {activeMode === 'relaxation' ? (
                  <Pause size={30} color={colors.white} />
                ) : (
                  <PlayCircle size={30} color={colors.white} />
                )}
                <Text style={styles.controlButtonText}>
                  {activeMode === 'relaxation' ? 'Stop Relaxation' : 'Begin Relaxation'}
                </Text>
                <Text style={styles.controlDescription}>
                  Subtle vibration patterns for deep relaxation
                </Text>
              </TouchableOpacity>
            </View>

            <View style={styles.tipsContainer}>
              <Text style={styles.tipsTitle}>
                Tips for Better Practice
              </Text>
              <Text style={styles.tipsText}>
                • For Warm-Up: Place mat on a flat surface and allow 5 minutes to reach optimal temperature.
              </Text>
              <Text style={styles.tipsText}>
                • For Relaxation: Use with our companion sound packs for a fully immersive experience.
              </Text>
            </View>
          </ScrollView>
        )}
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: colors.background,
  },
  container: {
    flex: 1,
    padding: 16,
  },
  screenTitle: {
    fontFamily: 'Poppins-SemiBold',
    fontSize: 24,
    color: colors.textDark,
    marginBottom: 24,
  },
  notConnectedContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  notConnectedText: {
    fontFamily: 'Inter-Medium',
    fontSize: 18,
    color: colors.textMedium,
    marginBottom: 20,
    textAlign: 'center',
  },
  connectButton: {
    backgroundColor: colors.primary,
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 12,
  },
  connectButtonText: {
    fontFamily: 'Inter-Medium',
    fontSize: 16,
    color: colors.white,
  },
  scrollContent: {
    paddingBottom: 40,
  },
  statusContainer: {
    backgroundColor: colors.white,
    borderRadius: 16,
    padding: 16,
    marginBottom: 24,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 10,
    elevation: 2,
  },
  statusIndicator: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  statusDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    marginRight: 8,
  },
  statusText: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 16,
    color: colors.textDark,
  },
  statusDetails: {
    fontFamily: 'Inter-Regular',
    fontSize: 14,
    color: colors.textMedium,
    marginTop: 4,
  },
  matControlArea: {
    alignItems: 'center',
    marginVertical: 20,
  },
  matOutline: {
    width: 280,
    height: 160,
    borderRadius: 16,
    borderWidth: 2,
    borderColor: colors.border,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.white,
    position: 'relative',
    overflow: 'hidden',
  },
  matGlow: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: colors.primary,
    opacity: 0.1,
  },
  matStatus: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 30,
  },
  matStatusWarmup: {
    backgroundColor: colors.purple,
  },
  matStatusRelaxation: {
    backgroundColor: colors.teal,
  },
  matStatusText: {
    fontFamily: 'Inter-Medium',
    fontSize: 18,
    color: colors.white,
    marginLeft: 8,
  },
  controlsContainer: {
    marginTop: 12,
  },
  controlButton: {
    backgroundColor: colors.white,
    borderRadius: 16,
    padding: 20,
    marginBottom: 16,
    flexDirection: 'column',
    alignItems: 'flex-start',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 10,
    elevation: 2,
  },
  warmupButton: {
    borderLeftWidth: 4,
    borderLeftColor: colors.purple,
  },
  relaxationButton: {
    borderLeftWidth: 4,
    borderLeftColor: colors.teal,
  },
  activeButton: {
    backgroundColor: colors.lavender,
  },
  controlButtonText: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 18,
    color: colors.textDark,
    marginTop: 12,
    marginBottom: 4,
  },
  controlDescription: {
    fontFamily: 'Inter-Regular',
    fontSize: 14,
    color: colors.textLight,
    lineHeight: 20,
  },
  tipsContainer: {
    backgroundColor: colors.white,
    borderRadius: 16,
    padding: 16,
    marginTop: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 10,
    elevation: 2,
  },
  tipsTitle: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 16,
    color: colors.textDark,
    marginBottom: 12,
  },
  tipsText: {
    fontFamily: 'Inter-Regular',
    fontSize: 14,
    color: colors.textMedium,
    marginBottom: 8,
    lineHeight: 20,
  },
});