From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Aug 2010 18:03:51 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Cache some system inodes of other
	nodes.
In-Reply-To: <20100812094350.GB6561@mail.oracle.com>
References: <1281603796-3867-1-git-send-email-tao.ma@oracle.com>
	<20100812094350.GB6561@mail.oracle.com>
Message-ID: <4C6499F7.8080509@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 08/12/2010 02:43 AM, Joel Becker wrote:
> On Thu, Aug 12, 2010 at 05:03:16PM +0800, Tao Ma wrote:
>> In ocfs2, we now only cache the inodes for global system file
>> and the system inodes for our own slot. But we have some cases
>> that we may need to access system inodes of other nodes, such
>> as orphan scan, inode steal etc.
>
> 	I don't see why you don't extend the existing cache and make one
> cache.  Make it live the lifetime of the filesystem.  No real reason to
> a) have to caches or b) limit the system inodes we might cache.  If we
> don't have the lock we're going to re-read them anyway.

Yeah... I have to agree. Will make it more readable.

enum {
         BAD_BLOCK_SYSTEM_INODE = 0,
         GLOBAL_INODE_ALLOC_SYSTEM_INODE,
         SLOT_MAP_SYSTEM_INODE,
#define OCFS2_FIRST_ONLINE_SYSTEM_INODE SLOT_MAP_SYSTEM_INODE
         HEARTBEAT_SYSTEM_INODE,
         GLOBAL_BITMAP_SYSTEM_INODE,
         USER_QUOTA_SYSTEM_INODE,
         GROUP_QUOTA_SYSTEM_INODE,
#define OCFS2_LAST_GLOBAL_SYSTEM_INODE GROUP_QUOTA_SYSTEM_INODE
#define OCFS2_FIRST_LOCAL_SYSTEM_INODE ORPHAN_DIR_SYSTEM_INODE
         ORPHAN_DIR_SYSTEM_INODE,
         EXTENT_ALLOC_SYSTEM_INODE,
         INODE_ALLOC_SYSTEM_INODE,
         JOURNAL_SYSTEM_INODE,
         LOCAL_ALLOC_SYSTEM_INODE,
         TRUNCATE_LOG_SYSTEM_INODE,
         LOCAL_USER_QUOTA_SYSTEM_INODE,
         LOCAL_GROUP_QUOTA_SYSTEM_INODE,
         NUM_SYSTEM_INODES
};
#define NUM_LOCAL_SYSTEM_INODES (NUM_SYSTEM_INODES - 
OCFS2_FIRST_LOCAL_SYSTEM_INODE)

struct ocfs2_super {
...
         struct inode *global_system_inodes[OCFS2_LAST_GLOBAL_SYSTEM_INODE];
         struct inode **local_system_inodes;
...
};

local_system_inodes = kzalloc(sizeof(struct inode *) * osb->num_slots *
                             NUM_LOCAL_SYSTEM_INODES;

         /* avoid the lookup if cached in local system file array */
         if (is_in_system_inode_array(osb, type, slot))
                 arr = &(osb->system_inodes[type]);

change to:

         if (is_global_system_inode(type)
                 arr = &(osb->global_system_inodes[type]);
         else {
                 BUG_ON(slot == OCFS2_INVALID_SLOT);
                 BUG_ON(type < OCFS2_FIRST_LOCAL_SYSTEM_INODE ||
                         type > LOCAL_GROUP_QUOTA_SYSTEM_INODE);
                 tmp = (slot * NUM_LOCAL_SYSTEM_INODES) +
                       (type - OCFS2_FIRST_LOCAL_SYSTEM_INODE);
                 arr = &(osb->local_system_inodes[tmp];
         }

How does this look?

The only downside is that the kzmalloc for more than 64 slots will
require more than a page on 64-bit systems. But that should be ok.

Sunil
