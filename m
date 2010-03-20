From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Mar 2010 18:25:54 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: use allocation reservations
 for directory data
In-Reply-To: <20100320001425.GL11402@wotan.suse.de>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
	<1268809154-1020-4-git-send-email-mfasheh@suse.com>
	<20100319224310.GF15539@mail.oracle.com>
	<20100320001425.GL11402@wotan.suse.de>
Message-ID: <20100320012554.GI15539@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 05:14:25PM -0700, Mark Fasheh wrote:
> Yeah, it'll work. My concern was that we'd be cannibalizing those too much
> since the window sizes are optimized for file data. It's only a hunch though
> that directories might want smaller windows - I didn't get much data on
> directory growth since my focus was on file data.

	I expect that directories won't use their entire reservation.
I'm just not sure it matters.  Half of the files we create won't either.
If we actually are doing a lot of creating (untar, etc), we'll
eventually canabalize the reservation attached to the directory anyway.
So I don't know why directories have to have smaller reservations.  Just
let the expire/canabalize code handle it.
	I'd be interested to see how an untar of a kernel tree or any
long-running workload that is helped by reservations changes when a
directory is reserving the same space as a file.

Joel

-- 

"War doesn't determine who's right; war determines who's left."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
