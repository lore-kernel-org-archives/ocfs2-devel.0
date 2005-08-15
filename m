From: lazar obradovic <laza@yu.net>
Date: Mon Aug 15 18:46:11 2005
Subject: [Ocfs2-devel] ocfs2-1.0.1 ebuilds
In-Reply-To: <4301175A.6050101@oracle.com>
References: <42F800E5.2080706@yu.net> <43010710.2060800@yu.net>
	<20050815221450.GA29912@ca-server1.us.oracle.com>
	<4301175A.6050101@oracle.com>
Message-ID: <4301298C.4090803@yu.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:

> I have not seen the changes in code but the comments in the bug
> indicate they have to do with adding umounts in o2cb stop.

'init script' in bug report refers to new gentoo-style init script...
I added unmount to that one, not the original one... Please take a look 
at sys-fs/ocfs2-tools/files/ocfs2.init file in the attachment.

> Maybe a better idea would be to have a generic ocfs2 mount/umount
> service as follows:
> http://oss.oracle.com/bugzilla/attachment.cgi?id=162
> This one is for SLES9. Maybe someone can write one up for gentoo.

ocfs2 should be added to gentoo's list of network filesystems (I forgot 
to open a bug on baselayout, just did it now - gentoo bz#102659 ), so 
netmount script will take care of mounting and unmounting it.

However, if you decide to stop ocfs2 cluster by other means than 
rebooting, it's initscript should unmount every ocfs2 mountpoint. Piece 
of script I copied from gentoo's netmount is far more complex, since 
'umount -at ocfs2' might fail if someone is still using files on ocfs2. 
It adds a extra layer, killing all the processes that have open files on 
the mountpoint one is trying to unmount, so I find it a better solution.

> If so, please add it as an attachment to bug:
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=524
> Doc-ing this would be far easier.

Will do, as soon as I fix errors previously noted by manish.singh. I 
think this piece of code should also be usable on SLES and RHEL...

-- 
LO275-RIPE
