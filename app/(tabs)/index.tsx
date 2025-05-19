import React, { useState, useEffect } from 'react';
import { 
  View, 
  Text, 
  StyleSheet, 
  ScrollView, 
  TouchableOpacity, 
  Image,
  Dimensions, 
  Platform,
  Animated,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Bluetooth, Info } from 'lucide-react-native';
import { StatusBar } from 'expo-status-bar';
import { colors } from '@/constants/colors';
import { ConnectButton } from '@/components/ConnectButton';
import { Feature } from '@/components/Feature';
import { useBluetooth } from '@/hooks/useBluetooth';

const { width } = Dimensions.get('window');

export default function HomeScreen() {
  const router = useRouter();
  const { isConnected, connect, disconnect } = useBluetooth();
  const [scrollY] = useState(new Animated.Value(0));

  // Animation values
  const headerOpacity = scrollY.interpolate({
    inputRange: [0, 100],
    outputRange: [0, 1],
    extrapolate: 'clamp',
  });

  const imageScale = scrollY.interpolate({
    inputRange: [0, 100],
    outputRange: [1, 0.8],
    extrapolate: 'clamp',
  });

  return (
    <View style={styles.container}>
      <StatusBar style="light" />
      
      {/* Animated Header */}
      <Animated.View
        style={[
          styles.header,
          {
            opacity: headerOpacity,
            height: Platform.OS === 'ios' ? 100 : 70,
            paddingTop: Platform.OS === 'ios' ? 50 : 20,
          },
        ]}>
        <Text style={styles.headerTitle}>ZenMat Smart Yoga</Text>
        {isConnected && (
          <View style={styles.connectionIndicator}>
            <Bluetooth size={14} color={colors.success} />
            <Text style={styles.connectionText}>Connected</Text>
          </View>
        )}
      </Animated.View>

      <Animated.ScrollView
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
        onScroll={Animated.event(
          [{ nativeEvent: { contentOffset: { y: scrollY } } }],
          { useNativeDriver: false }
        )}
        scrollEventThrottle={16}>
        <SafeAreaView style={styles.safeArea}>
          <View style={styles.heroContainer}>
            <Animated.View style={{ transform: [{ scale: imageScale }] }}>
              <Image
                source={{ uri: 'https://images.pexels.com/photos/2780762/pexels-photo-2780762.jpeg' }}
                style={styles.heroImage}
                resizeMode="cover"
              />
            </Animated.View>
            
            <View style={styles.heroOverlay}>
              <Text style={styles.heroTitle}>ZenMat</Text>
              <Text style={styles.heroSubtitle}>Smart Yoga Experience</Text>
              
              <View style={styles.statusContainer}>
                <ConnectButton 
                  isConnected={isConnected}
                  onPress={() => isConnected ? disconnect() : connect()}
                />
              </View>
            </View>
          </View>

          <View style={styles.featuresContainer}>
            <Text style={styles.sectionTitle}>Smart Features</Text>
            
            <Feature
              title="Pressure Sensing"
              description="Real-time posture feedback with 1,000+ pressure sensors"
              icon="activity"
              color={colors.purple}
            />
            
            <Feature
              title="Guided Sessions"
              description="Follow personalized yoga routines with interactive LEDs"
              icon="sparkles"
              color={colors.teal}
            />
            
            <Feature
              title="Progress Tracking"
              description="Monitor your yoga journey with detailed analytics"
              icon="bar-chart"
              color={colors.accent}
            />
          </View>

          <TouchableOpacity 
            style={styles.getStartedButton} 
            onPress={() => router.push('/(tabs)/control')}>
            <Text style={styles.getStartedText}>Start Your Practice</Text>
          </TouchableOpacity>

          <View style={styles.infoSection}>
            <Info size={16} color={colors.textLight} />
            <Text style={styles.infoText}>
              Connect your ZenMat to access all smart features. The mat requires Bluetooth 5.0 or higher.
            </Text>
          </View>
        </SafeAreaView>
      </Animated.ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  header: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    backgroundColor: colors.white,
    zIndex: 10,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  headerTitle: {
    fontFamily: 'Poppins-SemiBold',
    fontSize: 18,
    color: colors.textDark,
  },
  connectionIndicator: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  connectionText: {
    fontFamily: 'Inter-Medium',
    fontSize: 12,
    color: colors.success,
    marginLeft: 4,
  },
  safeArea: {
    flex: 1,
  },
  scrollContent: {
    paddingBottom: 40,
  },
  heroContainer: {
    position: 'relative',
    width: width,
    height: 500,
  },
  heroImage: {
    width: width,
    height: 500,
  },
  heroOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: 20,
    paddingBottom: 30,
    backgroundColor: 'rgba(0,0,0,0.3)',
  },
  heroTitle: {
    fontFamily: 'Poppins-Bold',
    fontSize: 40,
    color: colors.white,
    textShadowColor: 'rgba(0,0,0,0.5)',
    textShadowOffset: { width: 1, height: 1 },
    textShadowRadius: 5,
  },
  heroSubtitle: {
    fontFamily: 'Inter-Regular',
    fontSize: 18,
    color: colors.white,
    marginBottom: 20,
    textShadowColor: 'rgba(0,0,0,0.5)',
    textShadowOffset: { width: 1, height: 1 },
    textShadowRadius: 2,
  },
  statusContainer: {
    marginTop: 10,
  },
  featuresContainer: {
    padding: 20,
  },
  sectionTitle: {
    fontFamily: 'Poppins-SemiBold',
    fontSize: 22,
    color: colors.textDark,
    marginBottom: 16,
  },
  getStartedButton: {
    backgroundColor: colors.primary,
    marginHorizontal: 20,
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
    marginTop: 10,
  },
  getStartedText: {
    fontFamily: 'Inter-SemiBold',
    color: colors.white,
    fontSize: 16,
  },
  infoSection: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginTop: 20,
    marginHorizontal: 20,
    padding: 16,
    backgroundColor: colors.cardBackground,
    borderRadius: 12,
  },
  infoText: {
    flex: 1,
    fontFamily: 'Inter-Regular',
    fontSize: 14,
    color: colors.textLight,
    marginLeft: 8,
    lineHeight: 20,
  },
});