From: Christoph Hellwig <hch@lst.de>
Date: Sat, 8 Jan 2011 08:47:11 +0100
Subject: [Ocfs2-devel] [PATCH] quota: Fix deadlock during path resolution
In-Reply-To: <20110107215904.GQ21922@thunk.org>
References: <1284586791-8245-1-git-send-email-jack@suse.cz>
	<20100915225208.GA1490@lst.de>
	<20100916095553.GA3359@quack.suse.cz>
	<20110107215904.GQ21922@thunk.org>
Message-ID: <20110108074711.GB13024@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Al Viro <viro@ZenIV.linux.org.uk>, Joel Becker <joel.becker@oracle.com>

On Fri, Jan 07, 2011 at 04:59:04PM -0500, Ted Ts'o wrote:
> 
> 	http://patchwork.ozlabs.org/patch/64910/
> 
> Did anything ever happen with Christoph's ocfs2 quota patch, which he
> was going to rebase?  I took a quick gander in git and I didn't see
> anything, but maybe I was looking in the wrong place.

The last plan was to push Jan's patch in and I'll rebase the unification
on top of that.  That's been a while ago and I really should have been
updating my patch, but things kept me quite busy unfortunately.
