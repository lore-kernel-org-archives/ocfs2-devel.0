From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 9 Dec 2010 17:45:10 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach 'coherency=full'
 O_DIRECT writes to correctly up_read i_alloc_sem.
In-Reply-To: <1291703707-11505-1-git-send-email-tristan.ye@oracle.com>
References: <1291703707-11505-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20101210014510.GL11104@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 07, 2010 at 02:35:07PM +0800, Tristan Ye wrote:
> Due to newly-introduced 'coherency=full' O_DIRECT writes also takes the EX
> rw_lock like buffered writes did(rw_level == 1), it turns out messing the
> usage of 'level' in ocfs2_dio_end_io() up, which caused i_alloc_sem being
> failed to get up_read'd correctly.
> 
> This patch tries to teach ocfs2_dio_end_io to understand well on all locking
> stuffs by explicitly introducing a new bit for i_alloc_sem in iocb's private
> data, just like what we did for rw_lock.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel


-- 

None of our men are "experts."  We have most unfortunately found
it necessary to get rid of a man as soon as he thinks himself an
expert -- because no one ever considers himself expert if he really
knows his job.  A man who knows a job sees so much more to be done
than he has done, that he is always pressing forward and never
gives up an instant of thought to how good and how efficient he is.
Thinking always ahead, thinking always of trying to do more, brings
a state of mind in which nothing is impossible. The moment one gets
into the "expert" state of mind a great number of things become
impossible.
	- From Henry Ford Sr., "My Life and Work"

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
