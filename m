From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 13 Jul 2010 11:38:29 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Don't duplicate page passes
 i_size during CoW.
In-Reply-To: <4C3C7771.5000103@oracle.com>
References: <20100712091412.GA19583@mail.oracle.com>
	<1278991352-5540-1-git-send-email-tao.ma@oracle.com>
	<20100713081306.GB31479@mail.oracle.com>
	<20100713081538.GC31479@mail.oracle.com>
	<4C3C7771.5000103@oracle.com>
Message-ID: <20100713183828.GA9468@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 13, 2010 at 10:25:53PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >	Why even worry about that?  We only need up to i_size.  If end
> >is safe and not page aligned, so is i_size.
> i_size isn't safe in ocfs2_duplicate_clusters_by_page. Check the
> below function.
> 
>            if (page_has_buffers(page)) {
>                        ret = walk_page_buffers(handle, page_buffers(page),
>                                                from, to, &partial,
>                                                ocfs2_clear_cow_buffer);
>                        if (ret) {
>                                mlog_errno(ret);
>                                goto unlock;
>                        }
>                }
> So 'to' is limited to 'map_end' and then 'end'. If we set 'end' to
> i_size, we may not clear all the buffer heads

	We don't need to clear all the buffer heads.  This is the same
as the logic in block_prepare_write().  We only need to clear the blocks
that encompass i_size.  Unless we did something wrong, the buffers past
i_size should not be mapped.
	More importantly, your 'end' has the same layout.  If end is not
page aligned, it will only clear some of the blocks in its page.  Which
is fine.  There's no difference between end and i_size - they don't have
to fall on page boundaries.

Joel

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
