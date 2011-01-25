From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 24 Jan 2011 16:36:41 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2_page_mkwrite path
In-Reply-To: <20110124235923.GC24732@noexit>
References: <201101131103.p0D7C5Cx002897@acsinet15.oracle.com>
	<20110124231835.GJ9240@wotan.suse.de>
	<20110124232830.GB24732@noexit>
	<20110124235425.GK9240@wotan.suse.de>
	<20110124235923.GC24732@noexit>
Message-ID: <20110125003641.GL9240@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 24, 2011 at 03:59:24PM -0800, Joel Becker wrote:
> On Mon, Jan 24, 2011 at 03:54:25PM -0800, Mark Fasheh wrote:
> > And instead I'd rather see:
> > 
> >         ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
> >                                          cluster_of_pages, mmap_page);
> >         if (ret) {
> > 		if (ret == -EWHATEVER) {
> 
> 	Ok, so what is EWHATEVER?

-EINVAL? That's what we used to return from ocfs2_grab_pages_for_write().
The only other possible return value right now is ENOMEM so we could pick
anything really.

errno values aren't very descriptive, which sucks (but that's what we have
to deal with).


Then again, if we want to be super explicit we could also just do:

#define	EMAPPINGCHANGED	1
int ocfs2_grab_pages_for_write( ... )
{

}

and return our own nonzero value.
	--Mark

--
Mark Fasheh
