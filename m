From: Zach Brown <zach.brown@oracle.com>
Date: Mon, 19 Jun 2006 12:39:26 -0700
Subject: [Ocfs2-devel] [tytso@thunk.org: [RFC] [PATCH 1/8] inode_diet:
 Replace inode.u.generic_ip with inode.i_private]
In-Reply-To: <20060619154805.GP29684@ca-server1.us.oracle.com>
References: <20060619154805.GP29684@ca-server1.us.oracle.com>
Message-ID: <4496FD6E.4020902@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> I note that OCFS2 uses generic_ip only one place, in debug code:
> 
> ocfs2_dlm_debug_open():
> 	1998         osb = (struct ocfs2_super *) inode->u.generic_ip;
> 
> However, we never set it!  This leads me to believe this is stale code.

That's the dlm debugging fops getting the osb off of the debugfs inode's
generic_ip which was set with debugfs_create_file().

- z
