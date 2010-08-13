From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 13 Aug 2010 08:49:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Cache some system inodes of other
	nodes.
In-Reply-To: <20100812094350.GB6561@mail.oracle.com>
References: <1281603796-3867-1-git-send-email-tao.ma@oracle.com>
	<20100812094350.GB6561@mail.oracle.com>
Message-ID: <4C64968C.6030403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Aug 12, 2010 at 05:03:16PM +0800, Tao Ma wrote:
>   
>> In ocfs2, we now only cache the inodes for global system file
>> and the system inodes for our own slot. But we have some cases
>> that we may need to access system inodes of other nodes, such
>> as orphan scan, inode steal etc.
>>     
>
> 	I don't see why you don't extend the existing cache and make one
> cache.  Make it live the lifetime of the filesystem.  No real reason to
> a) have to caches or b) limit the system inodes we might cache.  If we
> don't have the lock we're going to re-read them anyway.
>   
You want me to do:
-        struct inode *system_inodes[NUM_SYSTEM_INODES];
+        struct inode **system_inodes

and do
+    system_inodes = kzalloc((NUM_SYSTEM_INODES - 
GROUP_QUOTA_SYSTEM_INODE) *
+                                            sizeof(struct inode *) * 
osb->max_slots);

So we will save other system inodes such as local_alloc, truncate_log, 
local_user_quota and local_group_quota and
actually we will never touch these inodes in the most cases(well, 
recovery is an exception). So why cache them
if in the most case they will not be used?
In http://oss.oracle.com/pipermail/ocfs2-devel/2010-June/006562.html, 
Goldwyn try to reduce our size by just
moving the postion of some fields, so I think we should save these 
memory for the kernel. :)

Regards,
Tao
