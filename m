From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 Jul 2010 11:32:28 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: don't access beyond bitmap size
In-Reply-To: <201006301224.o5U1mkX5011318@acsinet15.oracle.com>
References: <201006301224.o5U1mkX5011318@acsinet15.oracle.com>
Message-ID: <20100712183227.GB12179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 30, 2010 at 08:23:30PM +0800, Wengang Wang wrote:
> dlm->recovery_map is defined as
> 	unsigned long recovery_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
> 
> We should treat O2NM_MAX_NODES as the bit map size in bits.
> This patches fixes a bit operation that takes O2NM_MAX_NODES + 1 as bitmap size.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

 The zen have a saying:
 "When you learn how to listen, ANYONE can be your teacher."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
