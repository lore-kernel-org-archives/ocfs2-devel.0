From: Manish Singh <manish.singh@oracle.com>
Date: Mon Aug 15 19:35:51 2005
Subject: [Ocfs2-devel] ocfs2-1.0.1 ebuilds
In-Reply-To: <4301298C.4090803@yu.net>
References: <42F800E5.2080706@yu.net> <43010710.2060800@yu.net>
	<20050815221450.GA29912@ca-server1.us.oracle.com>
	<4301175A.6050101@oracle.com> <4301298C.4090803@yu.net>
Message-ID: <20050816003548.GB9031@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 16, 2005 at 01:47:24AM +0200, lazar obradovic wrote:
> Sunil Mushran wrote:
> 
> >Maybe a better idea would be to have a generic ocfs2 mount/umount
> >service as follows:
> >http://oss.oracle.com/bugzilla/attachment.cgi?id=162
> >This one is for SLES9. Maybe someone can write one up for gentoo.
> 
> ocfs2 should be added to gentoo's list of network filesystems (I forgot 
> to open a bug on baselayout, just did it now - gentoo bz#102659 ), so 
> netmount script will take care of mounting and unmounting it.
> 
> However, if you decide to stop ocfs2 cluster by other means than 
> rebooting, it's initscript should unmount every ocfs2 mountpoint. Piece 
> of script I copied from gentoo's netmount is far more complex, since 
> 'umount -at ocfs2' might fail if someone is still using files on ocfs2. 
> It adds a extra layer, killing all the processes that have open files on 
> the mountpoint one is trying to unmount, so I find it a better solution.

The cluster stack and the filesystem stuff should be distinct. If an fs
is still mounted, trying to stop the cluster service should simply fail,
and not try to unmount anything.

Killing all processes will screw up someone trying to use ocfs2 as their
root filesystem, so that's a bad idea.
 
-Manish
