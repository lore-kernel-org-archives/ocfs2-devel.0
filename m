From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 15 Jan 2015 01:40:34 -0800
Subject: [Ocfs2-devel] [PATCH 1/4] quota: Don't store flags for v2 quota
	format
In-Reply-To: <1421260031-3355-2-git-send-email-jack@suse.cz>
References: <1421260031-3355-1-git-send-email-jack@suse.cz>
	<1421260031-3355-2-git-send-email-jack@suse.cz>
Message-ID: <20150115094034.GA32651@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>

On Wed, Jan 14, 2015 at 07:27:08PM +0100, Jan Kara wrote:
> Currently, v2 quota format blindly stored flags from in-memory dqinfo on
> disk, although there are no flags supported. Since it is stupid to store
> flags which have no effect, just store 0 unconditionally and don't
> bother loading it from disk.
> 
> Note that userspace could have stored some flags there via Q_SETINFO
> quotactl and then later read them (although flags have no effect) but
> I'm pretty sure noone does that (most definitely quota-tools don't and
> quota interface doesn't have too much other users).

What about future proofing?  Current kernels can store flags on disk,
so the best is to reserve the currently (and possibly previously)
assigned values, and mask them out when reading from disk.
