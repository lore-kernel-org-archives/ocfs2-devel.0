From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 1 Apr 2010 00:38:29 -0700
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: ocfs2_group_bitmap_size has
 to handle old volume.
In-Reply-To: <20100401043431.GA2629@laptop.oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-13-git-send-email-tao.ma@oracle.com>
	<20100401033838.GJ28680@mail.oracle.com>
	<4BB41FA0.8070804@oracle.com>
	<20100401043431.GA2629@laptop.oracle.com>
Message-ID: <20100401073829.GB19666@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 01, 2010 at 12:34:31PM +0800, Wengang Wang wrote:
> Just for my info.
> Is "old ocfs2-tools + new kernel" supported?

	Absolutely.  As is "old kernel + new ocfs2-tools".  As long as
the features of the particular formatted filesystem are understood by
both tools and kernel, they should work.

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
