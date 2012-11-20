From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 20 Nov 2012 05:14:53 -0500
Subject: [Ocfs2-devel] [PATCH 0/4][RFC] remove duplicated check from
 ext4, xfs, btrfs, and ocfs2
In-Reply-To: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
Message-ID: <20121120101452.GA692@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, yan@linux.vnet.ibm.com, Zheng Liu <wenqing.lz@taobao.com>

On Tue, Nov 20, 2012 at 05:29:41PM +0800, Zheng Liu wrote:
> Hi all,
> 
> This patch series tries to remove a sanity check in fallocate from specific
> filesystems because vfs has already checked it.
> 
> I am not very familiar with why we need to do this duplicated check.  Please let
> me know if I miss something.

Each filesystem driver checks to see if a flag that it doesn't support
gets passed down.  This was done with the intention that we can add new
flags to the VFS without having to update every filesystem.
