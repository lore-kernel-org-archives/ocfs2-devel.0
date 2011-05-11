From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 10 May 2011 18:38:17 -0700
Subject: [Ocfs2-devel] [Ocfs2-users] ocfs or configfs bug ?
In-Reply-To: <4DAE26BA.3010203@oracle.com>
References: <4DADA228.5050209@bull.net> <20110419194840.GA27826@noexit>
	<4DAE26BA.3010203@oracle.com>
Message-ID: <4DC9E889.3080008@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 04/19/2011 05:20 PM, Sunil Mushran wrote:
> On 04/19/2011 12:48 PM, Joel Becker wrote:
>> 	You're too late here.  This is in the echo process (bash,
>> really).  getdents() isn't happening.
>> 	The problem is almost certainly in configfs.  It's a race
>> between setup and teardown of the virtual attribute files.  If anyone
>> else has a cycle to look at it, great, otherwise I'll try to get to it
>> later this week.
>
> So we ran into it internally. This is what I wrote in the bug.
>
> /@ The matching code in configfs_readir() is:/
> /@     name = configfs_get_name(next);/
> /@     len = strlen(name);/
> /@     if (next->s_dentry)/
> /@            ino = next->s_dentry->d_inode->i_ino; <===/
> /@     else/
> /@            ino = iunique(configfs_sb, 2);/
> /@ ./
> /@     if (filldir(dirent, name, len, filp->f_pos, ino,/
> /@                 dt_type(next)) < 0)/
> /@            return 0;/
> /@ ./
> /@ The oops indicates that next->s_dentry->d_inode is NULL./
>
> Joel, does this give you any clues?
>
> BTW, thanks for the testcase. And yes, I can reproduce it easily.

configfs_readdir() is racing configfs_d_delete(). And I cannot
see how we can use the existing spinlock to prevent the race.

sysfs uses a coarse lock sysfs_mutex to prevent against this.
I think we should do the same in configfs.

Comments?

=============================================
commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
Author: Tejun Heo <htejun@gmail.com>
Date:   Thu Jun 14 04:27:23 2007 +0900

     sysfs: use sysfs_mutex to protect the sysfs_dirent tree

     As kobj sysfs dentries and inodes are gonna be made reclaimable,
     i_mutex can't be used to protect sysfs_dirent tree.  Use sysfs_mutex
     globally instead.  As the whole tree is protected with sysfs_mutex,
     there is no reason to keep sysfs_rename_sem.  Drop it.

     While at it, add docbook comments to functions which require
     sysfs_mutex locking.

     Signed-off-by: Tejun Heo <htejun@gmail.com>
     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
=============================================
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20110510/4219fe9b/attachment.html 
