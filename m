From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Mon, 12 Jul 2010 18:37:03 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] OCFS2: Allow huge (> 16 TiB) volumes
	to mount
In-Reply-To: <20100713012506.GA30737@dastard>
References: <871vbax86w.fsf@patl.com> <87zkxyvtjt.fsf@patl.com>
	<3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca>
	<AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
	<20100713012506.GA30737@dastard>
Message-ID: <AANLkTilbFzwOib6sF-uz8v2c_1LA2UgnnoPWZ4DtDUJK@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Mon, Jul 12, 2010 at 6:25 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> The XFS code is different to the above because there is still a 16TB
> size limit on 32 bit systemsi (i.e. page cache address limits). IOWs,
> you can't just remove the above 16TB check unless you (i.e. OCFS2)
> handle >16TB block devices on 32 bit systems correctly...

If you look at my patch, you will see that is precisely what it does.
As the comments indicate, it uses the exact same check as ext4, which
will correctly refuse to mount huge volumes on 32-bit systems.

The XFS test appears to be the same thing written a little
differently.  Andreas is suggesting that somebody should factor out
this check into a common library routine.  That sounds like a fine
idea, but it also sounds orthogonal to the (simple and useful) patch I
am attempting to submit.

 - Pat
