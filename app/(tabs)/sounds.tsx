import React, { useState, useEffect } from 'react';
import { 
  View, 
  Text, 
  StyleSheet, 
  TouchableOpacity, 
  ScrollView, 
  Image, 
  Platform 
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Play, Pause, Volume2, Volume1, VolumeX } from 'lucide-react-native';
import Animated, { 
  useSharedValue, 
  useAnimatedStyle, 
  withTiming,
  withRepeat,
  Easing
} from 'react-native-reanimated';
import { colors } from '@/constants/colors';

type SoundItem = {
  id: string;
  title: string;
  category: 'nature' | 'meditation' | 'ambient';
  imageUrl: string;
  duration: string;
};

const soundsData: SoundItem[] = [
  {
    id: '1',
    title: 'Ocean Waves',
    category: 'nature',
    imageUrl: 'https://images.pexels.com/photos/1295138/pexels-photo-1295138.jpeg',
    duration: '10:00',
  },
  {
    id: '2',
    title: 'Forest Ambience',
    category: 'nature',
    imageUrl: 'https://images.pexels.com/photos/957024/forest-trees-perspective-bright-957024.jpeg',
    duration: '15:00',
  },
  {
    id: '3',
    title: 'Guided Breathing',
    category: 'meditation',
    imageUrl: 'https://images.pexels.com/photos/3822864/pexels-photo-3822864.jpeg',
    duration: '8:00',
  },
  {
    id: '4',
    title: 'Tibetan Singing Bowls',
    category: 'meditation',
    imageUrl: 'https://images.pexels.com/photos/8964880/pexels-photo-8964880.jpeg',
    duration: '12:00',
  },
  {
    id: '5',
    title: 'Gentle Rain',
    category: 'nature',
    imageUrl: 'https://images.pexels.com/photos/125510/pexels-photo-125510.jpeg',
    duration: '20:00',
  },
  {
    id: '6',
    title: 'Ambient Synthesizer',
    category: 'ambient',
    imageUrl: 'https://images.pexels.com/photos/4571219/pexels-photo-4571219.jpeg',
    duration: '18:00',
  },
];

export default function SoundsScreen() {
  // Initialize all hooks at the top level
  const [activeCategory, setActiveCategory] = useState<'all' | 'nature' | 'meditation' | 'ambient'>('all');
  const [playing, setPlaying] = useState<string | null>(null);
  const [volume, setVolume] = useState<number>(2);
  const soundWaveValue = useSharedValue(1);

  // Use useEffect for animations that depend on state
  useEffect(() => {
    if (playing) {
      soundWaveValue.value = withRepeat(
        withTiming(1.1, { duration: 1000, easing: Easing.inOut(Easing.ease) }),
        -1,
        true
      );
    } else {
      soundWaveValue.value = withTiming(1, { duration: 300 });
    }
  }, [playing]);
  
  const togglePlay = (id: string) => {
    if (playing === id) {
      setPlaying(null);
    } else {
      setPlaying(id);
    }
  };
  
  const toggleVolume = () => {
    setVolume((prev) => (prev + 1) % 3);
  };
  
  const getVolumeIcon = () => {
    switch (volume) {
      case 0:
        return <VolumeX size={24} color={colors.textDark} />;
      case 1:
        return <Volume1 size={24} color={colors.textDark} />;
      case 2:
        return <Volume2 size={24} color={colors.textDark} />;
      default:
        return <Volume2 size={24} color={colors.textDark} />;
    }
  };
  
  const filteredSounds = activeCategory === 'all' 
    ? soundsData 
    : soundsData.filter(sound => sound.category === activeCategory);
  
  return (
    <SafeAreaView edges={['top']} style={styles.safeArea}>
      <View style={styles.container}>
        <Text style={styles.screenTitle}>Sounds & Music</Text>
        
        <View style={styles.categoryContainer}>
          <ScrollView horizontal showsHorizontalScrollIndicator={false}>
            <TouchableOpacity
              style={[
                styles.categoryButton,
                activeCategory === 'all' && styles.activeCategoryButton,
              ]}
              onPress={() => setActiveCategory('all')}
            >
              <Text style={[
                styles.categoryText,
                activeCategory === 'all' && styles.activeCategoryText,
              ]}>
                All
              </Text>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[
                styles.categoryButton,
                activeCategory === 'nature' && styles.activeCategoryButton,
              ]}
              onPress={() => setActiveCategory('nature')}
            >
              <Text style={[
                styles.categoryText,
                activeCategory === 'nature' && styles.activeCategoryText,
              ]}>
                Nature
              </Text>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[
                styles.categoryButton,
                activeCategory === 'meditation' && styles.activeCategoryButton,
              ]}
              onPress={() => setActiveCategory('meditation')}
            >
              <Text style={[
                styles.categoryText,
                activeCategory === 'meditation' && styles.activeCategoryText,
              ]}>
                Meditation
              </Text>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[
                styles.categoryButton,
                activeCategory === 'ambient' && styles.activeCategoryButton,
              ]}
              onPress={() => setActiveCategory('ambient')}
            >
              <Text style={[
                styles.categoryText,
                activeCategory === 'ambient' && styles.activeCategoryText,
              ]}>
                Ambient
              </Text>
            </TouchableOpacity>
          </ScrollView>
        </View>
        
        <ScrollView 
          style={styles.soundsContainer}
          showsVerticalScrollIndicator={false}
        >
          {filteredSounds.map((sound) => {
            const isPlaying = playing === sound.id;
            
            const animatedStyle = useAnimatedStyle(() => {
              return {
                transform: [
                  { scale: isPlaying ? soundWaveValue.value : 1 },
                ],
              };
            });
            
            return (
              <Animated.View
                key={sound.id}
                style={[
                  styles.soundItem,
                  isPlaying && styles.playingSoundItem,
                  animatedStyle,
                ]}
              >
                <Image
                  source={{ uri: sound.imageUrl }}
                  style={styles.soundImage}
                />
                
                <View style={styles.soundInfo}>
                  <Text style={styles.soundTitle}>{sound.title}</Text>
                  <Text style={styles.soundDuration}>{sound.duration}</Text>
                </View>
                
                <TouchableOpacity
                  style={styles.playButton}
                  onPress={() => togglePlay(sound.id)}
                >
                  {isPlaying ? (
                    <Pause size={24} color={colors.white} />
                  ) : (
                    <Play size={24} color={colors.white} />
                  )}
                </TouchableOpacity>
              </Animated.View>
            );
          })}
        </ScrollView>
        
        {playing && (
          <View style={styles.playingBar}>
            <View style={styles.playingInfo}>
              <Text style={styles.playingTitle}>
                {soundsData.find(s => s.id === playing)?.title}
              </Text>
              <Text style={styles.playingCategory}>
                {soundsData.find(s => s.id === playing)?.category}
              </Text>
            </View>
            
            <View style={styles.playingControls}>
              <TouchableOpacity
                style={styles.volumeButton}
                onPress={toggleVolume}
              >
                {getVolumeIcon()}
              </TouchableOpacity>
              
              <TouchableOpacity
                style={styles.stopButton}
                onPress={() => setPlaying(null)}
              >
                <Pause size={24} color={colors.primary} />
              </TouchableOpacity>
            </View>
          </View>
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
  categoryContainer: {
    marginBottom: 24,
  },
  categoryButton: {
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 25,
    backgroundColor: colors.white,
    marginRight: 12,
    borderWidth: 1,
    borderColor: colors.border,
  },
  activeCategoryButton: {
    backgroundColor: colors.primary,
    borderColor: colors.primary,
  },
  categoryText: {
    fontFamily: 'Inter-Medium',
    fontSize: 14,
    color: colors.textMedium,
  },
  activeCategoryText: {
    color: colors.white,
  },
  soundsContainer: {
    flex: 1,
  },
  soundItem: {
    flexDirection: 'row',
    backgroundColor: colors.white,
    borderRadius: 16,
    overflow: 'hidden',
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 10,
    elevation: 2,
  },
  playingSoundItem: {
    borderWidth: 2,
    borderColor: colors.primary,
  },
  soundImage: {
    width: 80,
    height: 80,
  },
  soundInfo: {
    flex: 1,
    padding: 16,
    justifyContent: 'center',
  },
  soundTitle: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 16,
    color: colors.textDark,
    marginBottom: 4,
  },
  soundDuration: {
    fontFamily: 'Inter-Regular',
    fontSize: 14,
    color: colors.textLight,
  },
  playButton: {
    backgroundColor: colors.primary,
    width: 50,
    justifyContent: 'center',
    alignItems: 'center',
  },
  playingBar: {
    flexDirection: 'row',
    backgroundColor: colors.white,
    padding: 16,
    borderRadius: 16,
    marginTop: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: -2 },
    shadowOpacity: 0.05,
    shadowRadius: 10,
    elevation: 5,
  },
  playingInfo: {
    flex: 1,
  },
  playingTitle: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 16,
    color: colors.textDark,
  },
  playingCategory: {
    fontFamily: 'Inter-Regular',
    fontSize: 14,
    color: colors.textLight,
    textTransform: 'capitalize',
  },
  playingControls: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  volumeButton: {
    marginRight: 16,
  },
  stopButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: `${colors.primary}20`,
    justifyContent: 'center',
    alignItems: 'center',
  },
});