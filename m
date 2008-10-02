From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 1 Oct 2008 23:11:44 -0700
Subject: [Ocfs2-devel] [PATCH 01/39] ocfs2: POSIX file locks support
In-Reply-To: <1222293680-15451-2-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-2-git-send-email-mfasheh@suse.com>
Message-ID: <20081001231144.87fa2a0b.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

> On Wed, 24 Sep 2008 15:00:42 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +int ocfs2_stack_supports_plocks(void)
> +{
> +	return !!(active_stack && active_stack->sp_ops->plock);
> +}

It's pointless doing !! on something which is already 0 or 1.
