From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 26 Mar 2014 15:23:57 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: check if cluster name exists
	before deref
In-Reply-To: <20140326150840.6025512719ffbc4a601dd808@linux-foundation.org>
References: <1395768118-21368-1-git-send-email-sasha.levin@oracle.com>
	<20140326220018.GE5716@wotan.suse.de>
	<20140326150840.6025512719ffbc4a601dd808@linux-foundation.org>
Message-ID: <20140326222357.GF5716@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 26, 2014 at 03:08:40PM -0700, Andrew Morton wrote:
> On Wed, 26 Mar 2014 15:00:18 -0700 Mark Fasheh <mfasheh@suse.de> wrote:
> 
> > > As a side note, how the hell was this new code path tested?
> > > It's obviously broken and there's no way it even passes
> > > a very basic test.
> > 
> > I'm not trying to 'defend' Goldwyn, or anything, but mistakes get made -
> > it's a fact of life. We have a review process to hopefully catch these sorts
> > of things, you are welcome to take part in it. In fact, if you were
> > willing to test and report these sorts of things to the Ocfs2-devel list
> > before they go upstream that would probably help prevent this sort of thing
> > from happening in the future.
> 
> Well.  Sasha is the kernel's reigning testing-and-reporting champion. On
> linux-next, no less.

Huh, Sasha, are you testing Ocfs2 from linux-next? If so some details of how
/ what you test would be appreciated. Otherwise, perhaps we could talk
about some basic Ocfs2 tests then?


> What concerns me is that the wrong patch version was merged, or it got
> mangled in flight somehow.

I kind of assumed that must've been what happened, but probably on
Goldwyn's end - that he sent the wrong version of the patch or something.
It's not like that hasn't happened to me before, etc. In flight would be
weird for me to hear though, I've never experienced that happening.
	--Mark

--
Mark Fasheh
