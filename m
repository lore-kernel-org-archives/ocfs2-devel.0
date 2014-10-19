From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 19 Oct 2014 07:16:28 -0700
Subject: [Ocfs2-devel] [PATCH 0/12 v2] Moving i_dquot out of struct inode
In-Reply-To: <20141018192624.GA16478@quack.suse.cz>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
	<20141011133452.GA29004@infradead.org>
	<20141017192428.GA19788@quack.suse.cz>
	<20141018151738.GG30355@infradead.org>
	<20141018192624.GA16478@quack.suse.cz>
Message-ID: <20141019141628.GA2485@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Sat, Oct 18, 2014 at 09:26:24PM +0200, Jan Kara wrote:
>   But that was in the superblock, not in the inode...

You're right!  Sorry for the confusion.
