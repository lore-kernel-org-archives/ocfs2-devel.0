From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 5 May 2010 18:11:35 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Make
 ocfs2_find_cpos_for_left_leaf() public.
In-Reply-To: <1271059887-12640-1-git-send-email-tristan.ye@oracle.com>
References: <1271059887-12640-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100506011135.GB9955@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 12, 2010 at 04:11:26PM +0800, Tristan Ye wrote:
> The original idea to pull ocfs2_find_cpos_for_left_leaf() out of
> alloc.c is to benefit punching-holes optimization patch, it however,
> can also be referred by other funcs in the future who want to do the
> same job.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

Tristan,
	Don't these patches sit atop another truncate cleanup?  Can you
send me an entire series with everything required for cleanup and
optimization of truncate and hole clearing.

Thanks,
Joel

-- 

"The nearest approach to immortality on Earth is a government
 bureau."
	- James F. Byrnes

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
