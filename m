From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 29 14:28:24 2004
Subject: [Ocfs2-devel] About Mark's advice on bug 48
In-Reply-To: <4063DB4B.6060000@intel.com>
References: <4063DB4B.6060000@intel.com>
Message-ID: <20040329202819.GV10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 26, 2004 at 03:27:07PM +0800, Sonic Zhang wrote:
> Hi Mark,
> 
> Finally, I found the second halt is caused by starvation when routine 
> ocfs_joutnal_set_unmounted() acquiring the lock osb->publish_lock. In 
> thread ocfs_volume_thread(), the delta jiffies to sleep between up() and 
> down() in schedule_timeout() is too short. Routine 
> ocfs_joutnal_set_unmounted() has no chance to check if lock 
> osb->publish_lock is released  between it is releases and reacquired by 
> thread ocfs_volume_thread. So routine ocfs_journal_set_unmounted() 
> always waits in loop. After I change the delta jiffies from 50 to 500, 
> kernel 2.6 won't halt when it reboots after  a OCFS volume is mounted.
*ouch* it seems that jiffies changed between 2.4 and 2.6 -- the code as is
will be heartbeating *way* to often, in fact prolly even swamping your disk!
Ok, I need to take a closer look at this (I believe we use jiffies in other
places too!), but good catch!

> I also add a line to release the lock in a branch to  symbol "finally". 
> This may remove latent dead lock. In addition, I clear the reference 
> point OcfsIpcCtxt.task before thread ocfs_recv_thread() exits. This 
> prevents invalid access to the task structure in routine 
> ocfs_dismount_volume() when rebooting.
This is good, though setting OcfsIpcCtxt.task is prolly redundant as it's
set in dismount volume, but I've always wondered why we didn't just set it
there.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
