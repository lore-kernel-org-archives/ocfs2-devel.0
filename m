From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 18 Nov 2010 15:42:16 -0800
Subject: [Ocfs2-devel] fs/ocfs2/dlm: Use GFP_ATOMIC under spin_lock
In-Reply-To: <20101102223601.GA27513@ds.suse.cz>
References: <20101102223601.GA27513@ds.suse.cz>
Message-ID: <20101118234216.GH19821@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Sterba <dsterba@suse.cz>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, mfasheh@suse.com

On Tue, Nov 02, 2010 at 11:36:02PM +0100, David Sterba wrote:
> coccinelle check scripts/coccinelle/locks/call_kern.cocci found that
> in fs/ocfs2/dlm/dlmdomain.c an allocation with GFP_KERNEL is done
> with locks held:
> 
> dlm_query_region_handler
>   spin_lock(dlm_domain_lock)
>     dlm_match_regions
>       kmalloc(GFP_KERNEL)
> 
> Change it to GFP_ATOMIC.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> CC: Joel Becker <joel.becker@oracle.com>
> CC: Mark Fasheh <mfasheh@suse.com>
> CC: ocfs2-devel at oss.oracle.com

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Behind every successful man there's a lot of unsuccessful years."
        - Bob Brown

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
