From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 6 Jul 2010 00:10:31 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: No need to zero pages past
	i_size. i_size v2
In-Reply-To: <4C3137A2.8040409@oracle.com>
References: <20100702224912.GC5800@mail.oracle.com>
	<20100703213219.GB21262@mail.oracle.com>
	<20100703213343.GC21262@mail.oracle.com>
	<4C30A4FD.4030900@oracle.com> <4C3137A2.8040409@oracle.com>
Message-ID: <20100706071031.GE13023@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Mon, Jul 05, 2010 at 09:38:42AM +0800, Tao Ma wrote:
> btw, do we ever have a chance that start + wc->w_num_pages >
> end_index? I can't find it.

	Of course.  If you have a 1MB clustersize, w_num_pages will be
256.  But if you are only writing the first page of the cluster,
end_index is only 1.

Joel

-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
