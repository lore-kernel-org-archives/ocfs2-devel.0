From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 Dec 2014 13:35:01 -0800
Subject: [Ocfs2-devel] [PATCH 1/1 linux-next] ocfs2: remove unnecessary
 sizeof(char)
In-Reply-To: <1419275109-11641-1-git-send-email-fabf@skynet.be>
References: <1419275109-11641-1-git-send-email-fabf@skynet.be>
Message-ID: <20141222133501.916a0944e5f0719e60e2c4eb@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>

On Mon, 22 Dec 2014 20:05:09 +0100 Fabian Frederick <fabf@skynet.be> wrote:

> sizeof(char) is always 1.
> 
> ...
>
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -129,8 +129,8 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb)
>  	if (osb->replay_map)
>  		return 0;
>  
> -	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) +
> -			     (osb->max_slots * sizeof(char)), GFP_KERNEL);
> +	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) + osb->max_slots,
> +			     GFP_KERNEL);
>  
>  	if (!replay_map) {
>  		mlog_errno(-ENOMEM);

I dunno.  The code at present isn't particularly idiomatic, but it has
some documentation value and says "I know what I'm doing".

It would be better if it was

	kzalloc(sizeof(struct ocfs2_replay_map) *
		sizeof(struct ocfs2_replay_map.rm_replay_slots[0]), ...);

And it would be better if C permitted that ;)

	kzalloc(sizeof(struct ocfs2_replay_map) *
		sizeof((struct ocfs2_replay_map *)0)->rm_replay_slots[0]), ...);

yuk.
