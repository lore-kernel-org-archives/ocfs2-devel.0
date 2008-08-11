From: Mark Fasheh <mfasheh@suse.com>
Date: Sun, 10 Aug 2008 18:22:28 -0700
Subject: [Ocfs2-devel] [PATCH 06/15] Add helper function in uptodate for
	removing xattr clusters.V3
In-Reply-To: <1218061894-7693-6-git-send-email-tao.ma@oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-6-git-send-email-tao.ma@oracle.com>
Message-ID: <20080811012228.GB21187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 07, 2008 at 06:31:28AM +0800, Tao Ma wrote:
> Modification from V2 to V3:
> Change ocfs2_remove_block_from_cache to be static.
> 
> The old uptodate only handles the issue of removing one buffer_head
> from ocfs2 inode's buffer cache. With xattr clusters, we may need to
> remove some clusters from the cache. So add helper function for it.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This looks great, thanks.
	--Mark

--
Mark Fasheh
