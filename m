From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Feb  7 13:38:46 2008
Subject: [Ocfs2-devel] Re: [git patches] ocfs2 update
In-Reply-To: <20080207124745.4868e108.akpm@linux-foundation.org>
References: <20080207200944.GQ22671@ca-server1.us.oracle.com>
	<20080207124745.4868e108.akpm@linux-foundation.org>
Message-ID: <20080207213714.GR22671@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <Joel.Becker@oracle.com>

On Thu, Feb 07, 2008 at 12:47:45PM -0800, Andrew Morton wrote:
> On Thu, 7 Feb 2008 12:09:44 -0800
> Mark Fasheh <mark.fasheh@oracle.com> wrote:
> 
> >  /*
> > - * dlm_register_domain: one-time setup per "domain"
> > + * Compare a requested locking protocol version against the current one.
> > + *
> > + * If the major numbers are different, they are incompatible.
> > + * If the current minor is greater than the request, they are incompatible.
> > + * If the current minor is less than or equal to the request, they are
> > + * compatible, and the requester should run at the current minor version.
> > + */
> > +static int dlm_protocol_compare(struct dlm_protocol_version *existing,
> > +				struct dlm_protocol_version *request)
> > +{
> > +	if (existing->pv_major != request->pv_major)
> > +		return 1;
> > +
> > +	if (existing->pv_minor > request->pv_minor)
> > +		return 1;
> > +
> > +	if (existing->pv_minor < request->pv_minor)
> > +		request->pv_minor = existing->pv_minor;
> > +
> > +	return 0;
> > +}
> > +
> 
> It's somewhat obnoxious that what appears to be a straightforward
> compare-two-things-and-return-result function will actually modify one of
> the things which it is allegedly comparing.

Yeah, a better name would probably help with readability. Joel, how about
dlm_protocol_compare_and_set()?


> Please integrate checkpatch into your processes - this one had a few little
> glitches.

FWIW - I've run all patches through checkpatch.pl since your last review.
This one went through a couple cycles of checkpatch actually :) There's
three warnings that I get:

ERROR: "foo * bar" should be "foo *bar"
#70: FILE: fs/ocfs2/dlm/dlmapi.h:200:
+struct dlm_ctxt * dlm_register_domain(const char *domain, u32 key,

WARNING: line over 80 characters
#269: FILE: fs/ocfs2/dlm/dlmdomain.c:813:
+
#&dlm->fs_locking_proto,

WARNING: line over 80 characters
#270: FILE: fs/ocfs2/dlm/dlmdomain.c:814:
+
#&query->fs_proto)) {

total: 1 errors, 2 warnings, 569 lines checked


The "foo * bar" one is from existing code which got moved, and I felt that
leaving them unmodified was cleaner from a patch-reading perspective.

The over 80 characters warnings were ignored as the code seemed more
readable as-is.


I guess a lot of this can be subjective though, so I can be super strict if
you really feel it's necessary.


Thanks,
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
