From: Andreas Dilger <adilger@sun.com>
Date: Fri, 19 Sep 2008 15:46:25 -0600
Subject: [Ocfs2-devel] [PATCH] [RFC] jbd2: Add buffer triggers
In-Reply-To: <20080917232629.GB20752@mail.oracle.com>
References: <20080917232629.GB20752@mail.oracle.com>
Message-ID: <20080919214625.GK10950@webber.adilger.int>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org

On Sep 17, 2008  16:26 -0700, Joel Becker wrote:
> +	/* We have the actual buffer to go out, fire any commit trigger */
> +	/* XXX Checking trigger pointers here so as to skip kmap when
> +	 * empty */
> +	if (jh_in->b_triggers && jh_in->b_triggers->t_commit) {
> +		mapped_data = kmap_atomic(new_page, KM_USER0);
> +
> +		jbd2_buffer_commit_trigger(jh_in, mapped_data + new_offset);
> +		kunmap_atomic(mapped_data, KM_USER0);
> +	}

In many cases the kmap will not be needed (i.e. never for ext* because the
metadata buffers will always be allocated in low memory).

> index 8a62d1e..087a1c2 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -87,6 +89,9 @@ struct journal_head {
>  	struct journal_head *b_cpnext, *b_cpprev;
> +
> +	/* Trigger type */
> +	struct jbd2_buffer_trigger_type *b_triggers;
>  };

The journal-head.h header is shared between jbd.h and jbd2.h, so it seems
a bit strange to have a jbd2_* struct here.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
