From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Sep 2008 20:36:41 -0700
Subject: [Ocfs2-devel] [PATCH] [RFC] jbd2: Add buffer triggers
In-Reply-To: <20080919214625.GK10950@webber.adilger.int>
References: <20080917232629.GB20752@mail.oracle.com>
	<20080919214625.GK10950@webber.adilger.int>
Message-ID: <20080920033641.GA8875@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@sun.com>
Cc: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org

On Fri, Sep 19, 2008 at 03:46:25PM -0600, Andreas Dilger wrote:
> On Sep 17, 2008  16:26 -0700, Joel Becker wrote:
> > +	/* We have the actual buffer to go out, fire any commit trigger */
> > +	/* XXX Checking trigger pointers here so as to skip kmap when
> > +	 * empty */
> > +	if (jh_in->b_triggers && jh_in->b_triggers->t_commit) {
> > +		mapped_data = kmap_atomic(new_page, KM_USER0);
> > +
> > +		jbd2_buffer_commit_trigger(jh_in, mapped_data + new_offset);
> > +		kunmap_atomic(mapped_data, KM_USER0);
> > +	}
> 
> In many cases the kmap will not be needed (i.e. never for ext* because the
> metadata buffers will always be allocated in low memory).

	The do_escape clause right below it unconditionally kmaps, so I
did as well.  ocfs2 will never need it either, but kmap is just a noop
in those circumstances.

> > index 8a62d1e..087a1c2 100644
> > --- a/include/linux/journal-head.h
> > +++ b/include/linux/journal-head.h
> > @@ -87,6 +89,9 @@ struct journal_head {
> >  	struct journal_head *b_cpnext, *b_cpprev;
> > +
> > +	/* Trigger type */
> > +	struct jbd2_buffer_trigger_type *b_triggers;
> >  };
> 
> The journal-head.h header is shared between jbd.h and jbd2.h, so it seems
> a bit strange to have a jbd2_* struct here.

	Well, I could call it journal_head_trigger?

Joel

-- 

The Graham Corollary:

	The longer a socially-moderated news website exists, the
	probability of an old Paul Graham link appearing at the top
	approaches certainty.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
