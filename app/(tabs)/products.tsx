import React, { useState } from 'react';
import { 
  View, 
  Text, 
  StyleSheet, 
  ScrollView, 
  Image, 
  TouchableOpacity,
  Linking
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ExternalLink, ChevronRight, ShoppingBag, Star } from 'lucide-react-native';
import { colors } from '@/constants/colors';

type Product = {
  id: string;
  name: string;
  description: string;
  price: number;
  imageUrl: string;
  rating: number;
  isNew: boolean;
  category: 'mats' | 'accessories' | 'apparel';
};

const products: Product[] = [
  {
    id: '1',
    name: 'ZenMat Pro',
    description: 'Our premium smart yoga mat with 1000+ sensors and LED guidance system',
    price: 149.99,
    imageUrl: 'https://images.pexels.com/photos/4056535/pexels-photo-4056535.jpeg',
    rating: 4.8,
    isNew: true,
    category: 'mats',
  },
  {
    id: '2',
    name: 'ZenMat Travel',
    description: 'Portable, foldable smart yoga mat with basic pressure sensing',
    price: 89.99,
    imageUrl: 'https://images.pexels.com/photos/4498482/pexels-photo-4498482.jpeg',
    rating: 4.6,
    isNew: false,
    category: 'mats',
  },
  {
    id: '3',
    name: 'Mat Carry Strap',
    description: 'Adjustable cotton strap for easy mat transport',
    price: 19.99,
    imageUrl: 'https://images.pexels.com/photos/4662438/pexels-photo-4662438.jpeg',
    rating: 4.5,
    isNew: false,
    category: 'accessories',
  },
  {
    id: '4',
    name: 'ZenMat Cleaner Spray',
    description: 'Natural, antibacterial spray specially formulated for smart mats',
    price: 12.99,
    imageUrl: 'https://images.pexels.com/photos/5578218/pexels-photo-5578218.jpeg',
    rating: 4.7,
    isNew: true,
    category: 'accessories',
  },
  {
    id: '5',
    name: 'Bamboo Yoga Blocks (2)',
    description: 'Eco-friendly yoga blocks made from sustainable bamboo',
    price: 29.99,
    imageUrl: 'https://images.pexels.com/photos/4325462/pexels-photo-4325462.jpeg',
    rating: 4.9,
    isNew: false,
    category: 'accessories',
  },
  {
    id: '6',
    name: 'ZenFlow Yoga Pants',
    description: 'High-performance, breathable yoga pants with phone pocket',
    price: 49.99,
    imageUrl: 'https://images.pexels.com/photos/4662356/pexels-photo-4662356.jpeg',
    rating: 4.7,
    isNew: true,
    category: 'apparel',
  },
];

export default function ProductsScreen() {
  const [selectedCategory, setSelectedCategory] = useState<'all' | 'mats' | 'accessories' | 'apparel'>('all');
  
  const filteredProducts = selectedCategory === 'all' 
    ? products 
    : products.filter(product => product.category === selectedCategory);
  
  const newProducts = products.filter(product => product.isNew);
  
  const openProductLink = (productId: string) => {
    // In a real app, this would navigate to a product detail page
    // or open a web link for purchase
    alert(`Opening product ${productId} in store`);
  };
  
  return (
    <SafeAreaView edges={['top']} style={styles.safeArea}>
      <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
        <Text style={styles.screenTitle}>Shop</Text>
        
        {/* Featured Products Banner */}
        <View style={styles.featuredContainer}>
          <Text style={styles.featuredTitle}>New Arrivals</Text>
          <ScrollView 
            horizontal 
            showsHorizontalScrollIndicator={false}
            style={styles.featuredScroll}
          >
            {newProducts.map(product => (
              <TouchableOpacity 
                key={product.id}
                style={styles.featuredItem}
                onPress={() => openProductLink(product.id)}
              >
                <Image 
                  source={{ uri: product.imageUrl }} 
                  style={styles.featuredImage}
                />
                <View style={styles.newBadge}>
                  <Text style={styles.newBadgeText}>NEW</Text>
                </View>
                <View style={styles.featuredInfo}>
                  <Text style={styles.featuredName}>{product.name}</Text>
                  <Text style={styles.featuredPrice}>${product.price}</Text>
                </View>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>
        
        {/* Category Filters */}
        <View style={styles.categoryContainer}>
          <ScrollView 
            horizontal 
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.categoryScroll}
          >
            <TouchableOpacity
              style={[
                styles.categoryButton,
                selectedCategory === 'all' && styles.categoryButtonActive,
              ]}
              onPress={() => setSelectedCategory('all')}
            >
              <Text style={[
                styles.categoryButtonText,
                selectedCategory === 'all' && styles.categoryButtonTextActive,
              ]}>
                All Products
              </Text>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[
                styles.categoryButton,
                selectedCategory === 'mats' && styles.categoryButtonActive,
              ]}
              onPress={() => setSelectedCategory('mats')}
            >
              <Text style={[
                styles.categoryButtonText,
                selectedCategory === 'mats' && styles.categoryButtonTextActive,
              ]}>
                Mats
              </Text>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[
                styles.categoryButton,
                selectedCategory === 'accessories' && styles.categoryButtonActive,
              ]}
              onPress={() => setSelectedCategory('accessories')}
            >
              <Text style={[
                styles.categoryButtonText,
                selectedCategory === 'accessories' && styles.categoryButtonTextActive,
              ]}>
                Accessories
              </Text>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[
                styles.categoryButton,
                selectedCategory === 'apparel' && styles.categoryButtonActive,
              ]}
              onPress={() => setSelectedCategory('apparel')}
            >
              <Text style={[
                styles.categoryButtonText,
                selectedCategory === 'apparel' && styles.categoryButtonTextActive,
              ]}>
                Apparel
              </Text>
            </TouchableOpacity>
          </ScrollView>
        </View>
        
        {/* Product Grid */}
        <View style={styles.productsGrid}>
          {filteredProducts.map(product => (
            <TouchableOpacity 
              key={product.id}
              style={styles.productCard}
              onPress={() => openProductLink(product.id)}
            >
              <Image 
                source={{ uri: product.imageUrl }} 
                style={styles.productImage}
              />
              {product.isNew && (
                <View style={styles.productNewBadge}>
                  <Text style={styles.productNewBadgeText}>NEW</Text>
                </View>
              )}
              <View style={styles.productInfo}>
                <Text style={styles.productName}>{product.name}</Text>
                <Text style={styles.productDescription} numberOfLines={2}>
                  {product.description}
                </Text>
                <View style={styles.productMeta}>
                  <View style={styles.ratingContainer}>
                    <Star size={14} color={colors.accent} fill={colors.accent} />
                    <Text style={styles.ratingText}>{product.rating}</Text>
                  </View>
                  <Text style={styles.productPrice}>${product.price}</Text>
                </View>
                <TouchableOpacity style={styles.buyButton}>
                  <ShoppingBag size={16} color={colors.white} />
                  <Text style={styles.buyButtonText}>Add to Cart</Text>
                </TouchableOpacity>
              </View>
            </TouchableOpacity>
          ))}
        </View>
        
        {/* Visit Full Store Banner */}
        <TouchableOpacity 
          style={styles.storeLink}
          onPress={() => Linking.openURL('https://example.com/store')}
        >
          <Text style={styles.storeLinkText}>Visit our full online store</Text>
          <ExternalLink size={16} color={colors.primary} />
        </TouchableOpacity>
      </ScrollView>
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
  featuredContainer: {
    marginBottom: 24,
  },
  featuredTitle: {
    fontFamily: 'Poppins-SemiBold',
    fontSize: 18,
    color: colors.textDark,
    marginBottom: 16,
  },
  featuredScroll: {
    marginHorizontal: -16,
    paddingHorizontal: 16,
  },
  featuredItem: {
    width: 200,
    marginRight: 16,
    borderRadius: 12,
    overflow: 'hidden',
    backgroundColor: colors.white,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 10,
    elevation: 2,
  },
  featuredImage: {
    width: '100%',
    height: 150,
  },
  newBadge: {
    position: 'absolute',
    top: 10,
    right: 10,
    backgroundColor: colors.accent,
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 4,
  },
  newBadgeText: {
    fontFamily: 'Inter-Bold',
    fontSize: 10,
    color: colors.white,
  },
  featuredInfo: {
    padding: 12,
  },
  featuredName: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 14,
    color: colors.textDark,
    marginBottom: 4,
  },
  featuredPrice: {
    fontFamily: 'Inter-Bold',
    fontSize: 16,
    color: colors.primary,
  },
  categoryContainer: {
    marginBottom: 24,
  },
  categoryScroll: {
    paddingVertical: 8,
  },
  categoryButton: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: colors.white,
    marginRight: 12,
    borderWidth: 1,
    borderColor: colors.border,
  },
  categoryButtonActive: {
    backgroundColor: colors.primary,
    borderColor: colors.primary,
  },
  categoryButtonText: {
    fontFamily: 'Inter-Medium',
    fontSize: 14,
    color: colors.textMedium,
  },
  categoryButtonTextActive: {
    color: colors.white,
  },
  productsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  productCard: {
    width: '48%',
    backgroundColor: colors.white,
    borderRadius: 12,
    overflow: 'hidden',
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 10,
    elevation: 2,
  },
  productImage: {
    width: '100%',
    height: 120,
  },
  productNewBadge: {
    position: 'absolute',
    top: 8,
    right: 8,
    backgroundColor: colors.accent,
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
  productNewBadgeText: {
    fontFamily: 'Inter-Bold',
    fontSize: 8,
    color: colors.white,
  },
  productInfo: {
    padding: 12,
  },
  productName: {
    fontFamily: 'Inter-SemiBold',
    fontSize: 14,
    color: colors.textDark,
    marginBottom: 4,
  },
  productDescription: {
    fontFamily: 'Inter-Regular',
    fontSize: 12,
    color: colors.textLight,
    marginBottom: 8,
    height: 36,
  },
  productMeta: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  ratingContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  ratingText: {
    fontFamily: 'Inter-Medium',
    fontSize: 12,
    color: colors.textMedium,
    marginLeft: 4,
  },
  productPrice: {
    fontFamily: 'Inter-Bold',
    fontSize: 14,
    color: colors.primary,
  },
  buyButton: {
    backgroundColor: colors.primary,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 8,
    borderRadius: 6,
  },
  buyButtonText: {
    fontFamily: 'Inter-Medium',
    fontSize: 12,
    color: colors.white,
    marginLeft: 6,
  },
  storeLink: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 16,
    marginBottom: 24,
    paddingVertical: 12,
    backgroundColor: `${colors.primary}10`,
    borderRadius: 8,
  },
  storeLinkText: {
    fontFamily: 'Inter-Medium',
    fontSize: 14,
    color: colors.primary,
    marginRight: 8,
  },
});