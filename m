From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Mar 25 13:10:44 2004
Subject: [Ocfs2-devel] About Mark's advice on bug 48
In-Reply-To: <4062A5B5.3000205@intel.com>
References: <4062A5B5.3000205@intel.com>
Message-ID: <20040325191037.GN10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 25, 2004 at 05:26:13PM +0800, Sonic Zhang wrote:
> Hi Mark,
> 
>    I change a little to your patch. I remove the signal prcess code, 
> because kernel thread doesn't receive signals by default. 
Ours does! If you look in ocfs_daemonize, you'll see the following:
	/* Block all signals except SIGKILL, SIGSTOP, SIGHUP and SIGINT */
#ifdef HAVE_NPTL
       	spin_lock_irq (&current->sighand->siglock);
       	tmpsig = current->blocked;
       	siginitsetinv (&current->blocked, SHUTDOWN_SIGS);
	recalc_sigpending ();
	spin_unlock_irq (&current->sighand->siglock);

You need that signal processing bit, to dequeue pending signals from our
task. Otherwise, ocfs_wait will trigger the signal_pending condition and
return -EINTR on every call!

>This patch 
> fixes the halt problem in thread ocfs_submit_thread(). But, there is 
> another dead lock on osb->publish_lock in thread  ocfs_volume_thread() 
> and routine ocfs_journal_set_unmounted(). I am tracking this problem now.
I'd like more info on this.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
