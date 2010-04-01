From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 1 Apr 2010 16:43:21 -0700
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: ocfs2_group_bitmap_size has
 to handle old volume.
In-Reply-To: <4BB52D24.1070204@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-13-git-send-email-tao.ma@oracle.com>
	<20100401033838.GJ28680@mail.oracle.com>
	<4BB41FA0.8070804@oracle.com>
	<20100401073717.GA19666@mail.oracle.com>
	<4BB44F63.4020804@oracle.com>
	<20100401175334.GJ19666@mail.oracle.com>
	<4BB52D24.1070204@oracle.com>
Message-ID: <20100401234321.GD27788@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Apr 02, 2010 at 07:32:52AM +0800, Tao Ma wrote:
> I just went through all the callers of ocfs2_group_bitmap_size and
> it seems that it is called in 2 scenarios:
> 1. set bg_size.
> 2. check some situation in resize.
> 
> So how about change it to
> ocfs2_group_bitmap_size(struct super_block *sb, struct ocfs2_group_desc *gd)
> so if gd is NULL, we returns the old value, if not, just return bg_size.

	That makes no sense, because we're asking for "what it should
be", not "what it is".

> As for place of setting bg_size, we can set bg_bits first and then
> set bg_size to (bg_bits +7)/8.

	But when we grow a group, we'll set bg_size to 256, which blows
up tools.

Joel

-- 

You can use a screwdriver to screw in screws or to clean your ears,
however, the latter needs real skill, determination and a lack of fear
of injuring yourself.  It is much the same with JavaScript.
	- Chris Heilmann

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
