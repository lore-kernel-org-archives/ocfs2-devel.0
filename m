From: Mark Fasheh <mfasheh@suse.com>
Date: Sun, 8 Aug 2010 12:47:19 -0700
Subject: [Ocfs2-devel] [PATCH 2/2 v3] ocfs2: Remove ocfs2_sync_inode()
In-Reply-To: <1281033166-12485-3-git-send-email-jack@suse.cz>
References: <1281033166-12485-1-git-send-email-jack@suse.cz>
	<1281033166-12485-3-git-send-email-jack@suse.cz>
Message-ID: <20100808194719.GB17779@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 05, 2010 at 08:32:46PM +0200, Jan Kara wrote:
> ocfs2_sync_inode() is used only from ocfs2_sync_file(). But all data has
> already been written before calling ocfs2_sync_file() and ocfs2 doesn't use
> inode's private_list for tracking metadata buffers thus sync_mapping_buffers()
> is superfluous as well.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
