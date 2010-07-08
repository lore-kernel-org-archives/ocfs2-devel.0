From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 8 Jul 2010 11:36:23 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: make xattr extension work with new
 local alloc reservation.
In-Reply-To: <1276830171-5908-1-git-send-email-tao.ma@oracle.com>
References: <4C1AE141.60707@oracle.com>
	<1276830171-5908-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100708183623.GC17445@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 18, 2010 at 11:02:50AM +0800, Tao Ma wrote:
> +		goto restarted_transaction;

	There's no need to confuse the issue with gotos here.  Just make
it a loop, while (clusters_to_add).  Make the vb->vb_access through
ocfs2_journal_dirty() parts a subfunction so that the loop is readable.
Have the subfunction return the number of clusters added, or -errno on
error.  Then process the why in this function.

Joel

-- 

"Reader, suppose you were and idiot.  And suppose you were a member of
 Congress.  But I repeat myself."
	- Mark Twain

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
