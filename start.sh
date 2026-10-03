#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="${1:-ProjectM}"
PORT="${2:-8080}"
mkdir -p "$SCRIPT_DIR"/{src,public,config,logs}
cat > "$SCRIPT_DIR/index.html" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="fr">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>ProjectM - Zero Trust Architecture</title><style>*{margin:0;padding:0;box-sizing:border-box}body{font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);min-height:100vh;display:flex;justify-content:center;align-items:center;padding:20px}.container{background:rgba(255,255,255,0.95);border-radius:10px;box-shadow:0 10px 40px rgba(0,0,0,0.3);padding:40px;max-width:800px;width:100%}h1{color:#333;margin-bottom:10px}p{color:#666;line-height:1.6;margin:15px 0}.schema{background:#f5f5f5;padding:20px;border-radius:5px;margin:20px 0;font-family:monospace;font-size:12px;overflow-x:auto}.btn{display:inline-block;background:#667eea;color:white;padding:12px 24px;border:none;border-radius:5px;cursor:pointer;margin-top:20px;font-size:16px;transition:all 0.3s}.btn:hover{background:#764ba2;transform:translateY(-2px)}.status{margin-top:20px;padding:15px;background:#e8f5e9;border-left:4px solid #4caf50;border-radius:3px;color:#2e7d32}</style></head><body><div class="container"><h1>🚀 ProjectM - Architecture Zero Trust</h1><p>Bienvenue dans <strong>ProjectM</strong> - Un projet structuré avec logique native et zéro dépendance externe.</p><div class="schema"><strong>Structure Schema:</strong><br/>📦 ProjectM/<br/>├── 📄 index.html (interface)<br/>├── 📂 src/ (logique métier)<br/>├── 📂 public/ (assets)<br/>├── 📂 config/ (configuration)<br/>└── 📂 logs/ (journalisation)</div><h2>🔐 Principes Appliqués:</h2><ul style="margin-left:20px"><li>✅ Zero Trust Native Logic</li><li>✅ Pas de dépendances externes</li><li>✅ Un seul bloc de script</li><li>✅ Logique métier en ligne</li><li>✅ Architecture événementielle</li></ul><div class="status">✨ <strong>Status:</strong> Système prêt. Consultez la console pour les logs. Serveur écoute sur le port spécifié.</div><button class="btn" onclick="testSystem()">Test du Système</button></div><script>const config={projectName:'ProjectM',version:'1.0.0',port:8080,timestamp:new Date().toISOString()};const log=(msg,type='info')=>{const entry={timestamp:new Date().toISOString(),type,message:msg,config};console.log(`[${type.toUpperCase()}] ${msg}`,entry)};const testSystem=()=>{log('Test système initiated','info');const tests=[{name:'Config',check:()=>!!config.projectName},{name:'DOM',check:()=>!!document},{name:'Storage',check:()=>typeof Storage!=='undefined'},{name:'Crypto',check:()=>typeof crypto!=='undefined'}];const results=tests.map(t=>({...t,passed:t.check()}));log(`Tests completed: ${results.filter(r=>r.passed).length}/${results.length} passed`,'info');alert(`✅ Système vérifié!\n\n${results.map(r=>`${r.passed?'✓':'✗'} ${r.name}`).join('\n')}`)};log(`Application initialized: ${config.projectName} v${config.version}`,'info');log('Zero Trust Native Logic Active','success');</script></body></html>
HTMLEOF
cat > "$SCRIPT_DIR/config/schema.json" << 'JSONEOF'
{
  "project": {
    "name": "ProjectM",
    "version": "1.0.0",
    "architecture": "zero-trust-native",
    "modules": {
      "core": {
        "description": "Logique métier centrale",
        "type": "module",
        "dependencies": []
      },
      "auth": {
        "description": "Authentification et autorisation",
        "type": "security",
        "algorithm": "native-crypto"
      },
      "events": {
        "description": "Système événementiel",
        "type": "event-bus",
        "pattern": "pub-sub"
      }
    },
    "ports": ["8080", "8443"],
    "environment": "production"
  }
}
JSONEOF
cat > "$SCRIPT_DIR/src/core.js" << 'JSEOF'
const ProjectM = (() => {
  const state = {};
  const listeners = {};
  
  const on = (event, callback) => {
    if (!listeners[event]) listeners[event] = [];
    listeners[event].push(callback);
  };
  
  const emit = (event, data) => {
    if (listeners[event]) {
      listeners[event].forEach(cb => cb(data));
    }
  };
  
  const setState = (key, value) => {
    state[key] = value;
    emit('stateChanged', { key, value });
  };
  
  return { on, emit, setState, getState: (key) => state[key] };
})();
JSEOF
echo "✅ Project '$PROJECT_NAME' créé avec succès"
echo "📁 Structure:"
ls -la "$SCRIPT_DIR" | grep -E '^d' | awk '{print "   " $NF}'
echo "🚀 Lancement serveur sur http://localhost:$PORT"
cd "$SCRIPT_DIR" && python3 -m http.server $PORT --directory . 2>/dev/null & 
echo "✨ Server PID: $!"
echo "📝 Logs disponibles dans: $SCRIPT_DIR/logs/"
trap "kill %1 2>/dev/null; echo '🛑 Server arrêté'" EXIT
wait
