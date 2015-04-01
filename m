From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 1 Apr 2015 08:43:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: check if the ocfs2 lock resource
 be initialized before calling ocfs2_dlm_lock
In-Reply-To: <20150331151348.2887ede16683257826833e04@linux-foundation.org>
References: <5518C165.10106@huawei.com>
	<20150331151348.2887ede16683257826833e04@linux-foundation.org>
Message-ID: <551B3F41.6020501@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

On 2015/4/1 6:13, Andrew Morton wrote:
> On Mon, 30 Mar 2015 11:22:13 +0800 alex chen <alex.chen@huawei.com> wrote:
> 
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -1391,6 +1391,11 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
>>  	int noqueue_attempted = 0;
>>  	int dlm_locked = 0;
>>
>> +	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED)) {
>> +		mlog_errno(-EINVAL);
>> +		return -EINVAL;
>> +	}
> 
> hm.  How about we do this?
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: ocfs2: make mlog_errno return the errno
> 
> ocfs2 does
> 
> 	mlog_errno(v);
> 	return v;
> 
> in many places.  Change mlog_errno() so we can do
> 
> 	return mlog_errno(v);
> 
I don't think this is fit for all.
In many places it should do cleanup rather than just return the error
code.

> For some weird reason this patch reduces the size of ocfs2 by 6k:
> 
> akpm3:/usr/src/25> size fs/ocfs2/ocfs2.ko
>    text    data     bss     dec     hex filename
> 1146613   82767  832192 2061572  1f7504 fs/ocfs2/ocfs2.ko-before
> 1140857   82767  832192 2055816  1f5e88 fs/ocfs2/ocfs2.ko-after
> 
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: alex chen <alex.chen@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/cluster/masklog.h |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff -puN fs/ocfs2/cluster/masklog.h~a fs/ocfs2/cluster/masklog.h
> --- a/fs/ocfs2/cluster/masklog.h~a
> +++ a/fs/ocfs2/cluster/masklog.h
> @@ -196,13 +196,14 @@ extern struct mlog_bits mlog_and_bits, m
>  	}								\
>  } while (0)
>  
> -#define mlog_errno(st) do {						\
> +#define mlog_errno(st) ({						\
>  	int _st = (st);							\
>  	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
>  	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC &&		\
>  	    _st != -EDQUOT)						\
>  		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
> -} while (0)
> +	st;								\
> +})
>  
>  #define mlog_bug_on_msg(cond, fmt, args...) do {			\
>  	if (cond) {							\
> _
> 
> 
> .
> 
