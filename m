From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 6 Dec 2010 19:36:37 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] Ocfs2: Add a new code
 'OCFS2_INFO_FREEFRAG' for o2info ioctl.
In-Reply-To: <4CFD91C2.1070605@oracle.com>
References: <1289902422-3315-1-git-send-email-tristan.ye@oracle.com>
	<1289902422-3315-4-git-send-email-tristan.ye@oracle.com>
	<20101207011159.GN16687@mail.oracle.com>
	<4CFD91C2.1070605@oracle.com>
Message-ID: <20101207033637.GC2233@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 07, 2010 at 09:45:38AM +0800, Tristan Ye wrote:
> >>+	gb_dinode = (struct ocfs2_dinode *)bh->b_data;
> >>+	cl = &(gb_dinode->id2.i_chain);
> >
> >	This is safe because we never remove a chain entry from an
> >inode.  However, if we ever shrink disks, we'll need to coordinate with
> >this code.  Perhaps we should comment that.
> 
>    Alright, and the recoordination only would be needed for
> none-coherency case, right?
> 
> Fully-coherent case will be holding the inode lock, and never allow
> disk to be shrinked during the inquiry.

	You are correct.

>    Oh, Wait, an arbitrary 'fdisk' can shrink the disk regardless of
> cluster-coherency.

	We're not worried about that.  That's a mistake made by the
sysadmin, and there is no way to prevent it.  I'm only talking about a
tunefs operation that validly shrinks the ocfs2 filesystem.  We don't do
it today, but if we ever do this dirty read has to know about it.  Not
for accuracy, just not to crash.

Joel

-- 

"What no boss of a programmer can ever understand is that a programmer
 is working when he's staring out of the window"
	- With apologies to Burton Rascoe

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
