From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 19 Aug 2009 16:26:45 -0000
Subject: [Ocfs2-devel] [PATCH 07/17] vfs: Introduce new helpers for
	syncing after	writing to O_SYNC file or IS_SYNC inode
In-Reply-To: <1250697884-22288-8-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-8-git-send-email-jack@suse.cz>
Message-ID: <20090819162638.GE6150@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org, Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com, Anton Altaparmakov <aia21@cantab.net>, linux-ntfs-dev@lists.sourceforge.net, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-ext4@vger.kernel.org, tytso@mit.edu

Looks good to me.  Eventually we should use those SYNC_ flags also all
through the fsync codepath, but I'll see if I can incorporate that in my
planned fsync rewrite.
