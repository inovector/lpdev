#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

const COMPLETION_FILE = path.join(__dirname, '..', 'completions', 'lpdev-completion.bash');
const SHELL_RC_FILES = {
  bash: ['.bashrc', '.bash_profile'],
  zsh: ['.zshrc']
};

function detectShell() {
  const shell = process.env.SHELL || '';
  if (shell.includes('zsh')) return 'zsh';
  if (shell.includes('bash')) return 'bash';
  return 'bash';
}

function getShellRcFile() {
  const homeDir = os.homedir();
  const shell = detectShell();
  const rcFiles = SHELL_RC_FILES[shell] || SHELL_RC_FILES.bash;
  
  for (const rcFile of rcFiles) {
    const filePath = path.join(homeDir, rcFile);
    if (fs.existsSync(filePath)) {
      return filePath;
    }
  }
  
  return path.join(homeDir, rcFiles[0]);
}

function installCompletion() {
  if (!fs.existsSync(COMPLETION_FILE)) {
    console.log('Completion file not found. Skipping completion installation.');
    return;
  }

  const rcFile = getShellRcFile();
  const completionLine = `source ${COMPLETION_FILE}`;
  
  try {
    let rcContent = '';
    if (fs.existsSync(rcFile)) {
      rcContent = fs.readFileSync(rcFile, 'utf8');
    }
    
    if (rcContent.includes(completionLine)) {
      console.log('✓ Bash completion already installed');
      return;
    }
    
    const completionBlock = `\n# lpdev bash completion\nif [ -f "${COMPLETION_FILE}" ]; then\n  ${completionLine}\nfi\n`;
    
    fs.appendFileSync(rcFile, completionBlock);
    console.log(`✓ Bash completion installed to ${rcFile}`);
    console.log('  Run "source ' + rcFile + '" or restart your terminal to enable completion');
    
  } catch (error) {
    console.log('⚠ Could not install bash completion automatically');
    console.log(`  To enable completion manually, add this to your ${path.basename(rcFile)}:`);
    console.log(`  source ${COMPLETION_FILE}`);
  }
}

function main() {
  console.log('\n📦 Installing lpdev...\n');
  
  if (process.platform === 'win32') {
    console.log('⚠ Windows is not fully supported. Some features may not work correctly.');
    return;
  }
  
  installCompletion();
  
  console.log('\n✅ lpdev installed successfully!');
  console.log('\nGet started with: lpdev --help\n');
}

if (require.main === module) {
  main();
}