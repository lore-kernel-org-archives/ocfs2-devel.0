From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 26 Oct 2008 21:06:58 -0700
Subject: [Ocfs2-devel] xattr fixes branch
In-Reply-To: <20081025211900.GP15154@wotan.suse.de>
References: <20081024002246.GF12751@mail.oracle.com>
	<20081025211900.GP15154@wotan.suse.de>
Message-ID: <20081027040657.GC8046@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 25, 2008 at 02:19:00PM -0700, Mark Fasheh wrote:
> 	Thanks for doing this. I've got the patches all pulled into

	No problem.

> 	I'm thinking to keep fixes that will go upstream in the current
> release in a 'fixes' branch. For 2.6.28, I started this from your xattr-28
> branch, put my signoffs on the patches, and added an mmap fix from Tao which
> I had already. This will get rebased every time I send fixes upstream.
> 
> 	For new features, I started a merge_window branch. This worked
> really well for us recently imho. Early in the cycle, this might get rebased
> as large-ish fixes are pushed upstream. By the end of the development cycle
> though (when fixes are smaller), I suspect it won't have to be rebased as
> often, or at all.

	Works for me.  I'll even take on one of the two branches if that
makes your life easier.  Or if you want me to take them at moments your
busy (like we just did), just shout.

> 	If people wouldn't mind developing against some version of
> merge_window, it would make getting all this stuff together much easier. As
> always though, if the choice is between rebasing or doing some PITA merge
> versus getting a high quality feature going, feel free to push the merge
> pain onto me :)

	I think merge_window is great, because our ALL doesn't
distinguish "going to next version" from "marinating".  I wonder,
though, if "merge_window" and "linux-next" don't overlap?  What would be
in "merge_window" that wouldn't also be in "linux-next"?

> 	Right now, merge_window is based on upstream. I'm thinking perhaps
> we should base it on the current 'fixes' branch, since some of them are on
> the large-ish side - that would make getting our patches together more
> smoothly.

	This is probably your call, but this sounds like a good way to
do it.

Joel

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
