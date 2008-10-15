From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 14 Oct 2008 17:49:24 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Wrap inode block reads in a
	dedicated function.
In-Reply-To: <20081015003627.GE8025@mail.oracle.com>
References: <20081015001716.GL15154@wotan.suse.de>
	<20081015003627.GE8025@mail.oracle.com>
Message-ID: <20081015004924.GO15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 14, 2008 at 05:36:27PM -0700, Joel Becker wrote:
> > API-wise, this is a very nice change. It makes the checks we have more
> > consistent. I think it'd be worth the time though to figure out how to
> > execute the validation code only when we've actually read the disk.
> 
> 	I'm glad you like the API (I'm almost done with group
> descriptors now too).  Regarding 'only on read', when I have the
> callback in ocfs2_read_blocks() to handle that, I can easily lift all of
> the validation there (instead of just the checksum).  Basically, I'm
> refactoring all the metadata reads before I do the read_blocks() hook.

Ahhh, ok great. So the end result is that we'll get the consistent checks
*and* we'll only be doing them when it matters. Great!


> It seems a much easier to follow series.

Yeah definitely, I see that now.
	--Mark

--
Mark Fasheh
