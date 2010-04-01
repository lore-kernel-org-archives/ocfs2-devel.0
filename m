From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 1 Apr 2010 10:53:35 -0700
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: ocfs2_group_bitmap_size has
 to handle old volume.
In-Reply-To: <4BB44F63.4020804@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-13-git-send-email-tao.ma@oracle.com>
	<20100401033838.GJ28680@mail.oracle.com>
	<4BB41FA0.8070804@oracle.com>
	<20100401073717.GA19666@mail.oracle.com>
	<4BB44F63.4020804@oracle.com>
Message-ID: <20100401175334.GJ19666@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 01, 2010 at 03:46:43PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >	So we do need the kernel to store the old-style bg_size in order
> >to keep compatibility.  But we can do better.  First, you don't need the
> >supports_discontig_bg argument.  You already have the superblock, just
> >check ocfs2_supports_discontig_bg(OCFS2_SB(sb)).
> I have thought of this before, but finally I gave up. The reason is
> that OCFS2_SB(sb) use ocfs2_super which is declared in ocfs2.h. So
> you see, I don't want to overlap these 2 head files.

	You're right about OCFS2_SB().  This comes back to your
userspace version of the interface too, where we don't even have the
superblock.
	Perhaps the ocfs2_fs.h version of the function needs the awful
integer arguments.  Maybe we can define a wrapper interface in ocfs2.h
that takes the smarter arguments.  This would allow most call sites to
read better.
	We could also define it as ocfs2_group_bitmap_size(struct
super_block *sb, int sysfile_type, u32 feature_incompat).  This requires
we pass in arguments that are obvious on their face.  We're going to
have to know the information when we call the function anyway.

Joel


-- 

Life's Little Instruction Book #450

	"Don't be afraid to say, 'I need help.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
