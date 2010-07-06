From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 6 Jul 2010 11:39:46 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: No need to zero pages past
 i_size. i_size v2
In-Reply-To: <20100706070918.GD13023@mail.oracle.com>
References: <20100702224912.GC5800@mail.oracle.com>
	<20100703213219.GB21262@mail.oracle.com>
	<20100703213343.GC21262@mail.oracle.com>
	<4C30A4FD.4030900@oracle.com>
	<20100706070918.GD13023@mail.oracle.com>
Message-ID: <20100706183946.GB17961@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>, Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Tue, Jul 06, 2010 at 12:09:19AM -0700, Joel Becker wrote:
> On Sun, Jul 04, 2010 at 11:13:01PM +0800, Tao Ma wrote:
> > >  	if (new) {
> > >  		wc->w_num_pages = ocfs2_pages_per_cluster(inode->i_sb);
> > >  		start = ocfs2_align_clusters_to_page_index(inode->i_sb, cpos);
> > >+		/* This is the index *past* the write */
> > >+		end_index = ((user_pos + user_len)>>  PAGE_CACHE_SHIFT) + 1;
> > should it be
> > 		end_index = ((user_pos + user_len - 1) >> PAGE_CACHE_SHIFT) + 1?
> 
> 	Maybe.  Gotta think about it and test.

	I think you're right.  Since there are other changes too, I'm
going to add this in and test it.

Joel

-- 

"I'm drifting and drifting
 Just like a ship out on the sea.
 Cause I ain't got nobody, baby,
 In this world to care for me."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
