From: Ben Myers <bpm@sgi.com>
Date: Wed, 30 Jan 2013 00:57:03 -0000
Subject: [Ocfs2-devel] [PATCH 2/4] xfs: Fix possible use-after-free with
	AIO
In-Reply-To: <1359502081-20240-3-git-send-email-jack@suse.cz>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
	<1359502081-20240-3-git-send-email-jack@suse.cz>
Message-ID: <20130130005656.GM27055@sgi.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, stable@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Jan,

On Wed, Jan 30, 2013 at 12:27:59AM +0100, Jan Kara wrote:
> Running AIO is pinning inode in memory using file reference. Once AIO
> is completed using aio_complete(), file reference is put and inode can
> be freed from memory. So we have to be sure that calling aio_complete()
> is the last thing we do with the inode.
> 
> CC: xfs at oss.sgi.com
> CC: Ben Myers <bpm@sgi.com>
> CC: stable at vger.kernel.org
> Reviewed-by: Ben Myers <bpm@sgi.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

We picked this up in the xfs tree.  Sorry to keep you hanging.

Regards,
	Ben
