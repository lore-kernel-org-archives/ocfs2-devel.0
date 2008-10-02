From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 1 Oct 2008 23:11:50 -0700
Subject: [Ocfs2-devel] [PATCH 03/39] ocfs2: throttle back local alloc
 when low on disk space
In-Reply-To: <1222293680-15451-4-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-4-git-send-email-mfasheh@suse.com>
Message-ID: <20081001231150.c1cd67b0.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

> On Wed, 24 Sep 2008 15:00:44 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
> +				      unsigned int num_clusters)
> +{
> +	spin_lock(&osb->osb_lock);
> +	if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
> +	    osb->local_alloc_state == OCFS2_LA_THROTTLED)
> +		if (num_clusters >= osb->local_alloc_default_bits) {
> +			cancel_delayed_work(&osb->la_enable_wq);
> +			osb->local_alloc_state = OCFS2_LA_ENABLED;
> +		}
> +	spin_unlock(&osb->osb_lock);
> +}
> +
> +void ocfs2_la_enable_worker(struct work_struct *work)
> +{
> +	struct ocfs2_super *osb =
> +		container_of(work, struct ocfs2_super,
> +			     la_enable_wq.work);
> +	spin_lock(&osb->osb_lock);
> +	osb->local_alloc_state = OCFS2_LA_ENABLED;
> +	spin_unlock(&osb->osb_lock);
> +}

cacnel_delayed_work() is a pretty risky function.  The work handler
(ocfs2_la_enable_worker) can execute an arbitrarily long time after
cancel_delayed_work() has returned.  Can all the code here cope with such a
surprise alteration of ->local_alloc_state()?

And you canot use cancel_delayed_work_sync() here due to a deadlock on
->osb_lock().
