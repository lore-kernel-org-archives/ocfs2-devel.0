From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 9 Jun 2010 17:54:49 -0700
Subject: [Ocfs2-devel] [PATCH] Reoganize data elements to reduce memory
 footprint
In-Reply-To: <20100610004509.GA27385@mail.oracle.com>
References: <AANLkTinTCrwXLiCjOm4l7uIzjRSz-17vJLLhNaCMDFJa@mail.gmail.com>
	<20100610004509.GA27385@mail.oracle.com>
Message-ID: <20100610005448.GC27385@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 09, 2010 at 05:45:10PM -0700, Joel Becker wrote:
> > diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> > index c67003b..34b9c79 100644
> > --- a/fs/ocfs2/ocfs2.h
> > +++ b/fs/ocfs2/ocfs2.h
> > @@ -151,17 +151,16 @@ struct ocfs2_lock_res {
> >  	void                    *l_priv;
> >  	struct ocfs2_lock_res_ops *l_ops;
> >  	spinlock_t               l_lock;
> > +	enum ocfs2_lock_type     l_type;

	On the subject of extreme structure diets...  ocfs2_lock_res
uses ints for l_ro_holders and l_ex_holders.  Do we ever have more than
64K holders?  Can we squash those into u16s?  I note that our code
doesn't handle overflow at all, but 2^32 holders is significantly
larger.
	Goldwyn, did you test this with CONFIG_OCFS2_FS_STATS and
CONFIG_DEBUG_LOCK_ENABLED turned on or off?  I'd be interested in that
data too.

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
