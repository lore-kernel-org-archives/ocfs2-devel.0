From: Joel Becker <Joel.Becker@ORACLE.COM>
Date: Thu Feb 28 14:37:41 2008
Subject: [Ocfs2-devel] [PATCH 02/18] ocfs2_dlm: Creates slabcaches for
	the lockres' and the locks
In-Reply-To: <1203970862-8790-3-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080228223612.GE23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:46PM -0800, Sunil Mushran wrote:
> This patch makes the o2dlm allocate memory for lockres, lockname and lock
> structures from slabcaches rather than kmalloc. This allows us to not only
> make these allocs more efficient but also allows us to track the memory being
> consumed by these structures.
> 
...
> +/* create/destroy slab caches */
> +int dlm_init_lockres_cache(void);
> +void dlm_destroy_lockres_cache(void);
> +
> +int dlm_init_lockname_cache(void);
> +void dlm_destroy_lockname_cache(void);

	Why not have one dlm_init_master_caches()?  These two are in the
same file.

> -	lock = kzalloc(sizeof(*lock), GFP_NOFS);
> +	lock = (struct dlm_lock *) kmem_cache_alloc(dlm_lock_cache, GFP_NOFS);
>  	if (!lock)
>  		return NULL;
> +	memset(lock, 0, sizeof(struct dlm_lock));

	Probably want to use kmem_cache_zalloc().

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
