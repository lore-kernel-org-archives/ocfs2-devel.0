From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Mar 2010 23:18:48 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: use allocation reservations
 for directory data
In-Reply-To: <20100320034758.GM11402@wotan.suse.de>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
	<1268809154-1020-4-git-send-email-mfasheh@suse.com>
	<20100319224310.GF15539@mail.oracle.com>
	<20100320001425.GL11402@wotan.suse.de>
	<20100320012554.GI15539@mail.oracle.com>
	<20100320034758.GM11402@wotan.suse.de>
Message-ID: <20100320061847.GA14324@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 08:47:58PM -0700, Mark Fasheh wrote:
> Anyway, I'm with you regarding what the proper parameters for directory
> reservations are. The fact is, i don't really know one way or the other. A
> mount option seemed to at least give the user an 'out' if things go bad.

	Yeah, I hear you.  I just figure we're stuck with the option for
the future.

> I'm not sure that untar of a kernel tree will give us anything interesting.
> A parallel build would work... We could check a few arbitrary object files
> to see where they're at. Those tend to be skew bigger.

	I was thinking about a kernel tree untar where the directories
are holding on to reservations as thousands of files are created under
them.  Wouldn't that lead to cannibalization and show us that pattern?
This is just a lay guess - you have a lot more familiarity with the
code.

Joel

-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
