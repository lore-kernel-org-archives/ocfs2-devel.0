From: Mark Fasheh <mfasheh@suse.com>
Date: Sun, 21 Mar 2010 16:26:23 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: use allocation reservations
	for directory data
In-Reply-To: <20100320061847.GA14324@mail.oracle.com>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
	<1268809154-1020-4-git-send-email-mfasheh@suse.com>
	<20100319224310.GF15539@mail.oracle.com>
	<20100320001425.GL11402@wotan.suse.de>
	<20100320012554.GI15539@mail.oracle.com>
	<20100320034758.GM11402@wotan.suse.de>
	<20100320061847.GA14324@mail.oracle.com>
Message-ID: <20100321232623.GN11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 11:18:48PM -0700, Joel Becker wrote:
> On Fri, Mar 19, 2010 at 08:47:58PM -0700, Mark Fasheh wrote:
> > Anyway, I'm with you regarding what the proper parameters for directory
> > reservations are. The fact is, i don't really know one way or the other. A
> > mount option seemed to at least give the user an 'out' if things go bad.
> 
> 	Yeah, I hear you.  I just figure we're stuck with the option for
> the future.

Updated patches are up in git:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2-mark.git reservations

Or: http://git.kernel.org/?p=linux/kernel/git/mfasheh/ocfs2-mark.git;a=shortlog;h=refs/heads/reservations


Aside from cleaning up the license info, I remove the dir_resv/no_dir_resv
options. I also added a flags field to struct ocfs2_alloc_reservation which
saves us the 'tmpwindow' argument to ocfs2_resmap_resv_bits().


> > I'm not sure that untar of a kernel tree will give us anything interesting.
> > A parallel build would work... We could check a few arbitrary object files
> > to see where they're at. Those tend to be skew bigger.
> 
> 	I was thinking about a kernel tree untar where the directories
> are holding on to reservations as thousands of files are created under
> them.  Wouldn't that lead to cannibalization and show us that pattern?
> This is just a lay guess - you have a lot more familiarity with the
> code.

I don't know how much a kernel build is going to make a difference. I took a
couple images after kernel builds with various options but didn't see
anything obvious. To be fair though, I only checked one or two files. I'll
upload the images somewhere shortly.

As an interim compromise, I changed the code to get minimum (8 bits) sized
windows on directories. That way, they'll get some amount of
continguousness, but not as much as file data. We can easily adjust in any
direction we want.
	--Mark

--
Mark Fasheh
