From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 20 Aug 2009 18:22:07 -0700
Subject: [Ocfs2-devel] [PATCH 27/41] ocfs2: Abstract the creation of
	xattr block.
In-Reply-To: <1250576382-27080-27-git-send-email-tao.ma@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-27-git-send-email-tao.ma@oracle.com>
Message-ID: <20090821012207.GG10558@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 18, 2009 at 02:19:28PM +0800, Tao Ma wrote:
> In xattr reflink, we also need to create xattr block, so
> abstract the process out.

	Haha, I did this in the xa_loc changes too :-)  But yours will
go in first and I'll just drop mine.

Joel

-- 

"Vote early and vote often." 
        - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
