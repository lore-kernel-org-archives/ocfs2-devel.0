From: Adrian Bunk <bunk@kernel.org>
Date: Thu Oct 11 12:40:44 2007
Subject: [Ocfs2-devel] ocfs2: inconsequent NULL checking
Message-ID: <20070918181404.GA16401@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking in 
fs/ocfs2/dlmglue.c:

<--  snip  -->

...
int ocfs2_meta_lock_atime(struct inode *inode,
                          struct vfsmount *vfsmnt,
                          int *level)
{
...
                if (ocfs2_should_update_atime(inode, vfsmnt))
                        ocfs2_update_inode_atime(inode, bh);
                if (bh)
                        brelse(bh);
...

<--  snip  -->

Since commit c11e9fafb398411af7558fca913c2fa4a10b1f48
ocfs2_update_inode_atime() contains an unconditional
dereference of "bh".

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
