#!/usr/bin/env python

import yaml
import glob
import subprocess

def run_command(command, silently=True):
    if silently:
        command += '2>&1 >/dev/null'

    return subprocess.call(command, shell=True)

def should_install(cond_unless):
    for c in cond_unless:
        if subprocess.call(c + ' > /dev/null', shell=True) is not 0:
            return True

    return False

def ensure_depends(packages):
    for package in packages:
        print('    Checking {} is installed...'.format(package))
        command = 'apt list --installed | grep -q ' + package + '/'
        if subprocess.call(command, shell=True) is not 0:
            print('    Install {} ...'.format(package))
            subprocess.call('sudo apt -y install ' + package + '>/dev/null', shell=True)

def install(commands):
    command_lines = ' && '.join(commands)
    subprocess.call(command_lines, shell=True)

def extra(commands):
    for command in commands:
        subprocess.call(command, shell=True)

def main():
    files = glob.glob('./packages/*.yml')
    for file in files:
        config = yaml.load(open(file))
        print('======================')
        print(file)
        print('======================')

        if 'install' in config and not config['install']:
            print('Not install for "install" flag')
            continue

        if 'unless' in config and not should_install(config['unless']):
            print('Not install {} for cond: {}'.format(file, config['unless']))
            continue

        print('Installing {}...'.format(file))
        if 'depends' in config:
            ensure_depends(config['depends'])

        if 'commands' in config:
            install(config['commands'])

        if 'extra' in config:
            extra(extra)

if __name__ == '__main__':
    main()
