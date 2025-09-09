#!/usr/bin/env node

function main() {
  console.log('\n📦 Installing lpdev...\n');
  
  if (process.platform === 'win32') {
    console.log('⚠ Windows is not fully supported. Some features may not work correctly.');
    return;
  }
  
  console.log('\n✅ lpdev installed successfully!');
  console.log('\nGet started with: lpdev --help\n');
}

if (require.main === module) {
  main();
}