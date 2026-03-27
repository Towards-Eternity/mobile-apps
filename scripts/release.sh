#!/bin/bash

# Önce GitHub'daki en güncel etiketleri sessizce çek
echo "Uzak sunucudaki etiketler kontrol ediliyor..."
git fetch --tags > /dev/null 2>&1

# 1. En son atılan tag'i GitHub'dan/Yerelden çek
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)

# Eğer hiç tag yoksa v1.0.0 ile başla
if [ -z "$LATEST_TAG" ]; then
    LATEST_TAG="v1.0.0"
fi

echo "Mevcut en son versiyon: $LATEST_TAG"

# 2. Versiyonu parçala (v1.2.3 -> 1 2 3)
# 'v' harfini kaldır ve noktaları boşluk yap
VERSION_BITS=(${LATEST_TAG//./ })
V_MAJOR=${VERSION_BITS[0]//v/}
V_MINOR=${VERSION_BITS[1]}
V_PATCH=${VERSION_BITS[2]}

# 3. Patch (en sondaki) numarasını 1 artır
V_PATCH=$((V_PATCH + 1))
SUGGESTED_VERSION="v$V_MAJOR.$V_MINOR.$V_PATCH"

# 4. Kullanıcıya onayla veya yeni yaz
echo "Önerilen yeni versiyon: $SUGGESTED_VERSION"
read -p "Onaylıyor musunuz? (Enter veya yeni versiyon yazın): " NEW_VERSION

# Eğer kullanıcı boş geçerse önerileni kullan
if [ -z "$NEW_VERSION" ]; then
    NEW_VERSION=$SUGGESTED_VERSION
fi

# 5. Commit mesajını al
read -p "Commit mesajını girin: " MESSAGE

# İşlemleri başlat
git add .
git commit -m "$MESSAGE"
git push origin main
git tag $NEW_VERSION
git push origin $NEW_VERSION

echo "✅ Başarıyla yayınlandı: $NEW_VERSION"