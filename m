From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Nov 21 14:29:38 2006
Subject: [Ocfs2-devel] Memory leak in ocfs2/dlm?
In-Reply-To: <45636CC7.4000600@telefonica.de>
References: <45636CC7.4000600@telefonica.de>
Message-ID: <20061121222933.GH30647@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On Tue, Nov 21, 2006 at 10:16:55PM +0100, Jan-Benedict Glaw wrote:
> [root@lnxp-1038:/backend1]$ cat /proc/slab_allocators | egrep '(size.512|ocfs2_inode_cache)' | grep ocfs | sort -k 2 -n
> size-512: 1 o2hb_heartbeat_group_make_item+0x1b/0x79 [ocfs2_nodemanager]
> size-512: 1 o2hb_map_slot_data+0x22/0x2fa [ocfs2_nodemanager]
> size-512: 1 ocfs2_initialize_super+0x55e/0xd7f [ocfs2]
> size-512: 9 ocfs2_dentry_attach_lock+0x2d1/0x423 [ocfs2]
> ocfs2_inode_cache: 20 ocfs2_alloc_inode+0x13/0x29 [ocfs2]
> size-512: 52379 dlm_new_lockres+0x22/0x189 [ocfs2_dlm]
This is almost certainly a known bug with lock migration in the ocfs2 dlm.
Kurt's working on a patch for this, which should be up in ocfs2.git very
soon now. Unfortunately a number of folks in the US are on vacation until
next week, so we probably won't see it until then at the latest :/
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
