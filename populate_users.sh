#!/bin/bash

# 🔐 NesiaWay - Populate Sample Users Script
# Creates realistic admin and user accounts for testing

echo "🇮🇩 NesiaWay - Creating Sample Users"
echo "====================================="
echo ""

API_URL="https://691e876fbb52a1db22be25e9.mockapi.io/api/v1/user"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}📡 API Endpoint: $API_URL${NC}"
echo ""

# Function to create user
create_user() {
    local name=$1
    local email=$2
    local role=$3
    local password=$4
    local number=$5
    
    echo -e "${YELLOW}Creating User #$number: $name ($role)${NC}"
    
    RESPONSE=$(curl -s -X POST $API_URL \
      -H "Content-Type: application/json" \
      -d "{
        \"name\": \"$name\",
        \"email\": \"$email\",
        \"role\": \"$role\",
        \"password\": \"$password\"
      }")
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Created: $email (Password: $password)${NC}"
        # Parse and show ID
        ID=$(echo $RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
        if [ ! -z "$ID" ]; then
            echo -e "  ${BLUE}ID: $ID${NC}"
        fi
    else
        echo -e "${RED}✗ Failed to create: $email${NC}"
    fi
    echo ""
}

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Creating ADMIN Accounts (5)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ADMIN USERS (Password: admin123)
create_user "Admin NesiaWay" "admin@nesiaway.com" "admin" "admin123" "1"
create_user "Budi Santoso" "budi.admin@nesiaway.com" "admin" "admin123" "2"
create_user "Siti Nurhaliza" "siti.admin@nesiaway.com" "admin" "admin123" "3"
create_user "Rudi Hartono" "rudi@nesiaway.com" "admin" "admin123" "4"
create_user "Dewi Lestari" "dewi.admin@nesiaway.com" "admin" "admin123" "5"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Creating USER Accounts (10)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# REGULAR USERS (Password: user123)
create_user "Agus Setiawan" "agus@example.com" "user" "user123" "6"
create_user "Rina Wijaya" "rina@example.com" "user" "user123" "7"
create_user "Joko Widodo" "joko@example.com" "user" "user123" "8"
create_user "Maya Putri" "maya@example.com" "user" "user123" "9"
create_user "Andi Prasetyo" "andi@example.com" "user" "user123" "10"
create_user "Lina Marlina" "lina@example.com" "user" "user123" "11"
create_user "Wahyu Kurniawan" "wahyu@example.com" "user" "user123" "12"
create_user "Fitri Handayani" "fitri@example.com" "user" "user123" "13"
create_user "Yanto Suryanto" "yanto@example.com" "user" "user123" "14"
create_user "Indah Permata" "indah@example.com" "user" "user123" "15"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Verify all users created
echo -e "${YELLOW}📋 Verifying all users created...${NC}"
echo ""

ALL_USERS=$(curl -s $API_URL)
USER_COUNT=$(echo $ALL_USERS | grep -o '"id"' | wc -l)

echo -e "${GREEN}✅ Total users in database: $USER_COUNT${NC}"
echo ""

# Show summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Sample Data Created Successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}📊 Summary:${NC}"
echo "  • Admin accounts: 5"
echo "  • User accounts: 10"
echo "  • Total created: 15"
echo ""

echo -e "${YELLOW}🔑 Test Credentials:${NC}"
echo ""

echo -e "${GREEN}Default Admin (Always works):${NC}"
echo "  Email: admin@gmail.com"
echo "  Password: admin12345"
echo "  Role: admin"
echo ""

echo -e "${BLUE}API Admin Accounts:${NC}"
echo "  1. admin@nesiaway.com (Admin NesiaWay) - Password: admin123"
echo "  2. budi.admin@nesiaway.com (Budi Santoso) - Password: admin123"
echo "  3. siti.admin@nesiaway.com (Siti Nurhaliza) - Password: admin123"
echo "  4. rudi@nesiaway.com (Rudi Hartono) - Password: admin123"
echo "  5. dewi.admin@nesiaway.com (Dewi Lestari) - Password: admin123"
echo ""

echo -e "${BLUE}API User Accounts:${NC}"
echo "  6. agus@example.com (Agus Setiawan) - Password: user123"
echo "  7. rina@example.com (Rina Wijaya) - Password: user123"
echo "  8. joko@example.com (Joko Widodo) - Password: user123"
echo "  9. maya@example.com (Maya Putri) - Password: user123"
echo "  10. andi@example.com (Andi Prasetyo) - Password: user123"
echo "  11. lina@example.com (Lina Marlina) - Password: user123"
echo "  12. wahyu@example.com (Wahyu Kurniawan) - Password: user123"
echo "  13. fitri@example.com (Fitri Handayani) - Password: user123"
echo "  14. yanto@example.com (Yanto Suryanto) - Password: user123"
echo "  15. indah@example.com (Indah Permata) - Password: user123"
echo ""

echo -e "${YELLOW}📝 Password Info:${NC}"
echo -e "${YELLOW}   • Admin accounts: admin123${NC}"
echo -e "${YELLOW}   • User accounts: user123${NC}"
echo ""

echo -e "${GREEN}🚀 Next Steps:${NC}"
echo "  1. Rebuild APK: flutter build apk --release"
echo "  2. Install: adb install -r build/app/outputs/flutter-apk/app-release.apk"
echo "  3. Test login with emails above!"
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Show formatted user list
echo -e "${YELLOW}📋 View all users:${NC}"
echo "   curl -s $API_URL | python3 -m json.tool"
echo ""