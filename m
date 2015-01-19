From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 19 Jan 2015 01:00:35 -0800
Subject: [Ocfs2-devel] [PATCH 01/17] quota: Split ->set_xstate callback
	into two
In-Reply-To: <1421412471-4747-2-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-2-git-send-email-jack@suse.cz>
Message-ID: <20150119090035.GA27474@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Fri, Jan 16, 2015 at 01:47:35PM +0100, Jan Kara wrote:
> Split ->set_xstate callback into two callbacks - one for turning quotas
> on (->quota_enable) and one for turning quotas off (->quota_disable). That
> way we don't have to pass quotactl command into the callback which seems
> cleaner.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
