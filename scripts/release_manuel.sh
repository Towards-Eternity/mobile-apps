#!/bin/bash

# Kullanıcıdan versiyon numarasını al
echo "Versiyon numarasını girin (Örn: v1.2.5):"
read VERSION

# Kullanıcıdan commit mesajını al
echo "Commit mesajını girin:"
read MESSAGE

git add .
git commit -m "$MESSAGE"
git push origin main
git tag $VERSION
git push origin $VERSION

echo "✅ İşlem Tamam! $VERSION sürümü GitHub'a gönderildi."