From: Christoph Hellwig <hch@lst.de>
Date: Thu, 19 May 2011 13:05:31 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Implement llseek()
In-Reply-To: <1305773084-19296-3-git-send-email-sunil.mushran@oracle.com>
References: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com>
	<1305773084-19296-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110519110531.GB6357@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: josef@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk, ocfs2-devel@oss.oracle.com

On Wed, May 18, 2011 at 07:44:44PM -0700, Sunil Mushran wrote:
> Unwritten (preallocated) extents are considered holes because the file system
> treats reads to such regions in the same way as it does to holes.

How does this work for the case of an unwrittent extent that has been
written to in the pagecache but not converted yet?  Y'know the big data
corruption and flamewar that started all this?
