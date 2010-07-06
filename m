From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 6 Jul 2010 00:09:19 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: No need to zero pages past
	i_size. i_size v2
In-Reply-To: <4C30A4FD.4030900@oracle.com>
References: <20100702224912.GC5800@mail.oracle.com>
	<20100703213219.GB21262@mail.oracle.com>
	<20100703213343.GC21262@mail.oracle.com>
	<4C30A4FD.4030900@oracle.com>
Message-ID: <20100706070918.GD13023@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Sun, Jul 04, 2010 at 11:13:01PM +0800, Tao Ma wrote:
> On 07/04/2010 05:33 AM, Joel Becker wrote:
> >@@ -1142,11 +1143,17 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
> >  	/*
> >  	 * Figure out how many pages we'll be manipulating here. For
> >  	 * non allocating write, we just change the one
> >-	 * page. Otherwise, we'll need a whole clusters worth.
> >+	 * page. Otherwise, we'll need a whole clusters worth.  If we're
> >+	 * writing past i_size, we only need enough pages to cover the
> >+	 * last page of the write.
> The comments for the whole function before the function name also
> needs this change accordingly?

	Not really.  That comment set a limit, this comment is more
detailed.

> >  	if (new) {
> >  		wc->w_num_pages = ocfs2_pages_per_cluster(inode->i_sb);
> >  		start = ocfs2_align_clusters_to_page_index(inode->i_sb, cpos);
> >+		/* This is the index *past* the write */
> >+		end_index = ((user_pos + user_len)>>  PAGE_CACHE_SHIFT) + 1;
> should it be
> 		end_index = ((user_pos + user_len - 1) >> PAGE_CACHE_SHIFT) + 1?

	Maybe.  Gotta think about it and test.

Joel

-- 

Life's Little Instruction Book #232

	"Keep your promises."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
