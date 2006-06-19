From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 19 Jun 2006 08:48:05 -0700
Subject: [Ocfs2-devel] [tytso@thunk.org: [RFC] [PATCH 1/8] inode_diet:
	Replace inode.u.generic_ip with inode.i_private]
Message-ID: <20060619154805.GP29684@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Folks,
	Here in Ted's inode-diet patch, he renames inode->u.generic_ip
to inode->i_private.  I note that OCFS2 uses generic_ip only one place,
in debug code:

ocfs2_dlm_debug_open():
	1998         osb = (struct ocfs2_super *) inode->u.generic_ip;

However, we never set it!  This leads me to believe this is stale code.
Thoughts.

Joel


-- 

"Only a life lived for others is a life worth while."
							-Albert Einstein  

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
-------------- next part --------------
An embedded message was scrubbed...
From: Theodore Tso <tytso@thunk.org>
Subject: [RFC] [PATCH 1/8] inode_diet: Replace inode.u.generic_ip with
	inode.i_private
Date: Mon, 19 Jun 2006 11:20:04 -0400
Size: 34762
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20060619/1da41851/attachment-0001.mht
