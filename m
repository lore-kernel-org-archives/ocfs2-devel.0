From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 23 Jun 2010 14:01:36 -0700
Subject: [Ocfs2-devel] [PATCH] Track negative dentries
In-Reply-To: <AANLkTimK8sGY5nt5CxDeDfBQeJeGQ7LIqILifnTrR6Q8@mail.gmail.com>
References: <AANLkTilwWhweSS4BxXZCQxCAicETuZ2rjFb_BHMM3YGZ@mail.gmail.com>
	<4C1B9968.6020805@oracle.com>
	<AANLkTilk1YjhLjRectGjzgTKpK4bBeQlKj1Y_9F110bx@mail.gmail.com>
	<4C225B09.7000903@oracle.com>
	<AANLkTimK8sGY5nt5CxDeDfBQeJeGQ7LIqILifnTrR6Q8@mail.gmail.com>
Message-ID: <20100623210135.GD20090@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 23, 2010 at 03:27:50PM -0500, Goldwyn Rodrigues wrote:
> On Wed, Jun 23, 2010 at 2:05 PM, Sunil Mushran <sunil.mushran@oracle.com> wrote:
> >>> kmalloc()s can fail. If this is just an int, why not just store it
> >>> directly in d_fsdata. Add appropriate casts.
> >>>
> >>
> >> This will cause compilation warnings for either x86_64 or i686 systems
> >> depending on the data type we choose. I will do this anyways.
> >>
> >
> > See if you can silence the warning. My main problem here is that
> > we don't handle the error case. So if kmalloc() is seen as the best
> > solution, go ahead use it, but do handle the ENOMEM case.
> >
> 
> Oh yes, changing the (function) variables to long should do it, since
> long is the same size as pointer.
> I will make the change and test it. Thanks.

	You can use an int too.  Casting works.  That said, using an
unsigned long does not hurt.  Make sure you use unsigned long, as
pointers are unsigned longs.  You'll still need to cast to/from.

Joel

-- 

"What no boss of a programmer can ever understand is that a programmer
 is working when he's staring out of the window"
	- With apologies to Burton Rascoe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
