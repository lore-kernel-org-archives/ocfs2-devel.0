From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 8 Apr 2010 14:12:22 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: alloc orphaned inode in
 ocfs2_symlink
In-Reply-To: <201004080913.08494.lidongyang@novell.com>
References: <201004080913.08494.lidongyang@novell.com>
Message-ID: <20100408211222.GC20661@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 08, 2010 at 09:13:08AM +0800, Li Dongyang wrote:
> alloc the inode orphaned in ocfs2_symlink so we can delete the inode
> in the iput if we meet errors with the inode, e.g. ocfs2_add_inode_data.
> or ocfs2_query_inode_wipe will complain the inode is not orphaned on disk.

	Huh.  At first I was sure this was ok, as the iput is sanely
killing the inode.  But you're right, the wipe code expects it to be
orphaned.
	Do you have a testcase for this?

Joel

-- 

Life's Little Instruction Book #497

	"Go down swinging."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
