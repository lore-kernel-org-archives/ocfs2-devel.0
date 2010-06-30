From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 30 Jun 2010 05:00:15 -0700
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: Add struct file to
	ocfs2_refcount_cow.
In-Reply-To: <4C2AB5F3.10000@oracle.com>
References: <4C29AE6C.1050205@oracle.com>
	<1277800541-6844-1-git-send-email-tao.ma@oracle.com>
	<20100629231453.GH4150@mail.oracle.com> <4C2AB5F3.10000@oracle.com>
Message-ID: <20100630120013.GA14686@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 30, 2010 at 11:11:47AM +0800, Tao Ma wrote:
> oh, sorry joel. There does exist one place that we don't have filp.
> It is in ocfs2_orphan_for_truncate, we have to CoW the cluster
> containing i_size and pass NULL as filp.

	Maybe ocfs2_cow_file_pos() needs both, but write_begin_nolock
and page_mkwrite do not.

Joel

-- 

"I don't want to achieve immortality through my work; I want to
 achieve immortality through not dying."
        - Woody Allen

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
