From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 1 Apr 2010 00:37:18 -0700
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: ocfs2_group_bitmap_size has
 to handle old volume.
In-Reply-To: <4BB41FA0.8070804@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-13-git-send-email-tao.ma@oracle.com>
	<20100401033838.GJ28680@mail.oracle.com>
	<4BB41FA0.8070804@oracle.com>
Message-ID: <20100401073717.GA19666@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 01, 2010 at 12:22:56PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >On Thu, Apr 01, 2010 at 10:59:10AM +0800, Tao Ma wrote:
> >>ocfs2_group_bitmap_size has to handle the case when the
> >>volume don't have discontiguous block group support.
> >
> >	NAK.  We specify 256 in all cases.  This doesn't hurt old code
> >because we've never used more bits.  Even though our old bg_size values
> >were much larger, we never used that space because bg_bits was set to
> >the smaller value.
> No, it hurts.
> So with an old ocfs2-tools and a new kernel, the new kernel will set
> it to 256 while the old ocfs2-tools refused to work by checking
> bg_size(see
> chainalloc_process_group in libocfs2).

*facepalm*

	Well, we shot ourselves in the foot.  The entire point of having
the size stored is so that we can vary it and the code still works.
Consider that "validation" of bg_size a bug.  The correct validation is
((bg_bits + 7) / 8) <= bg_size.
	So we do need the kernel to store the old-style bg_size in order
to keep compatibility.  But we can do better.  First, you don't need the
supports_discontig_bg argument.  You already have the superblock, just
check ocfs2_supports_discontig_bg(OCFS2_SB(sb)).
	Secondly, that function needs a big fat comment.

static inline int ocfs2_group_bitmap_size(struct super_block *sb,
					  int suballocator)
{
	int size = sb->s_blocksize -
		offsetof(struct ocfs2_group_desc, bg_bitmap);

	/*
	 * The cluster allocator uses the entire block.  Suballocators have
	 * never used more than OCFS2_MAX_BG_BITMAP_SIZE.  Unfortunately, older
	 * code expects bg_size set to the maximum.  Thus we must keep
	 * bg_size as-is unless discontig_bg is enabled.
	 */
	if (suballocator && ocfs2_supports_discontig_bg(OCFS2_SB(sb)))
		size = OCFS2_MAX_BG_BITMAP_SIZE;

	return size;
}

Joel

-- 

Life's Little Instruction Book #450

	"Don't be afraid to say, 'I need help.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
