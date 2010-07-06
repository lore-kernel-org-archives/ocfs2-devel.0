From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 6 Jul 2010 11:48:16 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Zero the tail cluster when
 extending past i_size v2
In-Reply-To: <4C3156D0.5090001@oracle.com>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
	<20100629015615.GZ6590@dastard>
	<20100629020420.GE24343@mail.oracle.com>
	<20100629022757.GA6590@dastard>
	<20100629071817.GA4150@mail.oracle.com>
	<20100702224912.GC5800@mail.oracle.com>
	<20100703213219.GB21262@mail.oracle.com>
	<4C3156D0.5090001@oracle.com>
Message-ID: <20100706184816.GC17961@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Mon, Jul 05, 2010 at 11:51:44AM +0800, Tao Ma wrote:
> On 07/04/2010 05:32 AM, Joel Becker wrote:
> >+	/*
> >+	 * If tail_blkno is in the cluster past i_size, we don't need
> >+	 * to touch the cluster containing i_size at all.
> >+	 */
> >+	tail_cpos = i_size_read(inode)>>  osb->s_clustersize_bits;
> >+	if (ocfs2_blocks_to_clusters(inode->i_sb, tail_blkno)>  tail_cpos)
> >+		tail_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
> >+						     tail_blkno);
> Can we always set tail_cpos in one line?
> 	tail_cpos = ocfs2_blocks_to_clusters(inode->i_sb, tail_blkno)?
> tail_cpos is either the same cluster as i_size or the next cluster
> and both works for tail_blkno I guess?

	I'm taking this as well.

Joel


-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
