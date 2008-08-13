From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 13 Aug 2008 12:52:48 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] Dynamic local alloc (halfway there)
In-Reply-To: <48A331A9.7000404@oracle.com>
References: <1217536922-28328-1-git-send-email-mfasheh@suse.com>
	<48A331A9.7000404@oracle.com>
Message-ID: <20080813195248.GN21187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 13, 2008 at 03:10:33PM -0400, Marcos E. Matsunaga wrote:
> The times in average goes up 3-4 times and then comes back to normal. I had
> some hard times with the kernel because at some point it starts to dump stacks
> for processes that stay too long without responding. Some of the systems had
> times over 3-4 times going up to about 10 times, but my guess is that it was
> related to the dumps as the systems get very slow at that point.

Ok, so we're doing much better - where it would slow down by about 50 times
before. How about overall run time? Is that affected at all? Do we complete
the whole test faster than before, or does the run time stay the same?


> I'm planning to leave it running again, but disabling the dumps. I'm not really
> sure it will have much of an effect in terms of performance impact, but I'll
> try.

Well, it's certainly worth knowing  :)
	--Mark

--
Mark Fasheh
