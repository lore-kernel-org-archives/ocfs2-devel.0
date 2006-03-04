From: Andrew Morton <akpm@osdl.org>
Date: Sat, 04 Mar 2006 07:37:32 -0000
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <4408C2E8.4010600@google.com>
References: <4408C2E8.4010600@google.com>
Message-ID: <20060303233617.51718c8e.akpm@osdl.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Phillips <phillips@google.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Daniel Phillips <phillips@google.com> wrote:
>
> @@ -103,31 +103,28 @@ struct dlm_lock_resource * __dlm_lookup_
>    					 const char *name,
>    					 unsigned int len)
>    {
>  -	unsigned int hash;
>  -	struct hlist_node *iter;
>  -	struct dlm_lock_resource *tmpres=NULL;
>    	struct hlist_head *bucket;
>  +	struct hlist_node *list;
> 
>    	mlog_entry("%.*s\n", len, name);
> 
>    	assert_spin_locked(&dlm->spinlock);
>  +	bucket = dlm->lockres_hash + full_name_hash(name, len) % DLM_HASH_BUCKETS;
> 
>  -	hash = full_name_hash(name, len);

err, you might want to calculate that hash outside the spinlock.

Maybe have a lock per bucket, too.

A 1MB hashtable is verging on comical.  How may data are there in total?
