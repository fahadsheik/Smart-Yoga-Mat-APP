import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Activity, Sparkles, ChartBar as BarChart, Bluetooth } from 'lucide-react-native';
import { colors } from '@/constants/colors';

type FeatureProps = {
  title: string;
  description: string;
  icon: 'activity' | 'sparkles' | 'bar-chart' | 'bluetooth' | string;
  color: string;
};

export const Feature = ({ title, description, icon, color }: FeatureProps) => {
  const getIcon = () => {
    switch (icon) {
      case 'activity':
        return <Activity size={24} color={color} />;
      case 'sparkles':
        return <Sparkles size={24} color={color} />;
      case 'bar-chart':
        return <BarChart size={24} color={color} />;
      case 'bluetooth':
        return <Bluetooth size={24} color={color} />;
      default:
        return <Activity size={24} color={color} />;
    }
  };

  return (
    <View style={styles.container}>
      <View style={[styles.iconContainer, { backgroundColor: `${color}20` }]}>
        {getIcon()}
      </View>
      <View style={styles.textContainer}>
        <Text style={styles.title}>{title}</Text>
        <Text style={styles.description}>{description}</Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    marginBottom: 16,
    padding: 16,
    backgroundColor: colors.cardBackground,
    borderRadius: 12,
  },
  iconContainer: {
    width: 48,
    height: 48,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  textContainer: {
    flex: 1,
  },
  title: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 16,
    color: colors.textDark,
    marginBottom: 4,
  },
  description: {
    fontFamily: 'Inter-Regular',
    fontSize: 14,
    color: colors.textLight,
    lineHeight: 20,
  },
});