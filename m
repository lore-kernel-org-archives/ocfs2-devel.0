From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 1 Apr 2010 00:40:56 -0700
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: ocfs2_group_bitmap_size has
 to handle old volume.
In-Reply-To: <4BB42630.2030306@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-13-git-send-email-tao.ma@oracle.com>
	<20100401033838.GJ28680@mail.oracle.com>
	<4BB41FA0.8070804@oracle.com>
	<20100401043431.GA2629@laptop.oracle.com>
	<4BB42387.6060404@oracle.com> <4BB42630.2030306@oracle.com>
Message-ID: <20100401074055.GD19666@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 01, 2010 at 12:50:56PM +0800, Tao Ma wrote:
> actually the most worse thing I am worried about it that: the old
> fsck.ocfs2 refused to fsck the volume even in case we don't enable
> discontig-bg because the new kernel set bg_size=256 so the new inode
> group will be considered corrupted. I don't think it is endurable
> for a user.

	You are absolutely right.  We have to make that work.

Joel

-- 

"Reader, suppose you were and idiot.  And suppose you were a member of
 Congress.  But I repeat myself."
	- Mark Twain

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
