From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 23 Apr 2010 10:30:28 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: add
	OCFS2_INODE_SKIP_ORPHAN_DIR flag and honor it in the inode wipe code
In-Reply-To: <201004221611.19307.lidongyang@novell.com>
References: <201004221611.19307.lidongyang@novell.com>
Message-ID: <20100423173028.GN17187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 22, 2010 at 04:11:19PM +0800, Li Dongyang wrote:
> currently in the error path of ocfs2_symlink and ocfs2_mknod,
> we just call iput with the inode we failed with, but the inode wipe code will
> complain because we don't add the inode to orphan dir.
> however, adding the inode to orphan dir requires additional transaction 
> credits
> which is too heavy for an error path, so we just use the
> OCFS2_INODE_SKIP_ORPHAN_DIR flag and tell inode wipe code to go on with it.
> 
> Signed-off-by: Li Dongyang <lidongyang@novell.com>

Ok, this looks great.

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
