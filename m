From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 29 Jun 2012 02:22:56 -0700
Subject: [Ocfs2-devel] [PATCH v4 1/2] aio: make kiocb->private NUll in
 init_sync_kiocb()
In-Reply-To: <20120628153956.9b7405d9.akpm@linux-foundation.org>
References: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com>
	<1340788195-20623-2-git-send-email-junxiao.bi@oracle.com>
	<20120628153956.9b7405d9.akpm@linux-foundation.org>
Message-ID: <20120629092255.GB12521@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com, linux-kernel@vger.kernel.org, joe.jin@oracle.com, stable@vger.kernel.org

On Thu, Jun 28, 2012 at 03:39:56PM -0700, Andrew Morton wrote:
> On Wed, 27 Jun 2012 17:09:54 +0800
> Junxiao Bi <junxiao.bi@oracle.com> wrote:
> 
> > Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
> > commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
> > io flag is involved in it to serialize the unaligned aio. As
> > *private is not initialized in init_sync_kiocb() of do_sync_write(),
> > this unaligned io flag may be unexpectly set in an aligned dio.
> > And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
> > to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
> > will hang forever at ocfs2_aiodio_wait() in ocfs2_file_aio_write().
> > 
> > Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> > Cc: stable at vger.kernel.org
> > Acked-by: Jeff Moyer <jmoyer@redhat.com>
> > Acked-by: Joel Becker <jlbec@evilplan.org>
> > ---
> >  include/linux/aio.h |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/linux/aio.h b/include/linux/aio.h
> > index 2314ad8..b1a520e 100644
> > --- a/include/linux/aio.h
> > +++ b/include/linux/aio.h
> > @@ -140,6 +140,7 @@ struct kiocb {
> >  		(x)->ki_dtor = NULL;			\
> >  		(x)->ki_obj.tsk = tsk;			\
> >  		(x)->ki_user_data = 0;                  \
> > +		(x)->private = NULL;			\
> >  	} while (0)
> >  
> >  #define AIO_RING_MAGIC			0xa10a10a1
> 
> hm, that code is rather cruddy.  Pointless macromania.

Agreed.

> If we do this:
> 
> static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
> {
> 	*kiocb = (struct kiocb) {
> 			.ki_users = 1,
> 			.ki_key = KIOCB_SYNC_KEY,
> 			.ki_filp = filp,
> 			.ki_obj.tsk = current,
> 		};
> }
> 
> then fs/read_write.o's .text is shrunk from 9857 bytes to 9714, which
> is rather a lot.
> 
> But that's all rather irrelevant to your bugfix.

	I like your solution.  Junxiao, if you send me that version, I'd
be happy to take it.

Joel

-- 

"I'm drifting and drifting
 Just like a ship out on the sea.
 Cause I ain't got nobody, baby,
 In this world to care for me."

			http://www.jlbec.org/
			jlbec at evilplan.org
