From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 1 Apr 2010 00:39:59 -0700
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: ocfs2_group_bitmap_size has
 to handle old volume.
In-Reply-To: <4BB42387.6060404@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-13-git-send-email-tao.ma@oracle.com>
	<20100401033838.GJ28680@mail.oracle.com>
	<4BB41FA0.8070804@oracle.com>
	<20100401043431.GA2629@laptop.oracle.com>
	<4BB42387.6060404@oracle.com>
Message-ID: <20100401073959.GC19666@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 01, 2010 at 12:39:35PM +0800, Tao Ma wrote:
> Wengang Wang wrote:
> >Is "old ocfs2-tools + new kernel" supported?
> I guess yes? I am not sure whether a user can use a 2.6.35
> kernel(the next merge window) while using an ocfs2-tools 1.4.

	Yes.  Even ocfs2-tools 1.2 will work, as long as the filesystem
was formatted with --feature-level=max-compat.

Joel

-- 

"In the arms of the angel, fly away from here,
 From this dark, cold hotel room and the endlessness that you fear.
 You are pulled from the wreckage of your silent reverie.
 In the arms of the angel, may you find some comfort here."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
