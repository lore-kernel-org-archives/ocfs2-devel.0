From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Feb 2009 11:46:26 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add IO error check
	in	ocfs2_get_sector() -v2
In-Reply-To: <4994773E.6020609@oracle.com>
References: <200902120748.n1C7mVqx020705@acsinet13.oracle.com>
	<4994773E.6020609@oracle.com>
Message-ID: <20090212194626.GC14638@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 12, 2009 at 11:23:42AM -0800, Sunil Mushran wrote:
> The matching brelse() is in ocfs2_fill_super(). So you shouldn't
> need it. Cross check though please.

	No, if we get an error from ocfs2_get_sector() we return without
brelse().  So the patch is correct.

Joel

-- 

"I have never let my schooling interfere with my education."
        - Mark Twain

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
