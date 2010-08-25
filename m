From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 25 Aug 2010 05:43:18 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: dynamically allocate lvb for
 dlm_lock_resource
In-Reply-To: <20100825123126.GA3134@laptop.jp.oracle.com>
References: <201008231056.o7N8ClUi002147@rcsinet13.oracle.com>
	<4C740ADC.9020506@oracle.com>
	<20100825123126.GA3134@laptop.jp.oracle.com>
Message-ID: <4C750FE6.2070207@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  On 8/25/2010 5:31 AM, Wengang Wang wrote:
> It looks we can't move it to the very top.
> The caller doesn't make sure we need to update lvb. In other words, it
> treat the lockres' that need lvb and those don't the same. We have to
> distinguish them in dlm_update_lvb() its self. And I think checking
> DLM_LKSB_GET_LVB flag is the right place to place the assertion.
>
> Or do you meant we should treat different type (lvb needed or no) of
> lockress differently in the callers?(though I don't think you meant this)

ok.

>
> Actually I alreay have another similar patch which dynamically allocates
> lvb for dlm_lock. dlm_alloc_lvb() is used in that patch. So allocating
> lvb is in a separated function.
> Since the patch for dlm_lock is much more complex than this one, I
> didn't post it out together before this one gets approved.
>
> Anyway if you persist, I can make it as you wanted.

Then post both the patches.
