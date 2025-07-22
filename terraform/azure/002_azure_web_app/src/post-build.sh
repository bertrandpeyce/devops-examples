#!/bin/bash
echo "🎯 Starting post-build verification..."

# Vérifier que node_modules existe
if [ -d "node_modules" ]; then
	echo "✅ node_modules directory exists"
else
	echo "❌ node_modules directory not found"
	exit 1
fi

echo "🔍 Vérification des dépendances installées..."

echo "📦 Dependencies trouvées :"
ls node_modules/ | grep -E "^(express|mssql|redis|applicationinsights|dotenv|helmet|express-rate-limit)$" || echo "⚠️ Certaines dependencies manquent"

echo "🚫 DevDependencies (ne devraient PAS être là) :"
if ls node_modules/ | grep -E "^(eslint|prettier)$"; then
	echo "⚠️ DevDependencies détectées en production !"
else
	echo "✅ Aucune devDependency trouvée (correct)"
fi

echo "📊 Nombre total de packages installés :"
ls node_modules/ | wc -l

# Créer un manifest de build
cat >build-info.json <<EOF
{
  "buildTime": "$(date -Iseconds)",
  "nodeVersion": "$(node --version)",
  "npmVersion": "$(npm --version)", 
  "environment": "$NODE_ENV",
  "packagesCount": $(ls node_modules/ | wc -l)
}
EOF

echo "📄 Build manifest créé"
echo "✅ Post-build script completed successfully!"
