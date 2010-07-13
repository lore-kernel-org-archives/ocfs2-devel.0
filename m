From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 13 Jul 2010 01:13:07 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Don't duplicate page passes
 i_size during CoW.
In-Reply-To: <1278991352-5540-1-git-send-email-tao.ma@oracle.com>
References: <20100712091412.GA19583@mail.oracle.com>
	<1278991352-5540-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100713081306.GB31479@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 13, 2010 at 11:22:32AM +0800, Tao Ma wrote:
> +	/*
> +	 * We only duplicate pages until we reach i_size.
> +	 * So trim 'end' to the boundary of that page.
> +	 */
> +	if (end > i_size_read(context->inode))
> +		end = ((i_size_read(context->inode) + PAGE_CACHE_SIZE - 1) >>
> +			 PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;

Just use PAGE_CACHE_ALIGN().

Joel

-- 

"Any man who is under 30, and is not a liberal, has not heart;
 and any man who is over 30, and is not a conservative, has no brains."
         - Sir Winston Churchill 

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
