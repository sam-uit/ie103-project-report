#!/usr/bin/env node

// ============================================================================
// BOOKING MANAGEMENT SYSTEM - CROSS-PLATFORM START SCRIPT
// ============================================================================

import { spawn } from 'child_process';
import { existsSync } from 'fs';
import { copyFile } from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Colors for terminal output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
};

const log = {
  info: (msg) => console.log(`${colors.blue}ℹ${colors.reset} ${msg}`),
  success: (msg) => console.log(`${colors.green}✓${colors.reset} ${msg}`),
  warn: (msg) => console.log(`${colors.yellow}⚠${colors.reset} ${msg}`),
  error: (msg) => console.log(`${colors.red}✗${colors.reset} ${msg}`),
  title: (msg) => console.log(`\n${colors.cyan}${msg}${colors.reset}\n`),
};

// ============================================================================
// CHECK ENVIRONMENT
// ============================================================================

async function checkEnvironment() {
  log.title('🔍 Checking environment...');

  // Check Node.js
  const nodeVersion = process.version;
  log.success(`Node.js ${nodeVersion}`);

  // Check npm
  try {
    const { stdout } = await execCommand('npm', ['-v']);
    log.success(`npm ${stdout.trim()}`);
  } catch (error) {
    log.error('npm is not installed');
    process.exit(1);
  }
}

// ============================================================================
// CHECK DEPENDENCIES
// ============================================================================

async function checkDependencies() {
  log.title('📦 Checking dependencies...');

  const frontendModules = path.join(__dirname, 'node_modules');

  if (!existsSync(frontendModules)) {
    log.warn('Dependencies not found. Installing using workspaces...');
    await execCommand('npm', ['install'], { cwd: __dirname });
    log.success('All dependencies installed via workspaces');
  } else {
    log.success('Dependencies found');
  }
}

// ============================================================================
// CHECK CONFIGURATION
// ============================================================================

async function checkConfiguration() {
  log.title('⚙️  Checking configuration files...');

  const frontendEnv = path.join(__dirname, 'frontend', '.env');
  const frontendEnvExample = path.join(__dirname, 'frontend', '.env.example');
  const backendEnv = path.join(__dirname, 'backend', '.env');
  const backendEnvExample = path.join(__dirname, 'backend', '.env.example');

  // Check frontend .env
  if (!existsSync(frontendEnv)) {
    log.warn('Frontend .env not found. Copying from frontend/.env.example...');
    await copyFile(frontendEnvExample, frontendEnv);
    log.success('Frontend .env created');
  } else {
    log.success('Frontend .env found');
  }

  // Check backend .env
  if (!existsSync(backendEnv)) {
    log.warn('Backend .env not found. Copying from backend/.env.example...');
    await copyFile(backendEnvExample, backendEnv);
    log.success('Backend .env created');
    log.warn('⚠️  Please configure backend/.env with your database credentials');
  } else {
    log.success('Backend .env found');
  }
}

// ============================================================================
// START SERVERS
// ============================================================================

async function startServers() {
  log.title('🚀 Starting servers...');
  console.log(`${colors.green}Frontend:${colors.reset} http://localhost:5174`);
  console.log(`${colors.green}Backend:${colors.reset}  http://localhost:3000`);
  console.log(`\n${colors.yellow}Press Ctrl+C to stop both servers${colors.reset}\n`);

  const isWindows = process.platform === 'win32';
  const npmCmd = isWindows ? 'npm.cmd' : 'npm';

  // Start both using workspace commands
  const backend = spawn(npmCmd, ['run', 'dev', '--workspace=backend'], {
    cwd: __dirname,
    stdio: 'inherit',
    shell: true,
  });

  // Give backend time to start
  await sleep(2000);

  // Start frontend
  const frontend = spawn(npmCmd, ['run', 'dev', '--workspace=frontend'], {
    cwd: __dirname,
    stdio: 'inherit',
    shell: true,
  });

  // Handle exit
  const cleanup = () => {
    log.info('Shutting down servers...');
    backend.kill();
    frontend.kill();
    process.exit(0);
  };

  process.on('SIGINT', cleanup);
  process.on('SIGTERM', cleanup);

  // Wait for both processes
  await Promise.all([
    new Promise((resolve) => backend.on('close', resolve)),
    new Promise((resolve) => frontend.on('close', resolve)),
  ]);
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

function execCommand(command, args = [], options = {}) {
  return new Promise((resolve, reject) => {
    const proc = spawn(command, args, { ...options, shell: true });
    let stdout = '';
    let stderr = '';

    if (proc.stdout) {
      proc.stdout.on('data', (data) => {
        stdout += data.toString();
      });
    }

    if (proc.stderr) {
      proc.stderr.on('data', (data) => {
        stderr += data.toString();
      });
    }

    proc.on('close', (code) => {
      if (code === 0) {
        resolve({ stdout, stderr });
      } else {
        reject(new Error(`Command failed with code ${code}: ${stderr}`));
      }
    });

    proc.on('error', reject);
  });
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// ============================================================================
// MAIN
// ============================================================================

async function main() {
  console.log(`
╔════════════════════════════════════════════╗
║                                            ║
║   BOOKING MANAGEMENT SYSTEM                ║
║   Full Stack Application Starter           ║
║                                            ║
╚════════════════════════════════════════════╝
  `);

  try {
    await checkEnvironment();
    await checkDependencies();
    await checkConfiguration();
    await startServers();
  } catch (error) {
    log.error(`Failed to start: ${error.message}`);
    process.exit(1);
  }
}

main();
