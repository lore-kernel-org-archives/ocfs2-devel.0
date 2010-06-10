From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 9 Jun 2010 17:51:55 -0700
Subject: [Ocfs2-devel] [PATCH] Reoganize data elements to reduce memory
 footprint
In-Reply-To: <20100610004509.GA27385@mail.oracle.com>
References: <AANLkTinTCrwXLiCjOm4l7uIzjRSz-17vJLLhNaCMDFJa@mail.gmail.com>
	<20100610004509.GA27385@mail.oracle.com>
Message-ID: <20100610005155.GB27385@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 09, 2010 at 05:45:10PM -0700, Joel Becker wrote:
> On Wed, Jun 09, 2010 at 04:57:11PM -0500, Goldwyn Rodrigues wrote:
> > diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> > index c67003b..34b9c79 100644
> > --- a/fs/ocfs2/ocfs2.h
> > +++ b/fs/ocfs2/ocfs2.h
> > @@ -151,17 +151,16 @@ struct ocfs2_lock_res {
> >  	void                    *l_priv;
> >  	struct ocfs2_lock_res_ops *l_ops;
> >  	spinlock_t               l_lock;
> > +	enum ocfs2_lock_type     l_type;
> 
> 	I think you should change l_type, l_action, l_requested,
> l_blocking, and l_level to unsigned char.  While the enums that set them
> should be not modified, they do not have more than 256 values.  All the
> functions around them can use the enum type in their arguments.  Just
> the ocfs2_lock_res itself stores them in unsigned char.
> 	This would potentially save us 15 bytes per ocfs2_lock_res,
> 45 per inode.  More realistic is probably 12 per lock_res and 36 per
> inode, but still!

	If you do this, please comment that they are set from enums but
are unsigned char to save space because the value never overflows.

Joel

-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
