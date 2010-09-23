From: Joel Becker <Joel.Becker@ORACLE.COM>
Date: Thu, 23 Sep 2010 14:23:24 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Move 'wanted' into parens of
 ocfs2_resmap_resv_bits.
In-Reply-To: <1284874949-3352-1-git-send-email-tao.ma@oracle.com>
References: <1284874949-3352-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100923212324.GC6609@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Sep 19, 2010 at 01:42:28PM +0800, Tao Ma wrote:
> The first time I read the function ocfs2_resmap_resv_bits, I consider
> about what 'wanted' will be used and consider about the comments.
> Then I find it is only used if the reservation is empty. ;)
> 
> So we'd better move it to the parens so that it make the code more
> readable, what's more, ocfs2_resmap_resv_bits is used so frequently
> and we should save some cpus. The corresponding BUG_ON is also moved
> into parens since it is only meaningful after we reinit the resv.
> 
> Acked-by: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

        This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"Also, all of life's big problems include the words 'indictment' or
	'inoperable.' Everything else is small stuff."
	- Alton Brown

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
