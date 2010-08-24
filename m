From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 24 Aug 2010 09:34:48 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix deadlock when allocating page
In-Reply-To: <1282652883-21019-1-git-send-email-jack@suse.cz>
References: <1282652883-21019-1-git-send-email-jack@suse.cz>
Message-ID: <20100824163447.GC14548@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 24, 2010 at 02:28:03PM +0200, Jan Kara wrote:
> We cannot call grab_cache_page() when holding filesystem locks or with
> a transaction started as grab_cache_page() calls page allocation with
> GFP_KERNEL flag and thus page reclaim can recurse back into the filesystem
> causing deadlocks or various assertion failures. We have to use
> find_or_create_page() instead and pass it GFP_NOFS as we do with other
> allocations.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
