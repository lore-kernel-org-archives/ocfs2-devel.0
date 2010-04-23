From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 23 Apr 2010 12:45:24 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: use
	OCFS2_INODE_SKIP_ORPHAN_DIR in ocfs2_symlink error path
In-Reply-To: <201004221611.25402.lidongyang@novell.com>
References: <201004221611.25402.lidongyang@novell.com>
Message-ID: <20100423194524.GP17187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 22, 2010 at 04:11:25PM +0800, Li Dongyang wrote:
> mark the inode with flag OCFS2_INODE_SKIP_ORPHAN_DIR when we meet
> an error after allocating one, so that we can kill the inode.
> 
> Signed-off-by: Li Dongyang <lidongyang@novell.com>

Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
