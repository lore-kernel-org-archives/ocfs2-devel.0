From: Li Dongyang <lidongyang@novell.com>
Date: Fri, 9 Apr 2010 10:32:42 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: alloc orphaned inode in
	ocfs2_symlink
In-Reply-To: <20100408211222.GC20661@mail.oracle.com>
References: <201004080913.08494.lidongyang@novell.com>
	<20100408211222.GC20661@mail.oracle.com>
Message-ID: <201004091032.42548.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Friday 09 April 2010 05:12:22 Joel Becker wrote:
> On Thu, Apr 08, 2010 at 09:13:08AM +0800, Li Dongyang wrote:
> > alloc the inode orphaned in ocfs2_symlink so we can delete the inode
> > in the iput if we meet errors with the inode, e.g. ocfs2_add_inode_data.
> > or ocfs2_query_inode_wipe will complain the inode is not orphaned on
> > disk.
> 
> 	Huh.  At first I was sure this was ok, as the iput is sanely
> killing the inode.  But you're right, the wipe code expects it to be
> orphaned.
> 	Do you have a testcase for this?
> 
> Joel
> 
I found it while trying to reproduce the bug fixed by the patch ocfs2: avoid 
direct write if we fall back to buffered.
In my case, just run fsstress on a single node, and when the ocfs2 partition 
is out of space, ocfs2_add_inode_data will return -ENOSPC and then will 
trigger the error in ocfs2_query_inode_wipe
