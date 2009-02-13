From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 13 Feb 2009 15:03:31 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: set xh_free_start when
	xattr	header in inode/block
In-Reply-To: <4993915D.8050807@oracle.com>
References: <499238F3.9010208@oracle.com>
	<1234319891-7020-1-git-send-email-tiger.yang@oracle.com>
	<20090211185007.GJ9512@mail.oracle.com>
	<4993915D.8050807@oracle.com>
Message-ID: <20090213230331.GE4897@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 12, 2009 at 11:02:53AM +0800, Tiger Yang wrote:
> Thanks for quick review.  I have thought of that and have already made a  
> patch for it. But as we didn't officially release tools which support  
> EAs(include mkfs) even in git tree, do we really need this patch?

	Yes,  People will be using .28 even after we release the tools.

Joel

-- 

"I almost ran over an angel
 He had a nice big fat cigar.
 'In a sense,' he said, 'You're alone here
 So if you jump, you'd best jump far.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
