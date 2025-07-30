#!/usr/bin/env python3

"""
Codemagic Build Monitor
A comprehensive tool for monitoring and managing Codemagic builds
"""

import os
import sys
import json
import time
import argparse
from datetime import datetime
from pathlib import Path

try:
    import requests
    from rich.console import Console
    from rich.table import Table
    from rich.live import Live
    from rich.progress import Progress, SpinnerColumn, TextColumn
    from rich.panel import Panel
    from rich import box
except ImportError:
    print("Installing required dependencies...")
    os.system(f"{sys.executable} -m pip install requests rich")
    import requests
    from rich.console import Console
    from rich.table import Table
    from rich.live import Live
    from rich.progress import Progress, SpinnerColumn, TextColumn
    from rich.panel import Panel
    from rich import box

console = Console()

class CodemagicMonitor:
    def __init__(self):
        self.api_token = os.environ.get('CODEMAGIC_API_TOKEN')
        self.app_id = os.environ.get('CODEMAGIC_APP_ID')
        self.base_url = "https://api.codemagic.io"
        self.headers = {"x-auth-token": self.api_token} if self.api_token else {}
        
    def check_credentials(self):
        """Check if credentials are properly set"""
        if not self.api_token:
            console.print("[red]Error: CODEMAGIC_API_TOKEN not set[/red]")
            console.print("Run: ./scripts/monitor_builds.sh setup")
            return False
        if not self.app_id:
            console.print("[red]Error: CODEMAGIC_APP_ID not set[/red]")
            console.print("Run: ./scripts/monitor_builds.sh setup")
            return False
        return True
    
    def get_builds(self, limit=10):
        """Get recent builds"""
        if not self.check_credentials():
            return None
            
        url = f"{self.base_url}/builds?appId={self.app_id}&limit={limit}"
        response = requests.get(url, headers=self.headers)
        
        if response.status_code == 200:
            return response.json()['builds']
        else:
            console.print(f"[red]Error fetching builds: {response.status_code}[/red]")
            return None
    
    def get_build_details(self, build_id):
        """Get detailed information about a specific build"""
        if not self.check_credentials():
            return None
            
        url = f"{self.base_url}/builds/{build_id}"
        response = requests.get(url, headers=self.headers)
        
        if response.status_code == 200:
            return response.json()
        else:
            console.print(f"[red]Error fetching build details: {response.status_code}[/red]")
            return None
    
    def display_builds_table(self, builds):
        """Display builds in a formatted table"""
        table = Table(title="Recent Builds", box=box.ROUNDED)
        
        table.add_column("Status", style="cyan", width=12)
        table.add_column("Workflow", style="magenta")
        table.add_column("Branch", style="green")
        table.add_column("Started", style="yellow")
        table.add_column("Duration", style="blue")
        table.add_column("Build ID", style="dim")
        
        for build in builds:
            status = build['status']
            status_emoji = {
                'finished': '✅',
                'building': '🔨',
                'queued': '⏳',
                'failed': '❌',
                'canceled': '🚫'
            }.get(status, '❓')
            
            started = datetime.fromisoformat(build['startedAt'].replace('Z', '+00:00')) if build.get('startedAt') else None
            started_str = started.strftime('%Y-%m-%d %H:%M') if started else 'Not started'
            
            duration = build.get('duration', 0)
            duration_str = f"{duration // 60}m {duration % 60}s" if duration else "N/A"
            
            table.add_row(
                f"{status_emoji} {status}",
                build['workflow']['name'],
                build.get('branch', 'N/A'),
                started_str,
                duration_str,
                build['id']
            )
        
        console.print(table)
    
    def monitor_build_live(self, build_id):
        """Monitor a build in real-time"""
        if not self.check_credentials():
            return
        
        with Live(auto_refresh=True, refresh_per_second=0.5) as live:
            while True:
                build = self.get_build_details(build_id)
                if not build:
                    break
                
                # Create status panel
                status = build['status']
                status_color = {
                    'finished': 'green',
                    'building': 'yellow',
                    'queued': 'blue',
                    'failed': 'red',
                    'canceled': 'orange'
                }.get(status, 'white')
                
                content = f"""
[bold]Build ID:[/bold] {build['id']}
[bold]Status:[/bold] [{status_color}]{status}[/{status_color}]
[bold]Workflow:[/bold] {build['workflow']['name']}
[bold]Branch:[/bold] {build.get('branch', 'N/A')}
[bold]Started:[/bold] {build.get('startedAt', 'Not started')}
[bold]Duration:[/bold] {build.get('duration', 0) // 60}m {build.get('duration', 0) % 60}s
"""
                
                if build.get('message'):
                    content += f"\n[bold]Message:[/bold] {build['message']}"
                
                panel = Panel(content, title=f"Build Monitor - {build['workflow']['name']}", box=box.ROUNDED)
                live.update(panel)
                
                if status in ['finished', 'failed', 'canceled']:
                    break
                
                time.sleep(5)
        
        # Show final status
        if status == 'finished':
            console.print(f"\n[green]✅ Build completed successfully![/green]")
            
            # Show artifacts if any
            if build.get('artifacts'):
                console.print("\n[bold]Artifacts:[/bold]")
                for artifact in build['artifacts']:
                    console.print(f"  - {artifact['name']} ({artifact['size']} bytes)")
        elif status == 'failed':
            console.print(f"\n[red]❌ Build failed![/red]")
        elif status == 'canceled':
            console.print(f"\n[orange]🚫 Build canceled![/orange]")
    
    def watch_builds(self, interval=30):
        """Continuously watch for new builds"""
        if not self.check_credentials():
            return
        
        console.print(f"[green]Watching for builds (refresh every {interval}s)...[/green]")
        console.print("Press Ctrl+C to stop\n")
        
        last_build_id = None
        
        try:
            while True:
                builds = self.get_builds(limit=5)
                if builds:
                    current_build_id = builds[0]['id']
                    
                    if last_build_id and current_build_id != last_build_id:
                        console.print(f"\n[yellow]🔔 New build detected: {current_build_id}[/yellow]")
                        console.bell()
                    
                    last_build_id = current_build_id
                    
                    # Clear screen and show builds
                    console.clear()
                    console.print(f"[dim]Last updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}[/dim]\n")
                    self.display_builds_table(builds)
                
                time.sleep(interval)
                
        except KeyboardInterrupt:
            console.print("\n[yellow]Stopped watching builds[/yellow]")

def main():
    parser = argparse.ArgumentParser(description='Codemagic Build Monitor')
    subparsers = parser.add_subparsers(dest='command', help='Commands')
    
    # List builds command
    list_parser = subparsers.add_parser('list', help='List recent builds')
    list_parser.add_argument('-n', '--number', type=int, default=10, help='Number of builds to show')
    
    # Monitor build command
    monitor_parser = subparsers.add_parser('monitor', help='Monitor a specific build')
    monitor_parser.add_argument('build_id', help='Build ID to monitor')
    
    # Watch command
    watch_parser = subparsers.add_parser('watch', help='Watch for new builds')
    watch_parser.add_argument('-i', '--interval', type=int, default=30, help='Refresh interval in seconds')
    
    # Build details command
    details_parser = subparsers.add_parser('details', help='Get build details')
    details_parser.add_argument('build_id', help='Build ID')
    
    args = parser.parse_args()
    
    monitor = CodemagicMonitor()
    
    if args.command == 'list':
        builds = monitor.get_builds(limit=args.number)
        if builds:
            monitor.display_builds_table(builds)
    
    elif args.command == 'monitor':
        monitor.monitor_build_live(args.build_id)
    
    elif args.command == 'watch':
        monitor.watch_builds(interval=args.interval)
    
    elif args.command == 'details':
        build = monitor.get_build_details(args.build_id)
        if build:
            console.print(Panel(json.dumps(build, indent=2), title="Build Details", box=box.ROUNDED))
    
    else:
        parser.print_help()

if __name__ == '__main__':
    main()