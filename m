From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Mar 2010 20:47:58 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: use allocation reservations
	for directory data
In-Reply-To: <20100320012554.GI15539@mail.oracle.com>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
	<1268809154-1020-4-git-send-email-mfasheh@suse.com>
	<20100319224310.GF15539@mail.oracle.com>
	<20100320001425.GL11402@wotan.suse.de>
	<20100320012554.GI15539@mail.oracle.com>
Message-ID: <20100320034758.GM11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 06:25:54PM -0700, Joel Becker wrote:
> On Fri, Mar 19, 2010 at 05:14:25PM -0700, Mark Fasheh wrote:
> > Yeah, it'll work. My concern was that we'd be cannibalizing those too much
> > since the window sizes are optimized for file data. It's only a hunch though
> > that directories might want smaller windows - I didn't get much data on
> > directory growth since my focus was on file data.
> 
> 	I expect that directories won't use their entire reservation.
> I'm just not sure it matters.  Half of the files we create won't either.
> If we actually are doing a lot of creating (untar, etc), we'll
> eventually canabalize the reservation attached to the directory anyway.
> So I don't know why directories have to have smaller reservations.  Just
> let the expire/canabalize code handle it.

Cannibalizing a reservation is a bit less optimal because you're taking
any region at that point, as opposed to trying very hard to be at least
after the previous window. Also there's the shrinking logic (though in the
last couple days I've been thinking of getting rid of region shrinking).

Anyway, I'm with you regarding what the proper parameters for directory
reservations are. The fact is, i don't really know one way or the other. A
mount option seemed to at least give the user an 'out' if things go bad.


> 	I'd be interested to see how an untar of a kernel tree or any
> long-running workload that is helped by reservations changes when a
> directory is reserving the same space as a file.

Well, we could gather up some disk images to get us that information. The
patches as they are now make it easy to turn directory reservations on and
off, so running some tests doesn't even need a reboot :)

I'm not sure that untar of a kernel tree will give us anything interesting.
A parallel build would work... We could check a few arbitrary object files
to see where they're at. Those tend to be skew bigger.
	--Mark

--
Mark Fasheh
