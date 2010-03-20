From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Mar 2010 17:14:25 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: use allocation reservations
	for directory data
In-Reply-To: <20100319224310.GF15539@mail.oracle.com>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
	<1268809154-1020-4-git-send-email-mfasheh@suse.com>
	<20100319224310.GF15539@mail.oracle.com>
Message-ID: <20100320001425.GL11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 03:43:10PM -0700, Joel Becker wrote:
> On Tue, Mar 16, 2010 at 11:59:12PM -0700, Mark Fasheh wrote:
> > Use the reservations system for unindexed dir tree allocations. We
> > don't bother with the indexed tree as reads from it are mostly random
> > anyway. By default this behavior is turned off and can be turned on
> > via mount option 'dir_resv'. Workloads which create many large
> > directories will want to turn it on.
> > 
> > A future improvement will be to use a different window size for
> > directory inodes. Once done, we should change the default for this
> > feature to be enabled.
> 
> 	Why can't we turn this on and avoid a mount option?  Sure, the
> reservation holds out some space, but it will be cannibalized if
> the directory doesn't grow, right?

Yeah, it'll work. My concern was that we'd be cannibalizing those too much
since the window sizes are optimized for file data. It's only a hunch though
that directories might want smaller windows - I didn't get much data on
directory growth since my focus was on file data.


Maybe I should just go ahead and hack it up to know if a reservation is for
a directory and it could provide some fewer number of bits (maybe half the
default)? Adjusting the window size values is something we can do very
easily until we get it right.

Adding a flag field on the resv struct could accomplish this pretty easily,
and I could re-use the flag for the 'temporary' reservations, thus losing a
function call parameter in the process.


I agree though that losing the extra mount option would be good.
	--Mark

--
Mark Fasheh
