From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 9 Jan 2006 13:45:01 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: actually free hb set on cluster
	removal
In-Reply-To: <20060109174235.GB25744@locomotive.unixthugs.org>
References: <20060109174235.GB25744@locomotive.unixthugs.org>
Message-ID: <20060109214501.GG3313@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On Mon, Jan 09, 2006 at 12:42:35PM -0500, Jeff Mahoney wrote:
>  Since heartbeat threads are stopped when the individual heartbeat sets are
>  removed, this just cleans up the allocation.
Yes, it seems we're leaking memory there.

> +	o2hb_free_hb_set(cluster->cl_group.default_groups[1]);
>  	for (i = 0; cluster->cl_group.default_groups[i]; i++) {
>  		killme = &cluster->cl_group.default_groups[i]->cg_item;
>  		cluster->cl_group.default_groups[i] = NULL;
What about the for loop on the next line? Won't that try to access memory
freed in the call to o2hb_free_hb_set(...)?                 
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
