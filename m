From: Coly Li <coly.li@suse.de>
Date: Thu, 22 Oct 2009 14:07:47 +0800
Subject: [Ocfs2-devel] [PATCH] indexed-dirs: fix brelse order in
 ocfs2_find_entry_dx(), v2
In-Reply-To: <4ADFF406.5010700@suse.de>
References: <4ADFF406.5010700@suse.de>
Message-ID: <4ADFF6B3.4000406@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Coly Li Wrote:
> In ocfs2_find_entry_dx(), if ocfs2_read_inode_block() failed, both di_bh and dx_root_bh are both released. In this case,
> for dx_root_bh, it's unnecessary (even buggy if refcount of dx_root_bh is non-zero).
> 
> This patch fixes this issue by change brelse order of di_bh and dx_root_bh.
> 
Hmm, I find di_bh and dx_root_bh are initialized to NULL in ocfs2_read_inode_block(). Therefore there is no issue
described in this patch. Please ignore this patch.

Thanks.
-- 
Coly Li
SuSE Labs
