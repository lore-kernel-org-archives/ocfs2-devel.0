From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 13 Aug 2010 16:31:28 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix incorrect checksum
	validation error
In-Reply-To: <1281655466-26341-2-git-send-email-sunil.mushran@oracle.com>
References: <1281655466-26341-1-git-send-email-sunil.mushran@oracle.com>
	<1281655466-26341-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100813233128.GM17779@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 12, 2010 at 04:24:26PM -0700, Sunil Mushran wrote:
> For local mounts, ocfs2_read_locked_inode() calls ocfs2_read_blocks_sync() to
> read the inode off the disk. The latter first checks to see if that block is
> cached in the journal, and, if so, returns that block. That is ok.
> 
> But ocfs2_read_locked_inode() goes wrong when it tries to validate the checksum
> of such blocks. Blocks that are cached in the journal may not have had their
> checksum computed as yet. We should not validate the checksums of such blocks.
> 
> Fixes ossbz#1282
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1282
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Good catch.

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
