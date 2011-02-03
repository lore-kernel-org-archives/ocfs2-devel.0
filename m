From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 3 Feb 2011 10:13:15 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix estimate of necessary credits
	for mkdir
In-Reply-To: <1296738979-27791-1-git-send-email-jack@suse.cz>
References: <1296738979-27791-1-git-send-email-jack@suse.cz>
Message-ID: <20110203181315.GC1703@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 03, 2011 at 02:16:19PM +0100, Jan Kara wrote:
> In the rare case that INLINE_DATA, INDEX_DIR, QUOTA, XATTR features are
> disabled and both the allocation of the directory inode and the allocation
> of the first directory block need to relink allocation group, there need
> not be enough credits reserved in a transaction. Fix the estimate.
> 
> CC: Mark Fasheh <mfasheh@suse.de>
> Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
